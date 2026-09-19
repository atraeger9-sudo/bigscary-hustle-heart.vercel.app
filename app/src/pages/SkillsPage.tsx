import { useEffect, useState } from "react";
import { AppShell } from "../components/AppShell";
import { color, font } from "../theme/tokens";
import { supabase } from "../lib/supabase";

type SkillTree = { id: string; slug: string; name: string; category: string; description: string | null };

export function SkillsPage() {
  const [trees, setTrees] = useState<SkillTree[]>([]);

  useEffect(() => {
    supabase
      .from("skill_trees")
      .select("id, slug, name, category, description")
      .then(({ data }) => setTrees(data ?? []));
  }, []);

  return (
    <AppShell>
      <div style={{ padding: "20px 16px" }}>
        <p style={{ margin: 0, fontSize: 10, color: color.yellow, letterSpacing: "0.3em", fontFamily: font.condensed }}>
          SKILL TREES
        </p>
        <h1 style={{ margin: "2px 0 20px", fontSize: 26, fontFamily: font.display }}>Movement Skills</h1>

        {trees.map((t) => (
          <div key={t.id} style={{ background: color.card, border: `1px solid ${color.border}`, borderRadius: 12, padding: 16, marginBottom: 10 }}>
            <p style={{ margin: 0, fontSize: 16, fontFamily: font.condensed, fontWeight: 700 }}>{t.name}</p>
            <p style={{ margin: "4px 0 0", fontSize: 12, color: color.muted, fontFamily: font.body, lineHeight: 1.5 }}>{t.description}</p>
          </div>
        ))}
      </div>
    </AppShell>
  );
}
