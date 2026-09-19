import { useEffect, useState } from "react";
import { AppShell } from "../components/AppShell";
import { color, font } from "../theme/tokens";
import { supabase } from "../lib/supabase";
import { useAuth } from "../auth/AuthProvider";

type ProgramTemplate = { id: string; slug: string; name: string; description: string | null; days_per_week: number | null };

export function TrainPage() {
  const { user } = useAuth();
  const [templates, setTemplates] = useState<ProgramTemplate[]>([]);
  const [hasActiveProgram, setHasActiveProgram] = useState<boolean | null>(null);

  useEffect(() => {
    supabase
      .from("program_templates")
      .select("id, slug, name, description, days_per_week")
      .then(({ data }) => setTemplates(data ?? []));

    if (user) {
      supabase
        .from("programs")
        .select("id", { count: "exact", head: true })
        .eq("active", true)
        .then(({ count }) => setHasActiveProgram((count ?? 0) > 0));
    }
  }, [user]);

  return (
    <AppShell>
      <div style={{ padding: "20px 16px" }}>
        <p style={{ margin: 0, fontSize: 10, color: color.yellow, letterSpacing: "0.3em", fontFamily: font.condensed }}>
          TRAIN
        </p>
        <h1 style={{ margin: "2px 0 12px", fontSize: 26, fontFamily: font.display }}>Programs</h1>

        {hasActiveProgram === false && (
          <p style={{ fontSize: 12, color: color.muted, fontFamily: font.body, marginBottom: 14 }}>
            You don't have an active program yet. The personalized program generator (capability-gap engine) is a
            later build phase — for now, available program templates are listed below.
          </p>
        )}

        {templates.map((t) => (
          <div key={t.id} style={{ background: color.card, border: `1px solid ${color.border}`, borderRadius: 12, padding: 16, marginBottom: 10 }}>
            <p style={{ margin: 0, fontSize: 16, fontFamily: font.condensed, fontWeight: 700 }}>{t.name}</p>
            <p style={{ margin: "4px 0 0", fontSize: 12, color: color.muted, fontFamily: font.body, lineHeight: 1.5 }}>{t.description}</p>
            {t.days_per_week && (
              <p style={{ margin: "6px 0 0", fontSize: 11, color: color.yellow, fontFamily: font.condensed }}>
                {t.days_per_week} days / week
              </p>
            )}
          </div>
        ))}
      </div>
    </AppShell>
  );
}
