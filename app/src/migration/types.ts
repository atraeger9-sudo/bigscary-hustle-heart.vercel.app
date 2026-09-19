// Shape of the legacy localStorage blob written by the old app's `save(data, pin)`
// (see the retired index.html). Exported by the "Export My Data" button added
// to the legacy app so users can carry their history into the new schema.
export type LegacySet = {
  w?: string;
  r?: string;
  rir?: string;
  isWarmup?: boolean;
  isBurnout?: boolean;
  label?: string;
};

export type LegacyScan = { date: string; w: string; bf: string; m: string; n: string; ts: number };
export type LegacyWeightLog = { date: string; w: string; sleep: string; n: string; ts: number };
export type LegacyMeasurement = {
  date: string;
  waist: string;
  chest: string;
  rarm: string;
  larm: string;
  shoulder: string;
  n: string;
  ts: number;
};

export type LegacyExport = {
  exportedAt?: string;
  pin?: string;
  userName?: string;
  data: Record<string, unknown> & {
    weekOverride?: number;
    sessionNotes?: Record<string, string>;
    scans?: LegacyScan[];
    wlog?: LegacyWeightLog[];
    measurements?: LegacyMeasurement[];
  };
};

export type WeeklyExerciseLogKey = { phase: number; day: number; exercise: number; week: number };

const WEEKLY_KEY_RE = /^p(\d+)_d(\d+)_e(\d+)_w(\d+)$/;

export function parseWeeklyExerciseKey(key: string): WeeklyExerciseLogKey | null {
  const m = WEEKLY_KEY_RE.exec(key);
  if (!m) return null;
  return { phase: Number(m[1]), day: Number(m[2]), exercise: Number(m[3]), week: Number(m[4]) };
}
