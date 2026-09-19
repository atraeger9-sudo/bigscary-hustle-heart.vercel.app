import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { AppShell } from "../components/AppShell";
import { color, font } from "../theme/tokens";
import { supabase } from "../lib/supabase";
import { useAuth } from "../auth/AuthProvider";

type Goal = { id: string; goal_type: string; status: string };
type LatestScan = { recorded_at: string; weight: number | null; body_fat_pct: number | null };

export function TodayPage() {
  const { profile, user } = useAuth();
  const [goals, setGoals] = useState<Goal[]>([]);
  const [latestScan, setLatestScan] = useState<LatestScan | null>(null);
  const [hasImported, setHasImported] = useState<boolean | null>(null);

  useEffect(() => {
    if (!user) return;
    supabase
      .from("goals")
      .select("id, goal_type, status")
      .eq("status", "active")
      .then(({ data }) => setGoals(data ?? []));

    supabase
      .from("body_composition_scans")
      .select("recorded_at, weight, body_fat_pct")
      .order("recorded_at", { ascending: false })
      .limit(1)
      .then(({ data }) => setLatestScan(data?.[0] ?? null));

    supabase
      .from("migration_imports")
      .select("id", { count: "exact", head: true })
      .then(({ count }) => setHasImported((count ?? 0) > 0));
  }, [user]);

  return (
    <AppShell>
      <div style={{ padding: "20px 16px 10px" }}>
        <p style={{ margin: 0, fontSize: 10, color: color.yellow, letterSpacing: "0.3em", fontFamily: font.condensed }}>
          TODAY
        </p>
        <h1 style={{ margin: "2px 0 0", fontSize: 28, fontFamily: font.display, letterSpacing: "0.03em" }}>
          Hey {profile?.display_name ?? "there"}.
        </h1>
      </div>

      {hasImported === false && (
        <div style={{ margin: "0 16px 14px", background: color.card, border: `1px solid ${color.yellow}55`, borderRadius: 12, padding: 16 }}>
          <p style={{ margin: 0, fontSize: 14, fontFamily: font.condensed, color: color.yellow, fontWeight: 700 }}>
            Bring your training history over
          </p>
          <p style={{ margin: "6px 0 12px", fontSize: 12, color: color.steel, fontFamily: font.body, lineHeight: 1.5 }}>
            Export your data from the old app, then import it here so your lifts, scans, and logs don't start from zero.
          </p>
          <Link
            to="/import"
            style={{
              display: "inline-block",
              background: color.yellow,
              color: "#000",
              borderRadius: 8,
              padding: "8px 14px",
              fontSize: 12,
              fontFamily: font.condensed,
              fontWeight: 700,
              textDecoration: "none",
            }}
          >
            IMPORT MY DATA
          </Link>
        </div>
      )}

      <div style={{ margin: "0 16px 14px", background: color.card, border: `1px solid ${color.border}`, borderRadius: 12, padding: 16 }}>
        <p style={{ margin: 0, fontSize: 10, color: color.muted, letterSpacing: "0.15em", fontFamily: font.condensed, textTransform: "uppercase" }}>
          What should I train today?
        </p>
        <p style={{ margin: "8px 0 0", fontSize: 13, color: color.steel, fontFamily: font.body, lineHeight: 1.5 }}>
          Your program generator isn't wired up yet — this is where a personalized session, with the reason for
          each block, will appear once goals and a program exist for your account.
        </p>
      </div>

      <div style={{ margin: "0 16px 14px", background: color.card, border: `1px solid ${color.border}`, borderRadius: 12, padding: 16 }}>
        <p style={{ margin: 0, fontSize: 10, color: color.muted, letterSpacing: "0.15em", fontFamily: font.condensed, textTransform: "uppercase" }}>
          Progress
        </p>
        {latestScan ? (
          <p style={{ margin: "8px 0 0", fontSize: 13, color: color.text, fontFamily: font.body }}>
            Last scan ({new Date(latestScan.recorded_at).toLocaleDateString()}): {latestScan.weight ?? "—"} lb
            {latestScan.body_fat_pct ? `, ${latestScan.body_fat_pct}% body fat` : ""}
          </p>
        ) : (
          <p style={{ margin: "8px 0 0", fontSize: 13, color: color.muted, fontFamily: font.body }}>No scans logged yet.</p>
        )}
      </div>

      <div style={{ margin: "0 16px 14px", background: color.card, border: `1px solid ${color.border}`, borderRadius: 12, padding: 16 }}>
        <p style={{ margin: 0, fontSize: 10, color: color.muted, letterSpacing: "0.15em", fontFamily: font.condensed, textTransform: "uppercase" }}>
          Next
        </p>
        {goals.length ? (
          <ul style={{ margin: "8px 0 0", paddingLeft: 18, fontSize: 13, color: color.text, fontFamily: font.body }}>
            {goals.map((g) => (
              <li key={g.id}>{g.goal_type.replace(/_/g, " ")}</li>
            ))}
          </ul>
        ) : (
          <p style={{ margin: "8px 0 0", fontSize: 13, color: color.muted, fontFamily: font.body }}>
            No goals set yet. Add one in Settings.
          </p>
        )}
      </div>
    </AppShell>
  );
}
