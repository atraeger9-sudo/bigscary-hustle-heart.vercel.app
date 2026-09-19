import { useEffect, useState } from "react";
import { AppShell } from "../components/AppShell";
import { color, font } from "../theme/tokens";
import { supabase } from "../lib/supabase";
import { useAuth } from "../auth/AuthProvider";

type PR = { id: string; exercise_name_snapshot: string | null; record_type: string; value: number; unit: string | null; achieved_at: string };

export function ProgressPage() {
  const { user } = useAuth();
  const [prs, setPrs] = useState<PR[]>([]);

  useEffect(() => {
    if (!user) return;
    supabase
      .from("personal_records")
      .select("id, exercise_name_snapshot, record_type, value, unit, achieved_at")
      .order("achieved_at", { ascending: false })
      .limit(25)
      .then(({ data }) => setPrs(data ?? []));
  }, [user]);

  return (
    <AppShell>
      <div style={{ padding: "20px 16px" }}>
        <p style={{ margin: 0, fontSize: 10, color: color.yellow, letterSpacing: "0.3em", fontFamily: font.condensed }}>
          PROGRESS
        </p>
        <h1 style={{ margin: "2px 0 20px", fontSize: 26, fontFamily: font.display }}>Personal Records</h1>

        {prs.length === 0 && (
          <p style={{ fontSize: 13, color: color.muted, fontFamily: font.body }}>
            No personal records yet. Import your history or log a workout to start building this list.
          </p>
        )}
        {prs.map((pr) => (
          <div key={pr.id} style={{ background: color.card, border: `1px solid ${color.border}`, borderRadius: 10, padding: 12, marginBottom: 8, display: "flex", justifyContent: "space-between" }}>
            <div>
              <p style={{ margin: 0, fontSize: 13, fontFamily: font.condensed, color: color.text }}>
                {pr.exercise_name_snapshot ?? pr.record_type}
              </p>
              <p style={{ margin: 0, fontSize: 11, color: color.muted, fontFamily: font.body }}>
                {new Date(pr.achieved_at).toLocaleDateString()}
              </p>
            </div>
            <p style={{ margin: 0, fontSize: 15, fontFamily: font.condensed, color: color.yellow }}>
              {pr.value}
              {pr.unit ?? ""}
            </p>
          </div>
        ))}
      </div>
    </AppShell>
  );
}
