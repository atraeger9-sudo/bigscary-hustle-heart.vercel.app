import { useState, type FormEvent } from "react";
import { AppShell } from "../components/AppShell";
import { color, font } from "../theme/tokens";
import { supabase } from "../lib/supabase";
import { useAuth } from "../auth/AuthProvider";

const GOAL_TYPES = [
  "move_better",
  "build_muscle",
  "get_stronger",
  "improve_conditioning",
  "front_split",
  "handstand",
  "pistol_squat",
  "improve_hip_mobility",
  "improve_shoulder_mobility",
  "longevity",
];

export function SettingsPage() {
  const { profile, signOut } = useAuth();
  const [goalType, setGoalType] = useState(GOAL_TYPES[0]);
  const [saving, setSaving] = useState(false);
  const [saved, setSaved] = useState(false);

  const addGoal = async (e: FormEvent) => {
    e.preventDefault();
    setSaving(true);
    setSaved(false);
    const { error } = await supabase.from("goals").insert({ goal_type: goalType, user_id: profile?.id });
    setSaving(false);
    if (!error) setSaved(true);
  };

  return (
    <AppShell>
      <div style={{ padding: "20px 16px" }}>
        <p style={{ margin: 0, fontSize: 10, color: color.yellow, letterSpacing: "0.3em", fontFamily: font.condensed }}>
          SETTINGS
        </p>
        <h1 style={{ margin: "2px 0 20px", fontSize: 26, fontFamily: font.display }}>{profile?.display_name}</h1>

        <form onSubmit={addGoal} style={{ background: color.card, border: `1px solid ${color.border}`, borderRadius: 12, padding: 16, marginBottom: 16 }}>
          <p style={{ margin: "0 0 10px", fontSize: 12, fontFamily: font.condensed, color: color.text, textTransform: "uppercase", letterSpacing: "0.1em" }}>
            Add a goal
          </p>
          <select
            value={goalType}
            onChange={(e) => setGoalType(e.target.value)}
            style={{ width: "100%", background: color.surface, color: color.text, border: `1px solid ${color.border}`, borderRadius: 8, padding: 10, marginBottom: 10 }}
          >
            {GOAL_TYPES.map((g) => (
              <option key={g} value={g}>
                {g.replace(/_/g, " ")}
              </option>
            ))}
          </select>
          <button
            type="submit"
            disabled={saving}
            style={{ width: "100%", background: color.yellow, color: "#000", border: "none", borderRadius: 8, padding: 10, fontFamily: font.condensed, fontWeight: 700, cursor: "pointer" }}
          >
            {saving ? "Saving…" : "Add Goal"}
          </button>
          {saved && <p style={{ margin: "8px 0 0", fontSize: 12, color: color.greenBright }}>Goal added.</p>}
        </form>

        <button
          onClick={signOut}
          style={{ width: "100%", background: "none", border: `1px solid ${color.border}`, borderRadius: 8, padding: 12, color: color.red, fontFamily: font.condensed, cursor: "pointer" }}
        >
          SIGN OUT
        </button>
      </div>
    </AppShell>
  );
}
