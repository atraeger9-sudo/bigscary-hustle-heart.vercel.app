import { supabase } from "../lib/supabase";
import { parseWeeklyExerciseKey, type LegacyExport, type LegacySet } from "./types";

const PROGRAM_TEMPLATE_SLUG = "bigscary-4day-progressive-overload";
const PHASE_LABELS = ["Phase 1 — Recomp Foundation", "Phase 2 — Strength & Cut", "Phase 3 — Shred"];
// Legacy START_DATE / TRAINING_DAYS_OF_WEEK from index.html — used only to
// approximate a calendar date for historical weeks, since the legacy app
// never stored one. Exact weekday within a training week is unrecoverable.
const LEGACY_START_DATE = new Date("2026-06-09T00:00:00Z");

type StructureExercise = { exercise_slug: string | null; sets?: number; reps?: string | number };
type StructureDay = { day: string; label: string; exercises: StructureExercise[] };
type StructurePhase = { days: StructureDay[] };
type ProgramStructure = { phases: StructurePhase[] };

function num(v: unknown): number | null {
  const n = parseFloat(String(v));
  return Number.isFinite(n) ? n : null;
}
function int(v: unknown): number | null {
  const n = parseInt(String(v), 10);
  return Number.isFinite(n) ? n : null;
}
function weekApproxDate(week: number): string {
  const d = new Date(LEGACY_START_DATE);
  d.setUTCDate(d.getUTCDate() + (week - 1) * 7);
  return d.toISOString().slice(0, 10);
}

export type ImportSummary = {
  workoutsCreated: number;
  exerciseLogsCreated: number;
  scansImported: number;
  weightLogsImported: number;
  measurementsImported: number;
  supplementLogsImported: number;
  errors: string[];
};

export async function importLegacyData(userId: string, legacy: LegacyExport): Promise<ImportSummary> {
  const summary: ImportSummary = {
    workoutsCreated: 0,
    exerciseLogsCreated: 0,
    scansImported: 0,
    weightLogsImported: 0,
    measurementsImported: 0,
    supplementLogsImported: 0,
    errors: [],
  };

  const { data: template, error: templateError } = await supabase
    .from("program_templates")
    .select("id, structure")
    .eq("slug", PROGRAM_TEMPLATE_SLUG)
    .single();

  if (templateError || !template) {
    summary.errors.push("Could not load the reference program template — is the DB seeded? Skipping workout history import.");
  }
  const structure = template?.structure as ProgramStructure | undefined;

  // Resolve every exercise_slug referenced by the program into {id, name}.
  const exerciseBySlug = new Map<string, { id: string; name: string }>();
  if (structure) {
    const slugs = new Set<string>();
    structure.phases.forEach((p) => p.days.forEach((d) => d.exercises.forEach((e) => e.exercise_slug && slugs.add(e.exercise_slug))));
    const { data: exRows } = await supabase.from("exercises").select("id, slug, name").in("slug", Array.from(slugs));
    (exRows ?? []).forEach((r) => exerciseBySlug.set(r.slug, { id: r.id, name: r.name }));
  }

  // ── Group weekly exercise-log keys by (phase, day, week) ──────────────────
  type GroupKey = string;
  const groups = new Map<GroupKey, { phase: number; day: number; week: number; sets: Map<number, LegacySet[]> }>();
  for (const [key, value] of Object.entries(legacy.data)) {
    const parsed = parseWeeklyExerciseKey(key);
    if (!parsed) continue;
    const gKey = `${parsed.phase}_${parsed.day}_${parsed.week}`;
    if (!groups.has(gKey)) groups.set(gKey, { phase: parsed.phase, day: parsed.day, week: parsed.week, sets: new Map() });
    groups.get(gKey)!.sets.set(parsed.exercise, (value as LegacySet[]) ?? []);
  }

  if (structure) {
    for (const group of groups.values()) {
      const phaseStruct = structure.phases[group.phase];
      const dayStruct = phaseStruct?.days[group.day];
      if (!dayStruct) {
        summary.errors.push(`No matching program day for phase ${group.phase} day ${group.day} — skipped.`);
        continue;
      }
      const plannedDate = weekApproxDate(group.week);
      const { data: workout, error: workoutErr } = await supabase
        .from("workouts")
        .insert({
          user_id: userId,
          name: `${dayStruct.label} — Week ${group.week}`,
          blocks: [],
          planned_date: plannedDate,
          phase_label: PHASE_LABELS[group.phase] ?? `Phase ${group.phase + 1}`,
          week_number: group.week,
        })
        .select("id")
        .single();
      if (workoutErr || !workout) {
        summary.errors.push(`Failed to create workout for ${dayStruct.label} wk${group.week}: ${workoutErr?.message}`);
        continue;
      }
      summary.workoutsCreated++;

      const note = legacy.data.sessionNotes?.[`${group.phase}_${group.day}_w${group.week}`];
      const { data: session, error: sessionErr } = await supabase
        .from("workout_sessions")
        .insert({
          user_id: userId,
          workout_id: workout.id,
          started_at: `${plannedDate}T12:00:00Z`,
          completed_at: `${plannedDate}T13:00:00Z`,
          notes: note ?? null,
        })
        .select("id")
        .single();
      if (sessionErr || !session) {
        summary.errors.push(`Failed to create session for ${dayStruct.label} wk${group.week}: ${sessionErr?.message}`);
        continue;
      }

      for (const [exerciseIndex, rawSets] of group.sets.entries()) {
        const exStruct = dayStruct.exercises[exerciseIndex];
        if (!exStruct) continue;
        const resolved = exStruct.exercise_slug ? exerciseBySlug.get(exStruct.exercise_slug) : undefined;
        const sets = (rawSets ?? [])
          .filter((s) => s && (s.w || s.r))
          .map((s, i) => ({
            set_index: i,
            weight: num(s.w),
            reps: s.r ?? null,
            rir: int(s.rir),
            is_warmup: !!s.isWarmup,
            is_burnout: !!s.isBurnout,
          }));
        if (!sets.length) continue;
        const { error: logErr } = await supabase.from("exercise_logs").insert({
          user_id: userId,
          workout_session_id: session.id,
          exercise_id: resolved?.id ?? null,
          exercise_name_snapshot: resolved?.name ?? `Exercise ${exerciseIndex}`,
          order_index: exerciseIndex,
          sets,
        });
        if (logErr) summary.errors.push(`Failed to log exercise ${exerciseIndex} for wk${group.week}: ${logErr.message}`);
        else summary.exerciseLogsCreated++;
      }
    }
  }

  // ── Body composition scans ────────────────────────────────────────────────
  if (legacy.data.scans?.length) {
    const rows = legacy.data.scans.map((s) => ({
      user_id: userId,
      recorded_at: new Date(s.ts || s.date).toISOString(),
      weight: num(s.w),
      body_fat_pct: num(s.bf),
      muscle_mass: num(s.m),
      note: s.n || null,
    }));
    const { error } = await supabase.from("body_composition_scans").insert(rows);
    if (error) summary.errors.push(`Scans import failed: ${error.message}`);
    else summary.scansImported = rows.length;
  }

  // ── Daily weight/sleep logs ────────────────────────────────────────────────
  if (legacy.data.wlog?.length) {
    const rows = legacy.data.wlog.map((w) => ({
      user_id: userId,
      recorded_at: new Date(w.ts || w.date).toISOString(),
      weight: num(w.w),
      sleep_hours: num(w.sleep),
      note: w.n || null,
    }));
    const { error } = await supabase.from("daily_weight_logs").insert(rows);
    if (error) summary.errors.push(`Weight log import failed: ${error.message}`);
    else summary.weightLogsImported = rows.length;
  }

  // ── Tape measurements ──────────────────────────────────────────────────────
  if (legacy.data.measurements?.length) {
    const rows = legacy.data.measurements.map((m) => ({
      user_id: userId,
      recorded_at: new Date(m.ts || m.date).toISOString(),
      waist: num(m.waist),
      chest: num(m.chest),
      right_arm: num(m.rarm),
      left_arm: num(m.larm),
      shoulder: num(m.shoulder),
      note: m.n || null,
    }));
    const { error } = await supabase.from("body_measurements").insert(rows);
    if (error) summary.errors.push(`Measurements import failed: ${error.message}`);
    else summary.measurementsImported = rows.length;
  }

  // ── Daily supplement checklist ────────────────────────────────────────────
  const supplementRows: { user_id: string; log_date: string; supplement_key: string; checked: boolean }[] = [];
  for (const [key, value] of Object.entries(legacy.data)) {
    if (!key.startsWith("supps_")) continue;
    const dateStr = key.slice("supps_".length);
    const parsedDate = new Date(dateStr);
    if (Number.isNaN(parsedDate.getTime())) continue;
    const isoDate = parsedDate.toISOString().slice(0, 10);
    for (const [suppId, checked] of Object.entries(value as Record<string, boolean>)) {
      supplementRows.push({ user_id: userId, log_date: isoDate, supplement_key: suppId, checked: !!checked });
    }
  }
  if (supplementRows.length) {
    const { error } = await supabase.from("supplement_logs").upsert(supplementRows, { onConflict: "user_id,log_date,supplement_key" });
    if (error) summary.errors.push(`Supplement log import failed: ${error.message}`);
    else summary.supplementLogsImported = supplementRows.length;
  }

  await supabase.from("migration_imports").insert({
    user_id: userId,
    source: "legacy_localstorage_v4",
    raw_payload: legacy.data,
    summary,
  });

  return summary;
}
