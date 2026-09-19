import { createClient } from "@supabase/supabase-js";

const url = import.meta.env.VITE_SUPABASE_URL as string | undefined;
const anonKey = import.meta.env.VITE_SUPABASE_ANON_KEY as string | undefined;

if (!url || !anonKey) {
  // Fails loudly in dev rather than silently talking to nothing. See
  // /supabase/README.md for how to create a project and set these.
  // eslint-disable-next-line no-console
  console.error(
    "Missing VITE_SUPABASE_URL / VITE_SUPABASE_ANON_KEY. Copy app/.env.example to app/.env.local and fill in your Supabase project's values.",
  );
}

// A syntactically valid placeholder so createClient() doesn't throw and crash
// the whole app when env vars aren't set yet (e.g. local dev before Supabase
// is configured). Requests will simply fail until real values are provided.
export const supabase = createClient(url || "https://placeholder.supabase.co", anonKey || "placeholder-anon-key");
