# Database setup

This directory defines the Postgres schema for the rebuilt platform (Supabase
Postgres + Auth). See the root `README.md` for how this fits into the overall
architecture and rollout plan.

## 1. Create a Supabase project

1. Create a free project at https://supabase.com (free tier covers this
   phase — see section 31 of the project brief for the hosting rationale).
2. In **Project Settings -> API**, copy the **Project URL** and **anon
   public key**. You'll need these for `app/.env.local` (see `app/.env.example`).

## 2. Run the migrations

In the Supabase dashboard's **SQL Editor**, run, in order:

1. `migrations/0001_init.sql` — creates every table, the admin-role helper,
   the `handle_new_user` trigger (auto-creates a `profiles` row on signup),
   and Row Level Security policies on every table.
2. `seed/0001_foundation_content.sql` — populates the shared content tables
   (training domains, muscle groups, movement patterns) and imports the
   ~130 exercises, the 3-phase/4-day program structure, a starter handstand
   skill tree, and five baseline assessment templates carried over from the
   legacy app's hardcoded `WO`/`MOB` data.

Both files were validated end-to-end against a local Postgres 16 instance
(with a minimal `auth` schema stub standing in for Supabase Auth) before
being committed, so they're expected to apply cleanly as-is.

Alternatively, using the Supabase CLI: `supabase db push` from this
directory once linked to your project.

## 3. Configure the app

```
cd app
cp .env.example .env.local
# fill in VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY
npm install
npm run dev
```

## Why the schema looks the way it does

- **Shared vs. user data** (section 32/33 of the project brief): content
  tables (`exercises`, `program_templates`, `skill_trees`, …) are
  world-readable to any authenticated user but writable only by admins
  (`profiles.role = 'admin'`, checked via `public.is_admin()`). Every
  user-data table enforces `user_id = auth.uid()` via RLS — a user
  physically cannot read or write another user's row, enforced by Postgres
  itself, not application code.
- **Sets live in jsonb, not a 6th table.** `exercise_logs.sets` is a jsonb
  array of `{set_index, weight, reps, rir, tempo, is_warmup, is_burnout}`.
  A set is never queried independently of its exercise log, so a fully
  normalized `sets` table would add a join for no real benefit — jsonb is
  still indexable and queryable if that changes later.
- **Nothing about today's program is hard-coded.** Exercises, the
  progressive-overload program, skill trees, and assessments are rows, not
  code, so adding a new goal or methodology is a data change, not a
  redeploy — see section 35 of the project brief.
- **Program templates store exercise references by slug**, not by
  foreign-keying every jsonb entry — the app resolves `exercise_slug ->
  exercises.id` at read/import time. Keeps the structure JSON portable and
  human-readable while still letting the DB be the source of truth for
  exercise metadata.

## What's intentionally not here yet

This is the foundation phase only. Not yet implemented: the capability
graph's gap-computation logic, the program generator, mobility/flexibility
domain-specific scoring, and the admin CMS UI (the `is_admin()` /
`role='admin'` plumbing exists; there's no interface to use it yet). See the
root `README.md` build-order notes for what's next.
