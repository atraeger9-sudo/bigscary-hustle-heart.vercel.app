# Big & Scary — Physical Development Platform

This repo is mid-rebuild: a zero-build, single-file PWA (`index.html`,
localStorage-only, PIN auth) is being rebuilt into a real multi-user
platform on Supabase (Postgres + Auth), per the physical-development
platform project brief.

## Current state

| Path | What it is | Status |
|---|---|---|
| `index.html`, `manifest.json`, `sw.js`, `subscribe.js`, `send-notification.js` | The **legacy production app** — still live for the two real users on it. Do not remove until migration is confirmed complete. | Live |
| `app/` | The **new platform** — Vite + React + TypeScript + Supabase. | Foundation phase |
| `supabase/` | Postgres schema, RLS policies, and seed content for the new platform. | Foundation phase |

## Why a rebuild instead of extending the old app

The legacy app is a single ~2,000-line `index.html` compiled in-browser by
Babel, with two hard-coded users authenticated by a 4-digit PIN and all data
in localStorage. That was the right amount of engineering for a 4-day
lifting program used by two people. It cannot hold an extensible exercise
database, a capability graph, a program generator, or real accounts — there
are no module boundaries, no types, no tests, and no way to add a user
without editing source. The pivot to Supabase Auth + Postgres with Row
Level Security is intentional and final (see project brief section 0).

Vercel already runs this project; adding a build step to a project that's
already on Vercel isn't an infrastructure migration, so `app/` builds with
Vite and deploys through the same host — no need to move off Vercel to get
a real build pipeline (see project brief section 31 on not blindly
replacing infra that already works).

## Migration path for existing users' data

Andrew and Beaudy's training history lives only in their browsers'
localStorage — it isn't in this repo and can't be migrated by a script run
here. Instead:

1. In the **legacy app**, the **Track** tab now has an **Export My Data**
   button that downloads their full history (lifts, scans, weight log,
   measurements, supplement checklist) as a JSON file.
2. In the **new app**, the `/import` page (linked from the Today screen
   until an import is detected) accepts that file and writes it into the
   new schema — client-side, under the user's own authenticated session, so
   Row Level Security does the isolation and no service-role key is ever
   needed for this.
3. The importer (`app/src/migration/legacyImport.ts`) reconstructs each
   historical week's workout, session, and exercise logs by resolving the
   old phase/day/exercise indices against the seeded program template, and
   carries over body-composition scans, weight/sleep logs, tape
   measurements, and the daily supplement checklist. The raw export is also
   kept in `migration_imports.raw_payload` so a mapping bug can be
   re-processed without asking the user to re-export.

This has been validated against the schema and seed data but not yet run
against a real export file from either user — do that before decommissioning
the legacy app.

## Getting the new app running

See `supabase/README.md` for creating a Supabase project and running the
migrations, then:

```
cd app
cp .env.example .env.local   # fill in your Supabase project's URL + anon key
npm install
npm run dev
```

## What's built vs. what's next

This foundation phase covers build-order steps 1–7 from the project brief
(audit, architecture decision, auth, database + migration path, profiles,
design system, and the start of the exercise/workout model). It does
**not** yet include: the capability-gap engine, program generator,
assessments UI, skill-tree progression UI beyond a read-only list, AI
coach, or admin CMS. Those are later build phases — the schema
(`capability_profile`, `assessment_templates`, `skill_tree_levels`, the
`role='admin'` column) is already in place for them so they're additive
work, not more schema churn.
