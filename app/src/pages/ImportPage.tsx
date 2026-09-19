import { useState, type ChangeEvent } from "react";
import { AppShell } from "../components/AppShell";
import { color, font } from "../theme/tokens";
import { useAuth } from "../auth/AuthProvider";
import { importLegacyData, type ImportSummary } from "../migration/legacyImport";
import type { LegacyExport } from "../migration/types";

export function ImportPage() {
  const { user } = useAuth();
  const [busy, setBusy] = useState(false);
  const [summary, setSummary] = useState<ImportSummary | null>(null);
  const [error, setError] = useState<string | null>(null);

  const handleFile = async (e: ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file || !user) return;
    setBusy(true);
    setError(null);
    setSummary(null);
    try {
      const text = await file.text();
      const parsed = JSON.parse(text) as LegacyExport;
      if (!parsed.data) throw new Error("This doesn't look like a Big & Scary export file.");
      const result = await importLegacyData(user.id, parsed);
      setSummary(result);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Import failed.");
    } finally {
      setBusy(false);
    }
  };

  return (
    <AppShell>
      <div style={{ padding: "20px 16px" }}>
        <p style={{ margin: 0, fontSize: 10, color: color.yellow, letterSpacing: "0.3em", fontFamily: font.condensed }}>
          MIGRATION
        </p>
        <h1 style={{ margin: "2px 0 12px", fontSize: 26, fontFamily: font.display }}>Import Your History</h1>

        <ol style={{ fontSize: 13, color: color.steel, fontFamily: font.body, lineHeight: 1.7, paddingLeft: 18, marginBottom: 20 }}>
          <li>Open the old Big &amp; Scary app and sign in as usual.</li>
          <li>
            Go to the <strong>Track</strong> tab and tap <strong>Export My Data</strong> — it downloads a JSON file.
          </li>
          <li>Upload that file below.</li>
        </ol>

        <label
          style={{
            display: "block",
            textAlign: "center",
            background: color.card,
            border: `2px dashed ${color.border}`,
            borderRadius: 12,
            padding: 24,
            cursor: "pointer",
            fontFamily: font.condensed,
            color: color.yellow,
          }}
        >
          {busy ? "IMPORTING…" : "CHOOSE EXPORT FILE"}
          <input type="file" accept="application/json" onChange={handleFile} disabled={busy} style={{ display: "none" }} />
        </label>

        {error && (
          <p style={{ marginTop: 14, fontSize: 13, color: color.red, fontFamily: font.body }}>{error}</p>
        )}

        {summary && (
          <div style={{ marginTop: 16, background: color.card, border: `1px solid ${color.border}`, borderRadius: 12, padding: 16 }}>
            <p style={{ margin: "0 0 8px", fontSize: 13, fontFamily: font.condensed, color: color.greenBright }}>Import complete</p>
            <p style={{ margin: 0, fontSize: 12, color: color.steel, fontFamily: font.body, lineHeight: 1.7 }}>
              {summary.workoutsCreated} workouts · {summary.exerciseLogsCreated} exercise logs · {summary.scansImported} scans ·{" "}
              {summary.weightLogsImported} weight logs · {summary.measurementsImported} measurements ·{" "}
              {summary.supplementLogsImported} supplement checks
            </p>
            {summary.errors.length > 0 && (
              <div style={{ marginTop: 10 }}>
                {summary.errors.map((e, i) => (
                  <p key={i} style={{ margin: 0, fontSize: 11, color: color.orange, fontFamily: font.body }}>
                    {e}
                  </p>
                ))}
              </div>
            )}
          </div>
        )}
      </div>
    </AppShell>
  );
}
