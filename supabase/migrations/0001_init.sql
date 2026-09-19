-- ============================================================================
-- Physical Development Platform — Foundation Schema
-- ============================================================================
-- Design principles (see /supabase/README.md for the full rationale):
--   * SHARED tables hold content anyone can read but only admins can write
--     (exercises, programs, skill trees, education, methodologies).
--   * USER tables hold one person's data, protected by Row Level Security
--     so a user can only ever read/write rows where user_id = auth.uid().
--   * Per-set logging data (weight/reps/rir/tempo/etc.) is stored as jsonb
--     inside exercise_logs.sets rather than a 6th-normal-form sets table.
--     Postgres jsonb is fully queryable/indexable, and a set is never
--     addressed independently of its exercise log — a separate table would
--     be pure ceremony for no real query benefit at this stage.
--   * Nothing here hard-codes today's 4-day program: exercises, programs,
--     skill trees, and assessments are all data, not code.
-- ============================================================================

create extension if not exists "pgcrypto";

-- ─── Helper: admin check ────────────────────────────────────────────────────
-- profiles.role is checked by RLS policies on shared tables. Defined before
-- profiles is created is fine in Postgres (function body isn't checked until
-- first call), but we create it after profiles below for clarity instead.

-- ============================================================================
-- SHARED CONTENT (admin-writable, world-readable to authenticated users)
-- ============================================================================

create table public.muscle_groups (
  id            uuid primary key default gen_random_uuid(),
  slug          text unique not null,
  name          text not null,
  body_region   text not null check (body_region in ('upper','lower','core','full_body')),
  created_at    timestamptz not null default now()
);

create table public.movement_patterns (
  id            uuid primary key default gen_random_uuid(),
  slug          text unique not null,
  name          text not null,
  description   text
);

create table public.training_domains (
  id            uuid primary key default gen_random_uuid(),
  slug          text unique not null,   -- reset | restore | mobilize | control | strengthen | master | build | perform
  name          text not null,
  description   text,
  sort_order    int not null default 0
);

create table public.equipment (
  id            uuid primary key default gen_random_uuid(),
  slug          text unique not null,
  name          text not null
);

create table public.skill_trees (
  id            uuid primary key default gen_random_uuid(),
  slug          text unique not null,        -- handstand | front-split | pistol-squat | l-sit ...
  name          text not null,
  category      text not null,               -- upper | lower | full_body
  description   text,
  created_at    timestamptz not null default now()
);

create table public.skill_tree_levels (
  id              uuid primary key default gen_random_uuid(),
  skill_tree_id   uuid not null references public.skill_trees(id) on delete cascade,
  level_index     int not null,
  title           text not null,
  description     text,
  exercise_ids    jsonb not null default '[]'::jsonb,   -- array of exercise uuids used to train this level
  unlock_criteria jsonb not null default '{}'::jsonb,   -- e.g. {"hold_seconds": 10, "sets": 3}
  unique (skill_tree_id, level_index)
);

create table public.exercises (
  id                      uuid primary key default gen_random_uuid(),
  slug                    text unique not null,
  name                    text not null,
  description             text,
  category                text not null,   -- mobility | flexibility | strength | hypertrophy | skill | conditioning | reset | warmup
  training_domain_id      uuid references public.training_domains(id),
  body_region             text,            -- upper | lower | core | full_body
  primary_muscle_ids      jsonb not null default '[]'::jsonb,
  secondary_muscle_ids    jsonb not null default '[]'::jsonb,
  joints                  jsonb not null default '[]'::jsonb,
  movement_pattern_id     uuid references public.movement_patterns(id),
  equipment_ids           jsonb not null default '[]'::jsonb,
  difficulty              int check (difficulty between 1 and 5),
  skill_requirement       int check (skill_requirement between 0 and 5) default 0,
  mobility_requirement    int check (mobility_requirement between 0 and 5) default 0,
  strength_requirement    int check (strength_requirement between 0 and 5) default 0,
  flexibility_requirement int check (flexibility_requirement between 0 and 5) default 0,
  stability_requirement   int check (stability_requirement between 0 and 5) default 0,
  balance_requirement     int check (balance_requirement between 0 and 5) default 0,
  coordination_requirement int check (coordination_requirement between 0 and 5) default 0,
  default_sets            int,
  default_reps            text,             -- text because "10 ea" / "AMRAP" / "90s" all appear in real programming
  default_duration_seconds int,
  default_tempo           text,
  default_rest_seconds    int,
  default_rpe             numeric(3,1),
  default_rir             int,
  progression_exercise_id uuid references public.exercises(id),
  regression_exercise_id  uuid references public.exercises(id),
  prerequisite_exercise_ids jsonb not null default '[]'::jsonb,
  coaching_cues           jsonb not null default '[]'::jsonb,
  common_mistakes         jsonb not null default '[]'::jsonb,
  safety_considerations   text,
  evidence_level          text not null default 'practitioner_based'
                          check (evidence_level in ('high_confidence','moderate_confidence','emerging','practitioner_based','unsupported')),
  primary_objective       text,             -- e.g. "handstand skill", "hamstring end-range strength"
  is_warmup               boolean not null default false,
  created_by              uuid references auth.users(id),
  created_at              timestamptz not null default now(),
  updated_at              timestamptz not null default now()
);
create index exercises_training_domain_idx on public.exercises(training_domain_id);
create index exercises_category_idx on public.exercises(category);

create table public.assessment_templates (
  id            uuid primary key default gen_random_uuid(),
  slug          text unique not null,
  name          text not null,
  area          text not null,     -- ankles | hips | shoulders | squat | balance | core | active_flexibility ...
  description   text,
  instructions  text,
  scoring_schema jsonb not null default '{}'::jsonb,
  created_at    timestamptz not null default now()
);

create table public.program_templates (
  id            uuid primary key default gen_random_uuid(),
  slug          text unique not null,
  name          text not null,
  description   text,
  methodology   text,                     -- e.g. "linear progressive overload", "upper/lower"
  goal_tags     jsonb not null default '[]'::jsonb,
  days_per_week int,
  structure     jsonb not null default '{}'::jsonb,  -- full day/block/exercise structure
  evidence_level text not null default 'practitioner_based'
                 check (evidence_level in ('high_confidence','moderate_confidence','emerging','practitioner_based','unsupported')),
  created_by    uuid references auth.users(id),
  created_at    timestamptz not null default now()
);

create table public.educational_content (
  id            uuid primary key default gen_random_uuid(),
  slug          text unique not null,
  title         text not null,
  body_markdown text not null,
  category      text,
  evidence_level text not null default 'practitioner_based'
                 check (evidence_level in ('high_confidence','moderate_confidence','emerging','practitioner_based','unsupported')),
  related_exercise_ids jsonb not null default '[]'::jsonb,
  created_at    timestamptz not null default now()
);

create table public.training_methodologies (
  id                uuid primary key default gen_random_uuid(),
  slug              text unique not null,
  name              text not null,
  description       text,
  evidence_summary  text,
  confidence_level  text not null default 'practitioner_based'
                    check (confidence_level in ('high_confidence','moderate_confidence','emerging','practitioner_based','unsupported')),
  appropriate_population text,
  risks             text
);

-- ============================================================================
-- USER PROFILE (1:1 with auth.users)
-- ============================================================================

create table public.profiles (
  id                    uuid primary key references auth.users(id) on delete cascade,
  display_name          text not null,
  role                  text not null default 'user' check (role in ('user','admin')),
  date_of_birth         date,
  experience_level      text check (experience_level in ('beginner','general_fitness','gym','advanced_movement','performance')),
  activity_level        text,
  days_per_week         int,
  session_duration_minutes int,
  equipment_access      jsonb not null default '[]'::jsonb,
  unit_preference       text not null default 'lb' check (unit_preference in ('lb','kg')),
  onboarding_completed  boolean not null default false,
  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now()
);

-- admin helper, defined now that profiles exists
create or replace function public.is_admin(uid uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (select 1 from public.profiles p where p.id = uid and p.role = 'admin');
$$;

-- auto-create a profile row when a new auth user signs up
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, display_name)
  values (new.id, coalesce(new.raw_user_meta_data->>'display_name', split_part(new.email, '@', 1)));
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ============================================================================
-- USER DATA
-- ============================================================================

create table public.goals (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references public.profiles(id) on delete cascade,
  goal_type     text not null,          -- e.g. "build_muscle", "front_split", "handstand", "move_better"
  skill_tree_id uuid references public.skill_trees(id),
  priority      int not null default 1,
  status        text not null default 'active' check (status in ('active','achieved','paused','dropped')),
  target_date   date,
  notes         text,
  created_at    timestamptz not null default now()
);

create table public.limitations (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references public.profiles(id) on delete cascade,
  body_region   text not null,
  description   text not null,     -- user-reported only; never a diagnosis
  created_at    timestamptz not null default now()
);

create table public.assessments (
  id                      uuid primary key default gen_random_uuid(),
  user_id                 uuid not null references public.profiles(id) on delete cascade,
  assessment_template_id  uuid references public.assessment_templates(id),
  completed_at            timestamptz not null default now(),
  notes                   text
);

create table public.assessment_results (
  id            uuid primary key default gen_random_uuid(),
  assessment_id uuid not null references public.assessments(id) on delete cascade,
  user_id       uuid not null references public.profiles(id) on delete cascade,
  area          text not null,
  score         numeric,
  unit          text,
  notes         text
);

-- The capability graph's "current capability" side. capability_key is a
-- stable string (e.g. "shoulder_flexion_active", "hamstring_passive_rom")
-- shared with skill_tree unlock_criteria and program-generation logic.
create table public.capability_profile (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null references public.profiles(id) on delete cascade,
  capability_key text not null,
  current_level  numeric not null,
  unit           text,
  evidence       jsonb not null default '{}'::jsonb,   -- e.g. {"source": "assessment", "assessment_id": "..."}
  updated_at     timestamptz not null default now(),
  unique (user_id, capability_key)
);

create table public.programs (
  id                  uuid primary key default gen_random_uuid(),
  user_id             uuid not null references public.profiles(id) on delete cascade,
  name                text not null,
  methodology         text,
  goal_tags           jsonb not null default '[]'::jsonb,
  structure           jsonb not null default '{}'::jsonb,
  source_template_id  uuid references public.program_templates(id),
  active              boolean not null default true,
  started_at          date,
  created_at          timestamptz not null default now()
);

create table public.workouts (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references public.profiles(id) on delete cascade,
  program_id    uuid references public.programs(id) on delete set null,
  name          text not null,
  blocks        jsonb not null default '[]'::jsonb,  -- ordered [{type: 'warmup'|'mobility'|'strength'|..., exercise_id, prescription}]
  planned_date  date,
  phase_label   text,
  week_number   int,
  created_at    timestamptz not null default now()
);

create table public.workout_sessions (
  id                  uuid primary key default gen_random_uuid(),
  user_id             uuid not null references public.profiles(id) on delete cascade,
  workout_id          uuid references public.workouts(id) on delete set null,
  started_at          timestamptz not null default now(),
  completed_at        timestamptz,
  perceived_exertion  int check (perceived_exertion between 1 and 10),
  energy_level        int check (energy_level between 1 and 10),
  recovery_rating     int check (recovery_rating between 1 and 10),
  stiffness_rating    int check (stiffness_rating between 1 and 10),
  confidence_rating   int check (confidence_rating between 1 and 10),
  discomfort_flags    jsonb not null default '[]'::jsonb,
  notes               text
);

create table public.exercise_logs (
  id                    uuid primary key default gen_random_uuid(),
  user_id               uuid not null references public.profiles(id) on delete cascade,
  workout_session_id    uuid not null references public.workout_sessions(id) on delete cascade,
  exercise_id           uuid references public.exercises(id),
  exercise_name_snapshot text not null,   -- survives exercise renames/deletes
  order_index           int not null default 0,
  -- sets: [{set_index, weight, reps, duration_seconds, rir, rpe, tempo, rest_seconds, is_warmup, is_burnout}]
  sets                  jsonb not null default '[]'::jsonb,
  created_at            timestamptz not null default now()
);
create index exercise_logs_session_idx on public.exercise_logs(workout_session_id);
create index exercise_logs_user_idx on public.exercise_logs(user_id);

create table public.personal_records (
  id                  uuid primary key default gen_random_uuid(),
  user_id             uuid not null references public.profiles(id) on delete cascade,
  exercise_id         uuid references public.exercises(id),
  exercise_name_snapshot text,
  record_type         text not null,   -- '1rm_estimate' | 'max_weight' | 'max_reps' | 'max_hold_seconds' | 'skill_milestone'
  value                numeric not null,
  unit                text,
  achieved_at         timestamptz not null default now(),
  workout_session_id  uuid references public.workout_sessions(id)
);

create table public.skill_progress (
  id                  uuid primary key default gen_random_uuid(),
  user_id             uuid not null references public.profiles(id) on delete cascade,
  skill_tree_id       uuid not null references public.skill_trees(id),
  current_level_index int not null default 0,
  hold_duration_seconds numeric,
  last_practiced_at   timestamptz,
  notes               text,
  unique (user_id, skill_tree_id)
);

create table public.mobility_measurements (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null references public.profiles(id) on delete cascade,
  area            text not null,        -- e.g. "hip_flexion", "shoulder_external_rotation"
  measurement_type text not null check (measurement_type in ('passive_rom','active_rom','end_range_strength','mobility_score')),
  value           numeric not null,
  unit            text not null default 'deg',
  recorded_at     timestamptz not null default now()
);

-- Body-composition scans (e.g. Hume smart scale), migrated from legacy `scans`
create table public.body_composition_scans (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null references public.profiles(id) on delete cascade,
  recorded_at    timestamptz not null default now(),
  weight         numeric,
  body_fat_pct   numeric,
  muscle_mass    numeric,
  note           text
);

-- Daily weight/sleep log, migrated from legacy `wlog`
create table public.daily_weight_logs (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references public.profiles(id) on delete cascade,
  recorded_at   timestamptz not null default now(),
  weight        numeric,
  sleep_hours   numeric,
  note          text
);

-- Tape measurements, migrated from legacy `measurements`
create table public.body_measurements (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references public.profiles(id) on delete cascade,
  recorded_at   timestamptz not null default now(),
  waist         numeric,
  chest         numeric,
  right_arm     numeric,
  left_arm      numeric,
  shoulder      numeric,
  note          text
);

-- Daily supplement checklist, migrated from legacy `supps_{date}` keys
create table public.supplement_logs (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references public.profiles(id) on delete cascade,
  log_date      date not null,
  supplement_key text not null,
  checked       boolean not null default true,
  unique (user_id, log_date, supplement_key)
);

create table public.recovery_feedback (
  id                  uuid primary key default gen_random_uuid(),
  user_id             uuid not null references public.profiles(id) on delete cascade,
  workout_session_id  uuid references public.workout_sessions(id) on delete cascade,
  metric              text not null,   -- 'difficulty' | 'range' | 'confidence' | ...
  value               numeric not null,
  recorded_at         timestamptz not null default now()
);

create table public.preferences (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references public.profiles(id) on delete cascade,
  key         text not null,
  value       jsonb not null,
  unique (user_id, key)
);

-- Audit trail of the one-time localStorage -> Postgres migration (section 0).
-- Keeps the raw legacy export so a bad mapping can be re-run without asking
-- the user to dig up their export file again.
create table public.migration_imports (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references public.profiles(id) on delete cascade,
  source        text not null default 'legacy_localstorage_v4',
  imported_at   timestamptz not null default now(),
  raw_payload   jsonb not null,
  summary       jsonb not null default '{}'::jsonb
);

-- ============================================================================
-- ROW LEVEL SECURITY
-- ============================================================================

alter table public.muscle_groups enable row level security;
alter table public.movement_patterns enable row level security;
alter table public.training_domains enable row level security;
alter table public.equipment enable row level security;
alter table public.skill_trees enable row level security;
alter table public.skill_tree_levels enable row level security;
alter table public.exercises enable row level security;
alter table public.assessment_templates enable row level security;
alter table public.program_templates enable row level security;
alter table public.educational_content enable row level security;
alter table public.training_methodologies enable row level security;

-- Shared content: anyone signed in can read; only admins can write.
do $$
declare t text;
begin
  foreach t in array array[
    'muscle_groups','movement_patterns','training_domains','equipment',
    'skill_trees','skill_tree_levels','exercises','assessment_templates',
    'program_templates','educational_content','training_methodologies'
  ]
  loop
    execute format('create policy "%1$s_read_all" on public.%1$s for select using (auth.role() = ''authenticated'')', t);
    execute format('create policy "%1$s_admin_write" on public.%1$s for all using (public.is_admin(auth.uid())) with check (public.is_admin(auth.uid()))', t);
  end loop;
end $$;

alter table public.profiles enable row level security;
create policy "profiles_self_select" on public.profiles for select using (auth.uid() = id or public.is_admin(auth.uid()));
create policy "profiles_self_update" on public.profiles for update using (auth.uid() = id) with check (auth.uid() = id);
-- insert happens only via the handle_new_user() trigger (security definer), no client insert policy needed.

-- User-owned tables: strict `user_id = auth.uid()` isolation.
do $$
declare t text;
begin
  foreach t in array array[
    'goals','limitations','assessments','assessment_results','capability_profile',
    'programs','workouts','workout_sessions','exercise_logs','personal_records',
    'skill_progress','mobility_measurements','body_composition_scans',
    'daily_weight_logs','body_measurements','supplement_logs','recovery_feedback',
    'preferences','migration_imports'
  ]
  loop
    execute format('alter table public.%1$s enable row level security', t);
    execute format('create policy "%1$s_owner_all" on public.%1$s for all using (auth.uid() = user_id) with check (auth.uid() = user_id)', t);
  end loop;
end $$;
