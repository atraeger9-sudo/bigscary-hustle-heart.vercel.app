-- ============================================================================
-- Foundation content seed
-- ============================================================================
-- Run after 0001_init.sql. Populates the shared taxonomy plus the exercises,
-- and program structure carried over from the legacy Big & Scary app so
-- Andrew and Beaudy's program keeps working on the new schema, and gives
-- the new platform its first real (not placeholder) content to build on.
-- ============================================================================

-- ─── Training domains (RESET → RESTORE → MOBILIZE → CONTROL → STRENGTHEN → MASTER → BUILD → PERFORM) ───
insert into public.training_domains (slug, name, description, sort_order) values
  ('reset',      'Reset',      'Downregulation, breathing, relaxation, preparation.', 1),
  ('restore',    'Restore',    'Foundational movement: gentle joint movement, basic mobility, body awareness.', 2),
  ('mobilize',   'Mobilize',   'Usable range: dynamic mobility, active range, controlled articular movement.', 3),
  ('control',    'Control',    'Owning range: end-range isometrics, controlled eccentrics, proprioception.', 4),
  ('strengthen', 'Strengthen', 'Strength within range: end-range strength, eccentrics, loaded mobility.', 5),
  ('master',     'Master',     'Advanced movement skills: splits, handstands, L-sits, advanced balances.', 6),
  ('build',      'Build',      'Hypertrophy and general strength development.', 7),
  ('perform',    'Perform',    'Power, conditioning, speed, work capacity.', 8)
on conflict (slug) do nothing;

-- ─── Muscle groups ───
insert into public.muscle_groups (slug, name, body_region) values
  ('chest','Chest','upper'), ('shoulders','Shoulders','upper'), ('back','Back','upper'),
  ('biceps','Biceps','upper'), ('triceps','Triceps','upper'), ('forearms','Forearms','upper'),
  ('core','Core','core'), ('glutes','Glutes','lower'), ('hamstrings','Hamstrings','lower'),
  ('quads','Quads','lower'), ('calves','Calves','lower'), ('hip_flexors','Hip Flexors','lower'),
  ('adductors','Adductors','lower')
on conflict (slug) do nothing;

-- ─── Movement patterns ───
insert into public.movement_patterns (slug, name, description) values
  ('squat','Squat','Knee- and hip-dominant bilateral bend.'),
  ('hinge','Hinge','Hip-dominant posterior chain pattern.'),
  ('lunge','Lunge','Unilateral squat/split-stance pattern.'),
  ('horizontal_push','Horizontal Push','Pressing away from the torso, horizontal plane.'),
  ('vertical_push','Vertical Push','Pressing overhead.'),
  ('horizontal_pull','Horizontal Pull','Rowing toward the torso.'),
  ('vertical_pull','Vertical Pull','Pulling down/up, e.g. pull-ups.'),
  ('carry','Carry','Loaded locomotion.'),
  ('rotation','Rotation/Anti-rotation','Trunk rotation or resisting rotation.'),
  ('gait','Gait/Locomotion','Walking, running, crawling patterns.')
on conflict (slug) do nothing;

-- Auto-generated from legacy index.html WO + MOB data. See supabase/README.md.

insert into public.exercises (slug, name, description, category, body_region, is_warmup, default_sets, default_reps, safety_considerations, evidence_level, primary_objective) values
  ('arm-circles', 'Arm Circles', 'Small to large. Lubricates shoulder joint before any pressing.', 'warmup', 'upper', true, null, null, null, 'practitioner_based', 'warmup'),
  ('band-pull-apart', 'Band Pull-Apart', 'Activates rear delts and rotator cuff. Essential before pressing.', 'warmup', 'upper', true, null, null, null, 'practitioner_based', 'warmup'),
  ('wall-slide', 'Wall Slide', 'Stand against wall, slide arms overhead. Unlocks thoracic and shoulder mobility.', 'warmup', 'upper', true, null, null, null, 'practitioner_based', 'warmup'),
  ('scapular-push-up', 'Scapular Push-Up', 'Plank position, protract and retract shoulder blades. Activates serratus anterior.', 'warmup', 'upper', true, null, null, null, 'practitioner_based', 'warmup'),
  ('band-lat-pulldown', 'Band Lat Pulldown', 'Anchor band overhead, pull down. Warms up lats before rows.', 'warmup', 'upper', true, null, null, null, 'practitioner_based', 'warmup'),
  ('cuban-press-light', 'Cuban Press (light)', 'External rotation + press. The single best AC joint warm-up exercise.', 'warmup', 'upper', true, null, null, null, 'practitioner_based', 'warmup'),
  ('landmine-press', 'Landmine Press', 'AC-joint safe. Full ROM. Best shoulder builder for your situation.', 'strength', 'upper', false, 4, '10 ea', 'Caution: shoulder', 'practitioner_based', 'strength'),
  ('chest-supported-db-row', 'Chest-Supported DB Row', 'Trunk muscle LOW. Rows are #1 priority. Go heavy every session.', 'strength', 'upper', false, 4, '12', null, 'practitioner_based', 'strength'),
  ('db-floor-press', 'DB Floor Press', 'Limits dangerous ROM. Loads chest hard without AC stress.', 'strength', 'upper', false, 3, '12', 'Caution: shoulder', 'practitioner_based', 'strength'),
  ('face-pull-cable', 'Face Pull (cable)', 'Rotator cuff + rear delt health. Every upper session. Never skip.', 'strength', 'upper', false, 4, '15', 'Caution: shoulder', 'practitioner_based', 'strength'),
  ('incline-db-curl', 'Incline DB Curl', 'Long head bicep stretch at bottom. Arms that fill a sleeve.', 'strength', 'upper', false, 3, '12', null, 'practitioner_based', 'strength'),
  ('cable-tricep-pushdown', 'Cable Tricep Pushdown', 'Lateral head = arm width. Control the eccentric.', 'strength', 'upper', false, 3, '15', null, 'practitioner_based', 'strength'),
  ('dead-bug', 'Dead Bug', 'Core foundation. Low back stays glued. Breathe out on extension.', 'mobility', 'upper', false, 3, '8 ea', null, 'practitioner_based', 'mobility'),
  ('glute-bridge-bodyweight', 'Glute Bridge (bodyweight)', 'Activates glutes before heavy hip thrusts. Hold 2s at top.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('banded-clamshell', 'Banded Clamshell', 'Hip abductor activation. Protects the knee during all lower movements.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('banded-monster-walk', 'Banded Monster Walk', 'Glute med activation. Band above knees, walk laterally.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('leg-curl-lying-light', 'Leg Curl (lying, light)', 'Warms up hamstrings before RDLs. Very light weight.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('ankle-circles', 'Ankle Circles', 'Loosens ankles for better hip hinge mechanics.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('reverse-hyper-or-good-morning-bw', 'Reverse Hyper or Good Morning (BW)', 'Activates entire posterior chain. Primes glutes and hamstrings.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('hip-90-90-mobility', 'Hip 90/90 Mobility', 'ALWAYS first. Non-negotiable for your hips and knees.', 'mobility', 'lower', false, 2, '90s ea', 'Caution: hip', 'practitioner_based', 'mobility'),
  ('hip-thrust-barbell', 'Hip Thrust (barbell)', 'Glutes without knee stress. Load heavy. Trunk mass builder.', 'strength', 'lower', false, 4, '12', 'Caution: knee', 'practitioner_based', 'strength'),
  ('romanian-deadlift', 'Romanian Deadlift', 'Hinge pattern. Minimal knee load. Go heavy.', 'strength', 'lower', false, 4, '10', 'Caution: knee', 'practitioner_based', 'strength'),
  ('leg-press-high-foot', 'Leg Press (high foot)', 'High placement = less patellar stress. Slow descent.', 'strength', 'lower', false, 3, '15', 'Caution: knee', 'practitioner_based', 'strength'),
  ('seated-leg-curl', 'Seated Leg Curl', 'Isolate hamstrings. Controls patellar tendon load.', 'strength', 'lower', false, 3, '12', 'Caution: knee', 'practitioner_based', 'strength'),
  ('calf-raise-standing', 'Calf Raise (standing)', 'Tight calves worsen patella pain. Stretch at bottom.', 'strength', 'lower', false, 3, '20', 'Caution: foot', 'practitioner_based', 'strength'),
  ('pallof-press-cable', 'Pallof Press (cable)', 'Anti-rotation core. Trunk mass attack.', 'strength', 'lower', false, 3, '10 ea', null, 'practitioner_based', 'strength'),
  ('dead-hang', 'Dead Hang', 'Decompresses spine, stretches lats, activates grip. Perfect pull day warm-up.', 'warmup', 'upper', true, null, null, null, 'practitioner_based', 'warmup'),
  ('scapular-pull-up', 'Scapular Pull-Up', 'Hang from bar, retract shoulder blades without bending elbows. Activates lower traps.', 'warmup', 'upper', true, null, null, null, 'practitioner_based', 'warmup'),
  ('face-pull-light', 'Face Pull (light)', 'Very light weight. Warms up rear delts and external rotators.', 'warmup', 'upper', true, null, null, null, 'practitioner_based', 'warmup'),
  ('straight-arm-pulldown-light', 'Straight-Arm Pulldown (light)', 'Activates lats in isolation before compound pulling.', 'warmup', 'upper', true, null, null, null, 'practitioner_based', 'warmup'),
  ('prone-y-t-w', 'Prone Y-T-W', 'Lie face down, make Y T and W shapes with arms. Activates all scapular stabilizers.', 'warmup', 'upper', true, null, null, null, 'practitioner_based', 'warmup'),
  ('neutral-grip-pull-up', 'Neutral-Grip Pull-Up', 'Neutral grip protects AC joint. Width that looks scary.', 'strength', 'upper', false, 4, '6-10', 'Caution: shoulder', 'practitioner_based', 'strength'),
  ('seated-cable-row-wide', 'Seated Cable Row (wide)', 'Trunk muscle LOW. Attack every session.', 'strength', 'upper', false, 4, '12', null, 'practitioner_based', 'strength'),
  ('landmine-row', 'Landmine Row', 'Shoulder-safe heavy rowing. One arm, explosive pull.', 'strength', 'upper', false, 3, '10 ea', 'Caution: shoulder', 'practitioner_based', 'strength'),
  ('db-lateral-raise', 'DB Lateral Raise', 'Capped delts = big and scary silhouette. Light, strict form.', 'strength', 'upper', false, 4, '15', 'Caution: shoulder', 'practitioner_based', 'strength'),
  ('hammer-curl', 'Hammer Curl', 'Brachialis = arm thickness from all angles.', 'strength', 'upper', false, 3, '12', null, 'practitioner_based', 'strength'),
  ('oh-cable-tricep-ext', 'OH Cable Tricep Ext', 'Long head mass. Elbows tight.', 'strength', 'upper', false, 3, '12', 'Caution: shoulder', 'practitioner_based', 'strength'),
  ('ab-wheel-rollout', 'Ab Wheel Rollout', 'Best core exercise. Hips do not drop.', 'mobility', 'upper', false, 3, '8-10', null, 'practitioner_based', 'mobility'),
  ('hip-flexor-activation', 'Hip Flexor Activation', 'Lying leg raise + knee drive. Counteracts tight hip flexors before squatting.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('bodyweight-squat-slow', 'Bodyweight Squat (slow)', '3-second descent. Warms up knees and hips through full ROM.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('quad-activation-vmo-focus', 'Quad Activation (VMO focus)', 'Sit in chair, squeeze quad and straighten leg. Activates VMO which protects patella.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('banded-hip-thrust-light', 'Banded Hip Thrust (light)', 'Glute activation before deadlifts. Band above knees.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('romanian-deadlift-bar-only', 'Romanian Deadlift (bar only)', 'Bar or very light weight. Warms up hamstrings and hip hinge pattern.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('ankle-calf-raise', 'Ankle + Calf Raise', 'Raises then dorsiflexion stretch. Addresses foot chain before loading knees.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('couch-stretch', 'Couch Stretch', 'ALWAYS first. Tight hip flexors = root of patellar pain.', 'mobility', 'lower', false, 2, '90s ea', 'Caution: hip', 'practitioner_based', 'mobility'),
  ('goblet-squat-slow', 'Goblet Squat (slow)', 'Controlled descent, heels elevated if needed.', 'strength', 'lower', false, 4, '10', 'Caution: knee', 'practitioner_based', 'strength'),
  ('deadlift', 'Deadlift', 'You pull 375. Build from there. Own this lift.', 'strength', 'lower', false, 4, '6', null, 'practitioner_based', 'strength'),
  ('bulgarian-split-squat', 'Bulgarian Split Squat', 'Rear foot elevated reduces knee torque. Slow on descent.', 'strength', 'lower', false, 3, '8 ea', 'Caution: knee', 'practitioner_based', 'strength'),
  ('leg-extension-light', 'Leg Extension (light)', 'Rehab load only. Strengthen quad tendon insertion.', 'strength', 'lower', false, 3, '15', 'Caution: knee', 'practitioner_based', 'strength'),
  ('tibialis-raise', 'Tibialis Raise', 'Fixes tight calves + foot chain from the ground.', 'mobility', 'lower', false, 3, '20', 'Caution: foot', 'practitioner_based', 'mobility'),
  ('plank-glute-squeeze', 'Plank + Glute Squeeze', 'Anterior pelvic tilt fix. Squeeze glutes the whole hold.', 'mobility', 'lower', false, 3, '40s', null, 'practitioner_based', 'mobility'),
  ('cuban-press-light-db', 'Cuban Press (light DB)', 'External rotation warm-up. Directly protects AC joint before heavy pressing.', 'warmup', 'upper', true, null, null, null, 'practitioner_based', 'warmup'),
  ('db-chest-fly-very-light', 'DB Chest Fly (very light)', 'Stretches and activates pec fibers before pressing.', 'warmup', 'upper', true, null, null, null, 'practitioner_based', 'warmup'),
  ('shoulder-rotations-band', 'Shoulder Rotations (band)', 'Internal and external rotation. Full rotator cuff warm-up.', 'warmup', 'upper', true, null, null, null, 'practitioner_based', 'warmup'),
  ('push-up-wide-grip', 'Push-Up (wide grip)', 'Bodyweight pressing pattern. Activates chest and front delts.', 'warmup', 'upper', true, null, null, null, 'practitioner_based', 'warmup'),
  ('incline-db-press', 'Incline DB Press', 'Upper chest. DBs allow natural rotation - safer than bar.', 'strength', 'upper', false, 4, '10', 'Caution: shoulder', 'practitioner_based', 'strength'),
  ('lateral-raise-cable', 'Lateral Raise (cable)', 'Cable keeps tension. Delt caps.', 'strength', 'upper', false, 4, '15', 'Caution: shoulder', 'practitioner_based', 'strength'),
  ('ez-bar-curl', 'EZ Bar Curl', 'Sleeve-fillers. Controlled, no swinging.', 'strength', 'upper', false, 3, '10', null, 'practitioner_based', 'strength'),
  ('skull-crusher', 'Skull Crusher', 'Tricep mass. Elbows locked in.', 'strength', 'upper', false, 3, '10', null, 'practitioner_based', 'strength'),
  ('cat-cow', 'Cat-Cow', 'Spinal flexion and extension. Warms up spine before heavy deadlifts.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('glute-bridge-heavy-band', 'Glute Bridge (heavy band)', 'Strong glute activation before deadlifts. Protects low back.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('banded-good-morning', 'Banded Good Morning', 'Hip hinge pattern with band. Primes hamstrings and glutes.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('deadlift-bar-only', 'Deadlift (bar only)', 'Perfect form, zero load. Groove the pattern before adding weight.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('deadlift-50-working-weight', 'Deadlift (50% working weight)', 'Build up to working weight. Never skip this.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('sumo-stance-hip-circle', 'Sumo Stance Hip Circle', 'Opens hips for the pull. Critical for your hip tightness.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('hip-90-90-couch-stretch', 'Hip 90/90 + Couch Stretch', 'Non-negotiable warm-up.', 'mobility', 'lower', false, 2, '90s ea', 'Caution: hip', 'practitioner_based', 'mobility'),
  ('deadlift-heavy', 'Deadlift (heavy)', 'Work toward 405. Progressive overload.', 'strength', 'lower', false, 5, '5', null, 'practitioner_based', 'strength'),
  ('leg-press', 'Leg Press', 'High foot, controlled descent.', 'strength', 'lower', false, 3, '15', 'Caution: knee', 'practitioner_based', 'strength'),
  ('nordic-curl-assisted', 'Nordic Curl (assisted)', 'Most effective hamstring exercise.', 'strength', 'lower', false, 3, '4-6', 'Caution: knee', 'practitioner_based', 'strength'),
  ('calf-tibialis-raise', 'Calf + Tibialis Raise', 'Foot and ankle health protocol.', 'strength', 'lower', false, 3, '15', 'Caution: foot', 'practitioner_based', 'strength'),
  ('banded-row-light', 'Banded Row (light)', 'Warms up rhomboids and mid traps before heavy rowing.', 'warmup', 'upper', true, null, null, null, 'practitioner_based', 'warmup'),
  ('external-rotation-band', 'External Rotation (band)', 'Protects AC joint before heavy pulling.', 'warmup', 'upper', true, null, null, null, 'practitioner_based', 'warmup'),
  ('weighted-pull-up', 'Weighted Pull-Up', 'Add weight. Neutral grip.', 'strength', 'upper', false, 5, '5-8', 'Caution: shoulder', 'practitioner_based', 'strength'),
  ('pendlay-row', 'Pendlay Row', 'Explosive pull. Trunk mass. Your weak point - attack it.', 'strength', 'upper', false, 4, '8', null, 'practitioner_based', 'strength'),
  ('seated-cable-row-close', 'Seated Cable Row (close)', 'Full stretch at front. Squeeze hard at back.', 'strength', 'upper', false, 4, '10', null, 'practitioner_based', 'strength'),
  ('db-shoulder-press-neutral', 'DB Shoulder Press (neutral)', 'Neutral grip protects AC. Shoulder mass.', 'strength', 'upper', false, 4, '10', 'Caution: shoulder', 'practitioner_based', 'strength'),
  ('rear-delt-fly-cable', 'Rear Delt Fly (cable)', 'Posture and width.', 'strength', 'upper', false, 4, '15', 'Caution: shoulder', 'practitioner_based', 'strength'),
  ('tricep-dip', 'Tricep Dip', 'Compound tricep mass.', 'strength', 'upper', false, 3, '10', 'Caution: shoulder', 'practitioner_based', 'strength'),
  ('banded-squat-walk', 'Banded Squat Walk', 'Band above knees. Glute med activation for knee tracking.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('goblet-squat-hold-light', 'Goblet Squat Hold (light)', 'Deep squat hold. Opens hips and ankles before loading.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('quad-foam-roll', 'Quad Foam Roll', 'Roll quads and IT band before squatting. Reduces patellar tension.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('back-squat-bar-only', 'Back Squat (bar only)', 'Perfect depth, tempo 3-1-1. Groove the pattern.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('back-squat-50-working-weight', 'Back Squat (50% working weight)', 'Build to working weight. Essential for knee prep.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('single-leg-glute-bridge', 'Single Leg Glute Bridge', 'Activates glutes unilaterally. Protects knees during heavy squats.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('hip-flexor-calf-mobility', 'Hip Flexor + Calf Mobility', 'Always. Patellar tendinitis lives in tight hips.', 'mobility', 'lower', false, 2, '90s ea', 'Caution: hip', 'practitioner_based', 'mobility'),
  ('back-squat', 'Back Squat', 'Build toward 315+. Controlled descent.', 'strength', 'lower', false, 5, '5', 'Caution: knee', 'practitioner_based', 'strength'),
  ('bulgarian-split-squat-db', 'Bulgarian Split Squat (DB)', 'Slow negative. Single-leg strength.', 'strength', 'lower', false, 4, '8 ea', 'Caution: knee', 'practitioner_based', 'strength'),
  ('hip-thrust', 'Hip Thrust', 'Heaviest you have done. Glutes are the engine.', 'strength', 'lower', false, 4, '10', 'Caution: knee', 'practitioner_based', 'strength'),
  ('leg-extension-moderate', 'Leg Extension (moderate)', 'Progress weight slowly.', 'strength', 'lower', false, 3, '15', 'Caution: knee', 'practitioner_based', 'strength'),
  ('farmer-s-carry', 'Farmer''s Carry', 'Grip, core, traps. Total body hardness.', 'strength', 'lower', false, 4, '30s', null, 'practitioner_based', 'strength'),
  ('shoulder-dislocate-band', 'Shoulder Dislocate (band)', 'Wide grip on band, pass overhead and behind back. Full shoulder mobility.', 'warmup', 'upper', true, null, null, null, 'practitioner_based', 'warmup'),
  ('push-up-row-light-db', 'Push-Up + Row (light DB)', 'Combined movement pattern. Primes both push and pull for supersets.', 'warmup', 'upper', true, null, null, null, 'practitioner_based', 'warmup'),
  ('landmine-press-ss', 'Landmine Press SS', 'Superset with face pulls. 90s rest after pair.', 'strength', 'upper', false, 4, '10 ea', 'Caution: shoulder', 'practitioner_based', 'strength'),
  ('face-pull-ss', 'Face Pull SS', 'Back-to-back with Landmine Press.', 'strength', 'upper', false, 4, '15', 'Caution: shoulder', 'practitioner_based', 'strength'),
  ('chest-supported-row-heavy', 'Chest-Supported Row (heavy)', 'Trunk mass - this is the phase it shows.', 'strength', 'upper', false, 5, '8', null, 'practitioner_based', 'strength'),
  ('incline-press-lat-raise-ss', 'Incline Press + Lat Raise SS', 'Superset. Rest 60s. Chest + delts.', 'strength', 'upper', false, 4, '10/15', 'Caution: shoulder', 'practitioner_based', 'strength'),
  ('curl-pushdown-superset', 'Curl/Pushdown Superset', 'Back-to-back. Arms fill the sleeves.', 'strength', 'upper', false, 4, '10/12', null, 'practitioner_based', 'strength'),
  ('pallof-press-ab-wheel-ss', 'Pallof Press + Ab Wheel SS', 'Core density visible now.', 'mobility', 'upper', false, 3, '10/8', null, 'practitioner_based', 'mobility'),
  ('hip-hinge-with-dowel', 'Hip Hinge with Dowel', 'Rod along spine, maintain 3 points of contact. Perfect hinge pattern.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('deadlift-40-working-weight', 'Deadlift (40% working weight)', 'Light build-up set. Feel the floor, breathe, brace.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('deadlift-65-working-weight', 'Deadlift (65% working weight)', 'Second build-up. Near working weight now.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('kb-swing-light', 'KB Swing (light)', 'Hip hinge explosiveness primer. Glutes fire before the big pull.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('full-mobility-protocol', 'Full Mobility Protocol', '90/90, couch stretch, calf stretch, ankle circles.', 'mobility', 'lower', false, 1, '5 min', 'Caution: hip', 'practitioner_based', 'mobility'),
  ('deadlift-near-max', 'Deadlift (near max)', 'Work toward 4 plates. The big scary pull.', 'strength', 'lower', false, 5, '3-5', null, 'practitioner_based', 'strength'),
  ('hip-thrust-max-load', 'Hip Thrust (max load)', 'Heaviest you have done. Glutes are the engine.', 'strength', 'lower', false, 5, '8', 'Caution: knee', 'practitioner_based', 'strength'),
  ('walking-lunge-dbs', 'Walking Lunge (DBs)', 'Forward lunge - less patellar stress.', 'strength', 'lower', false, 3, '10 ea', 'Caution: knee', 'practitioner_based', 'strength'),
  ('sled-push-or-kb-swing', 'Sled Push or KB Swing', 'Metabolic finisher. Fat burns here.', 'strength', 'lower', false, 5, '30s', null, 'practitioner_based', 'strength'),
  ('tibialis-calf-protocol', 'Tibialis + Calf Protocol', 'End every lower session with this.', 'strength', 'lower', false, 3, '20', 'Caution: foot', 'practitioner_based', 'strength'),
  ('light-lat-pulldown', 'Light Lat Pulldown', 'Feel the lat insertion. Groove the path before cluster sets.', 'warmup', 'upper', true, null, null, null, 'practitioner_based', 'warmup'),
  ('pull-up-cluster-sets', 'Pull-Up Cluster Sets', '15s between clusters. More volume, more strength.', 'strength', 'upper', false, 5, '3-3-3', 'Caution: shoulder', 'practitioner_based', 'strength'),
  ('pendlay-row-heavy', 'Pendlay Row (heavy)', 'Explosive. Trunk thickness. Attack it.', 'strength', 'upper', false, 5, '6', null, 'practitioner_based', 'strength'),
  ('cable-row-long-pull', 'Cable Row (long pull)', 'Full stretch, drive elbows hard.', 'strength', 'upper', false, 4, '10', null, 'practitioner_based', 'strength'),
  ('lateral-raise-21s', 'Lateral Raise 21s', '7 bottom, 7 top, 7 full. Deltoid burn.', 'strength', 'upper', false, 4, '7+7+7', 'Caution: shoulder', 'practitioner_based', 'strength'),
  ('rear-delt-face-pull-ss', 'Rear Delt + Face Pull SS', 'Superset. Back of a scary physique.', 'strength', 'upper', false, 4, '12+15', 'Caution: shoulder', 'practitioner_based', 'strength'),
  ('arm-finisher-ss', 'Arm Finisher SS', 'Curl + pushdown superset. Maximum pump.', 'strength', 'upper', false, 3, '10 ea', null, 'practitioner_based', 'strength'),
  ('dead-bug-pallof-ss', 'Dead Bug + Pallof SS', 'Final phase core density.', 'mobility', 'upper', false, 3, '8+10', null, 'practitioner_based', 'mobility'),
  ('quad-foam-roll-it-band', 'Quad Foam Roll + IT Band', 'Phase 3 volume is highest - quads need this.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('goblet-squat-hold', 'Goblet Squat Hold', 'Deeper hold in Phase 3. Hips open fully before heavy loading.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('back-squat-40-working-weight', 'Back Squat (40% working weight)', 'First build-up set. Perfect form.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('back-squat-65-working-weight', 'Back Squat (65% working weight)', 'Second build-up. You should feel ready.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('jump-squat-bodyweight', 'Jump Squat (bodyweight)', 'CNS activation before heavy squats. Primes fast-twitch fibers.', 'warmup', 'lower', true, null, null, null, 'practitioner_based', 'warmup'),
  ('mobility-activation', 'Mobility + Activation', 'Hip flexors, quads, calves. Do not skip.', 'mobility', 'lower', false, 1, '5 min', 'Caution: hip', 'practitioner_based', 'mobility'),
  ('back-squat-heavy', 'Back Squat (heavy)', 'Final phase. Push the numbers. You have earned it.', 'strength', 'lower', false, 5, '5', 'Caution: knee', 'practitioner_based', 'strength'),
  ('hip-thrust-rdl-ss', 'Hip Thrust + RDL SS', 'Posterior chain superset. 90s between pairs.', 'strength', 'lower', false, 4, '10+8', 'Caution: knee', 'practitioner_based', 'strength'),
  ('leg-press-drop-set', 'Leg Press (drop set)', 'Last set = drop set. Strip weight, go again.', 'strength', 'lower', false, 4, '12', 'Caution: knee', 'practitioner_based', 'strength'),
  ('kb-swing', 'KB Swing', 'Metabolic finisher. Hip hinge power.', 'strength', 'lower', false, 5, '20', null, 'practitioner_based', 'strength'),
  ('hip-90-90-stretch', 'Hip 90/90 Stretch', 'Both knees at 90 deg. Sit tall. Swap sides. Fixes patellar tendinitis, tight hips, unlocks squat. Daily.', 'mobility', 'full_body', false, null, '2 min/side', null, 'practitioner_based', 'mobility'),
  ('couch-stretch-2', 'Couch Stretch', 'Rear knee on ground, front foot forward. Drive hips forward, squeeze rear glute. Root fix for patellar pain.', 'mobility', 'full_body', false, null, '90s/side', null, 'practitioner_based', 'mobility'),
  ('thoracic-foam-roll', 'Thoracic Foam Roll', 'Roll just below shoulder blades. Extend over roller. Unlocks shoulder mobility, helps AC joint.', 'mobility', 'full_body', false, null, '2 minutes', null, 'practitioner_based', 'mobility'),
  ('band-pull-apart-2', 'Band Pull-Apart', 'Hold band at chest, pull apart until arms straight. Rear delts + rotator cuff. Before every upper session.', 'mobility', 'full_body', false, null, '3x20 reps', null, 'practitioner_based', 'mobility'),
  ('dead-hang-2', 'Dead Hang', 'Full dead hang from pull-up bar. Decompresses spine, stretches lats. Best single thing for your AC joint.', 'mobility', 'full_body', false, null, '3x20-30s', null, 'practitioner_based', 'mobility'),
  ('calf-soleus-stretch', 'Calf + Soleus Stretch', 'Standing calf (straight leg) + seated towel stretch (bent knee). Tight calves create patellar chain reaction.', 'mobility', 'full_body', false, null, '90s each', null, 'practitioner_based', 'mobility'),
  ('lacrosse-ball-foot-roll', 'Lacrosse Ball Foot Roll', 'Roll under arch, heel, ball of foot. Breaks adhesions. Fixes foot to ankle to knee chain.', 'mobility', 'full_body', false, null, '2 min/foot', null, 'practitioner_based', 'mobility'),
  ('wall-ankle-mobility', 'Wall Ankle Mobility', 'Foot 3 inches from wall, drive knee to touch. Ankle dorsiflexion = better squat = less patellar stress.', 'mobility', 'full_body', false, null, '2 min each', null, 'practitioner_based', 'mobility')
on conflict (slug) do nothing;

insert into public.program_templates (slug, name, description, methodology, goal_tags, days_per_week, structure, evidence_level)
values (
  'bigscary-4day-progressive-overload',
  'Big & Scary — 4-Day Progressive Overload',
  'Legacy 12-week, 3-phase, 4-day upper/lower progressive-overload program migrated from the original localStorage app.',
  'linear progressive overload with RIR-based autoregulation and phase-gated burnout sets',
  '["build_muscle","get_stronger","general_fitness"]'::jsonb,
  4,
  '{"phases":[{"slug":"phase-1-recomp-foundation","name":"Phase 1 — Recomp Foundation","days":[{"day":"Day A","label":"Upper - Push/Pull","focus":"Shoulder-safe pressing. Landmine dominant. Trunk mass priority.","warmup":[{"exercise_slug":"arm-circles","reps":"10 fwd + 10 back"},{"exercise_slug":"band-pull-apart","reps":"3x20"},{"exercise_slug":"wall-slide","reps":"2x10"},{"exercise_slug":"scapular-push-up","reps":"2x10"},{"exercise_slug":"band-lat-pulldown","reps":"2x15"},{"exercise_slug":"cuban-press-light","reps":"2x10"}],"exercises":[{"exercise_slug":"landmine-press","sets":4,"reps":"10 ea"},{"exercise_slug":"chest-supported-db-row","sets":4,"reps":12},{"exercise_slug":"db-floor-press","sets":3,"reps":12},{"exercise_slug":"face-pull-cable","sets":4,"reps":15},{"exercise_slug":"incline-db-curl","sets":3,"reps":12},{"exercise_slug":"cable-tricep-pushdown","sets":3,"reps":15},{"exercise_slug":"dead-bug","sets":3,"reps":"8 ea"}],"muscle_groups":["chest","shoulders","back","biceps","triceps","core"]},{"day":"Day B","label":"Lower - Glutes & Hams","focus":"Patellar tendinitis protocol. Hip mobility first. Posterior chain.","warmup":[{"exercise_slug":"glute-bridge-bodyweight","reps":"2x20"},{"exercise_slug":"banded-clamshell","reps":"2x15 ea"},{"exercise_slug":"banded-monster-walk","reps":"2x10 steps ea"},{"exercise_slug":"leg-curl-lying-light","reps":"2x15"},{"exercise_slug":"ankle-circles","reps":"20 ea direction"},{"exercise_slug":"reverse-hyper-or-good-morning-bw","reps":"2x15"}],"exercises":[{"exercise_slug":"hip-90-90-mobility","sets":2,"reps":"90s ea"},{"exercise_slug":"hip-thrust-barbell","sets":4,"reps":12},{"exercise_slug":"romanian-deadlift","sets":4,"reps":10},{"exercise_slug":"leg-press-high-foot","sets":3,"reps":15},{"exercise_slug":"seated-leg-curl","sets":3,"reps":12},{"exercise_slug":"calf-raise-standing","sets":3,"reps":20},{"exercise_slug":"pallof-press-cable","sets":3,"reps":"10 ea"}],"muscle_groups":["glutes","hamstrings","quads","calves","core"]},{"day":"Day C","label":"Upper - Back Width","focus":"Build the V-taper. Upper back thickness. Wide and intimidating.","warmup":[{"exercise_slug":"dead-hang","reps":"3x20-30s"},{"exercise_slug":"scapular-pull-up","reps":"2x10"},{"exercise_slug":"band-pull-apart","reps":"3x20"},{"exercise_slug":"face-pull-light","reps":"2x20"},{"exercise_slug":"straight-arm-pulldown-light","reps":"2x15"},{"exercise_slug":"prone-y-t-w","reps":"2x8 each"}],"exercises":[{"exercise_slug":"neutral-grip-pull-up","sets":4,"reps":"6-10"},{"exercise_slug":"seated-cable-row-wide","sets":4,"reps":12},{"exercise_slug":"landmine-row","sets":3,"reps":"10 ea"},{"exercise_slug":"db-lateral-raise","sets":4,"reps":15},{"exercise_slug":"hammer-curl","sets":3,"reps":12},{"exercise_slug":"oh-cable-tricep-ext","sets":3,"reps":12},{"exercise_slug":"ab-wheel-rollout","sets":3,"reps":"8-10"}],"muscle_groups":["back","shoulders","biceps","triceps","core"]},{"day":"Day D","label":"Lower - Quad Focus","focus":"Patella-friendly quads. Hip flexor mobility. Deadlift strength.","warmup":[{"exercise_slug":"hip-flexor-activation","reps":"2x10 ea"},{"exercise_slug":"bodyweight-squat-slow","reps":"2x10"},{"exercise_slug":"quad-activation-vmo-focus","reps":"2x15"},{"exercise_slug":"banded-hip-thrust-light","reps":"2x15"},{"exercise_slug":"romanian-deadlift-bar-only","reps":"2x10"},{"exercise_slug":"ankle-calf-raise","reps":"2x15"}],"exercises":[{"exercise_slug":"couch-stretch","sets":2,"reps":"90s ea"},{"exercise_slug":"goblet-squat-slow","sets":4,"reps":10},{"exercise_slug":"deadlift","sets":4,"reps":6},{"exercise_slug":"bulgarian-split-squat","sets":3,"reps":"8 ea"},{"exercise_slug":"leg-extension-light","sets":3,"reps":15},{"exercise_slug":"tibialis-raise","sets":3,"reps":20},{"exercise_slug":"plank-glute-squeeze","sets":3,"reps":"40s"}],"muscle_groups":["quads","hamstrings","glutes","core"]}]},{"slug":"phase-2-strength-cut","name":"Phase 2 — Strength & Cut","days":[{"day":"Day A","label":"Upper - Heavy Push","focus":"Progressive overload. Bench strength. Shoulder integrity.","warmup":[{"exercise_slug":"band-pull-apart","reps":"3x20"},{"exercise_slug":"cuban-press-light-db","reps":"2x10"},{"exercise_slug":"db-chest-fly-very-light","reps":"2x15"},{"exercise_slug":"shoulder-rotations-band","reps":"2x15 ea"},{"exercise_slug":"push-up-wide-grip","reps":"2x10"},{"exercise_slug":"face-pull-light","reps":"2x20"}],"exercises":[{"exercise_slug":"landmine-press","sets":5,"reps":"8 ea"},{"exercise_slug":"incline-db-press","sets":4,"reps":10},{"exercise_slug":"chest-supported-db-row","sets":5,"reps":10},{"exercise_slug":"face-pull-cable","sets":4,"reps":15},{"exercise_slug":"lateral-raise-cable","sets":4,"reps":15},{"exercise_slug":"ez-bar-curl","sets":3,"reps":10},{"exercise_slug":"skull-crusher","sets":3,"reps":10}],"muscle_groups":["chest","shoulders","back","biceps","triceps"]},{"day":"Day B","label":"Lower - Deadlift Focus","focus":"Pull heavy. Glute activation. Posterior chain.","warmup":[{"exercise_slug":"cat-cow","reps":"2x10"},{"exercise_slug":"glute-bridge-heavy-band","reps":"2x20"},{"exercise_slug":"banded-good-morning","reps":"2x15"},{"exercise_slug":"deadlift-bar-only","reps":"2x10"},{"exercise_slug":"deadlift-50-working-weight","reps":"1x5"},{"exercise_slug":"sumo-stance-hip-circle","reps":"10 ea direction"}],"exercises":[{"exercise_slug":"hip-90-90-couch-stretch","sets":2,"reps":"90s ea"},{"exercise_slug":"deadlift-heavy","sets":5,"reps":5},{"exercise_slug":"hip-thrust-barbell","sets":4,"reps":10},{"exercise_slug":"romanian-deadlift","sets":4,"reps":8},{"exercise_slug":"leg-press","sets":3,"reps":15},{"exercise_slug":"nordic-curl-assisted","sets":3,"reps":"4-6"},{"exercise_slug":"calf-tibialis-raise","sets":3,"reps":15}],"muscle_groups":["hamstrings","glutes","quads","calves"]},{"day":"Day C","label":"Upper - Back Thickness","focus":"Build the trunk. Wide back. Intimidating physique.","warmup":[{"exercise_slug":"dead-hang","reps":"3x20-30s"},{"exercise_slug":"prone-y-t-w","reps":"2x8 each"},{"exercise_slug":"banded-row-light","reps":"2x20"},{"exercise_slug":"scapular-pull-up","reps":"2x10"},{"exercise_slug":"external-rotation-band","reps":"2x15 ea"},{"exercise_slug":"straight-arm-pulldown-light","reps":"2x15"}],"exercises":[{"exercise_slug":"weighted-pull-up","sets":5,"reps":"5-8"},{"exercise_slug":"pendlay-row","sets":4,"reps":8},{"exercise_slug":"seated-cable-row-close","sets":4,"reps":10},{"exercise_slug":"db-shoulder-press-neutral","sets":4,"reps":10},{"exercise_slug":"rear-delt-fly-cable","sets":4,"reps":15},{"exercise_slug":"incline-db-curl","sets":3,"reps":10},{"exercise_slug":"tricep-dip","sets":3,"reps":10}],"muscle_groups":["back","shoulders","biceps","triceps"]},{"day":"Day D","label":"Lower - Squat Strength","focus":"Build the squat. Hip and knee rehab maintained.","warmup":[{"exercise_slug":"banded-squat-walk","reps":"2x10 steps ea"},{"exercise_slug":"goblet-squat-hold-light","reps":"2x30s hold"},{"exercise_slug":"quad-foam-roll","reps":"2 min total"},{"exercise_slug":"back-squat-bar-only","reps":"2x10"},{"exercise_slug":"back-squat-50-working-weight","reps":"1x5"},{"exercise_slug":"single-leg-glute-bridge","reps":"2x10 ea"}],"exercises":[{"exercise_slug":"hip-flexor-calf-mobility","sets":2,"reps":"90s ea"},{"exercise_slug":"back-squat","sets":5,"reps":5},{"exercise_slug":"bulgarian-split-squat-db","sets":4,"reps":"8 ea"},{"exercise_slug":"hip-thrust","sets":4,"reps":10},{"exercise_slug":"leg-extension-moderate","sets":3,"reps":15},{"exercise_slug":"farmer-s-carry","sets":4,"reps":"30s"},{"exercise_slug":"ab-wheel-rollout","sets":3,"reps":10}],"muscle_groups":["quads","glutes","hamstrings","core"]}]},{"slug":"phase-3-shred","name":"Phase 3 — Shred","days":[{"day":"Day A","label":"Upper - Maximum Intensity","focus":"All-out. Supersets. Look terrifying.","warmup":[{"exercise_slug":"band-pull-apart","reps":"3x25"},{"exercise_slug":"cuban-press-light","reps":"2x12"},{"exercise_slug":"scapular-push-up","reps":"2x12"},{"exercise_slug":"face-pull-light","reps":"2x20"},{"exercise_slug":"shoulder-dislocate-band","reps":"2x10"},{"exercise_slug":"push-up-row-light-db","reps":"2x8"}],"exercises":[{"exercise_slug":"landmine-press-ss","sets":4,"reps":"10 ea"},{"exercise_slug":"face-pull-ss","sets":4,"reps":15},{"exercise_slug":"weighted-pull-up","sets":5,"reps":"6-8"},{"exercise_slug":"chest-supported-row-heavy","sets":5,"reps":8},{"exercise_slug":"incline-press-lat-raise-ss","sets":4,"reps":"10/15"},{"exercise_slug":"curl-pushdown-superset","sets":4,"reps":"10/12"},{"exercise_slug":"pallof-press-ab-wheel-ss","sets":3,"reps":"10/8"}],"muscle_groups":["chest","shoulders","back","biceps","triceps","core"]},{"day":"Day B","label":"Lower - Strength + Conditioning","focus":"Heavy pull. Glute focus. Metabolic finisher.","warmup":[{"exercise_slug":"cat-cow","reps":"2x10"},{"exercise_slug":"glute-bridge-heavy-band","reps":"2x20"},{"exercise_slug":"hip-hinge-with-dowel","reps":"2x10"},{"exercise_slug":"deadlift-40-working-weight","reps":"1x5"},{"exercise_slug":"deadlift-65-working-weight","reps":"1x3"},{"exercise_slug":"kb-swing-light","reps":"2x10"}],"exercises":[{"exercise_slug":"full-mobility-protocol","sets":1,"reps":"5 min"},{"exercise_slug":"deadlift-near-max","sets":5,"reps":"3-5"},{"exercise_slug":"hip-thrust-max-load","sets":5,"reps":8},{"exercise_slug":"romanian-deadlift","sets":4,"reps":8},{"exercise_slug":"walking-lunge-dbs","sets":3,"reps":"10 ea"},{"exercise_slug":"sled-push-or-kb-swing","sets":5,"reps":"30s"},{"exercise_slug":"tibialis-calf-protocol","sets":3,"reps":20}],"muscle_groups":["hamstrings","glutes","quads","calves"]},{"day":"Day C","label":"Upper - Width & Detail","focus":"Wide back. Capped delts. Visible separation.","warmup":[{"exercise_slug":"dead-hang","reps":"3x30s"},{"exercise_slug":"scapular-pull-up","reps":"3x10"},{"exercise_slug":"prone-y-t-w","reps":"2x10 each"},{"exercise_slug":"band-pull-apart","reps":"3x20"},{"exercise_slug":"light-lat-pulldown","reps":"2x15"},{"exercise_slug":"face-pull-light","reps":"2x20"}],"exercises":[{"exercise_slug":"pull-up-cluster-sets","sets":5,"reps":"3-3-3"},{"exercise_slug":"pendlay-row-heavy","sets":5,"reps":6},{"exercise_slug":"cable-row-long-pull","sets":4,"reps":10},{"exercise_slug":"lateral-raise-21s","sets":4,"reps":"7+7+7"},{"exercise_slug":"rear-delt-face-pull-ss","sets":4,"reps":"12+15"},{"exercise_slug":"arm-finisher-ss","sets":3,"reps":"10 ea"},{"exercise_slug":"dead-bug-pallof-ss","sets":3,"reps":"8+10"}],"muscle_groups":["back","shoulders","biceps","triceps","core"]},{"day":"Day D","label":"Lower - Final Shred","focus":"Heavy squat. Metabolic work. Look like you lift.","warmup":[{"exercise_slug":"banded-squat-walk","reps":"2x15 steps ea"},{"exercise_slug":"quad-foam-roll-it-band","reps":"2 min"},{"exercise_slug":"goblet-squat-hold","reps":"2x45s"},{"exercise_slug":"back-squat-40-working-weight","reps":"1x8"},{"exercise_slug":"back-squat-65-working-weight","reps":"1x4"},{"exercise_slug":"jump-squat-bodyweight","reps":"2x8"}],"exercises":[{"exercise_slug":"mobility-activation","sets":1,"reps":"5 min"},{"exercise_slug":"back-squat-heavy","sets":5,"reps":5},{"exercise_slug":"hip-thrust-rdl-ss","sets":4,"reps":"10+8"},{"exercise_slug":"bulgarian-split-squat","sets":4,"reps":"8 ea"},{"exercise_slug":"leg-press-drop-set","sets":4,"reps":12},{"exercise_slug":"kb-swing","sets":5,"reps":20},{"exercise_slug":"farmer-s-carry","sets":4,"reps":"40s"}],"muscle_groups":["quads","glutes","hamstrings","core"]}]}]}'::jsonb,
  'moderate_confidence'
)
on conflict (slug) do nothing;

-- ─── Skill trees (section 25) — seeded with early levels; extensible ───
insert into public.skill_trees (slug, name, category, description) values
  ('handstand', 'Handstand', 'upper', 'Freestanding handstand progression from wrist prep to advanced holds.'),
  ('front-split', 'Front Split', 'lower', 'Progressive front split development from current range to full split control.'),
  ('pistol-squat', 'Pistol Squat', 'lower', 'Single-leg squat progression from assisted to full control.'),
  ('l-sit', 'L-Sit', 'full_body', 'Compression and core-strength progression toward a full L-sit hold.')
on conflict (slug) do nothing;

insert into public.skill_tree_levels (skill_tree_id, level_index, title, description, unlock_criteria)
select id, lvl.level_index, lvl.title, lvl.description, lvl.unlock_criteria::jsonb
from public.skill_trees, (values
  (0, 'Wrist Preparation', 'Build wrist tolerance for weight-bearing.', '{"sessions_completed": 3}'),
  (1, 'Wall-Supported Position', 'Hold a chest-to-wall handstand with control.', '{"hold_seconds": 30}'),
  (2, 'Wall Shoulder Control', 'Back-to-wall handstand with active shoulder engagement.', '{"hold_seconds": 30}'),
  (3, 'Weight Shifting', 'Shift weight through the hands while wall-supported.', '{"sets": 3}'),
  (4, 'Kick-Up Practice', 'Practice kicking to a wall-supported handstand consistently.', '{"clean_attempts": 8}'),
  (5, 'Freestanding Attempts', 'Brief freestanding balance attempts away from the wall.', '{"attempts": 10}'),
  (6, 'Freestanding Hold', 'Hold a freestanding handstand.', '{"hold_seconds": 10}'),
  (7, 'Advanced Handstand', 'Press variations, one-arm work, or advanced holds.', '{"hold_seconds": 30}')
) as lvl(level_index, title, description, unlock_criteria)
where skill_trees.slug = 'handstand'
on conflict (skill_tree_id, level_index) do nothing;

-- ─── Assessment templates (section 17) — short, approachable baselines ───
insert into public.assessment_templates (slug, name, area, description, instructions) values
  ('overhead-squat', 'Overhead Squat Assessment', 'squat', 'General movement-quality screen for ankle, hip, and thoracic restrictions.', 'Squat to depth with arms overhead; note heel lift, knee valgus, forward lean, and arm drop.'),
  ('ankle-dorsiflexion', 'Ankle Dorsiflexion (Knee-to-Wall)', 'ankles', 'Measures ankle dorsiflexion range, a common squat-depth limiter.', 'Measure the maximum distance the toes can be from a wall while the knee touches it and the heel stays down.'),
  ('shoulder-flexion', 'Active Shoulder Flexion', 'shoulders', 'Measures active overhead shoulder range.', 'Lie on back, flatten low back, raise one arm overhead as far as possible without the back arching.'),
  ('active-straight-leg-raise', 'Active Straight-Leg Raise', 'hamstrings', 'Measures active hamstring/posterior-chain range and control.', 'Lie on back, raise one straight leg as high as possible while keeping the other leg flat and pointed.'),
  ('single-leg-balance', 'Single-Leg Balance', 'balance', 'Baseline static balance and ankle stability.', 'Time an eyes-open single-leg stand per side until a balance loss.')
on conflict (slug) do nothing;
