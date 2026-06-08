// api/send-notification.js
// Vercel Cron Function — sends meal push notifications on schedule
// Configure in vercel.json as a cron job

import webpush from 'web-push';

// Set VAPID keys in Vercel Environment Variables:
// VAPID_PUBLIC_KEY, VAPID_PRIVATE_KEY, VAPID_EMAIL
webpush.setVapidDetails(
  `mailto:${process.env.VAPID_EMAIL}`,
  process.env.VAPID_PUBLIC_KEY,
  process.env.VAPID_PRIVATE_KEY
);

// Mon=1 Tue=2 Thu=4 Fri=5 = training days
// Wed=3 Sat=6 Sun=0 = rest days
const TRAINING_DAYS = [1, 2, 4, 5];
const REST_DAYS     = [0, 3, 6]; // Sun, Wed, Sat

const SCHEDULE = {
  training: [
    { hour: 5,  min: 0,  title: "💪 PRE-WORKOUT",        body: "XS Pre-Workout now. No coffee. 115mg caffeine only." },
    { hour: 5,  min: 5,  title: "🥣 TRAINING BREAKFAST", body: "Option A: Overnight oats + eggs | Option B: XS Premade Shake + banana + almonds" },
    { hour: 5,  min: 5,  title: "💊 MORNING SUPPS",      body: "Perfect Pack AM + Liver Health + Rhodiola + Lion's Mane" },
    { hour: 7,  min: 15, title: "🏋️ POST-WORKOUT",       body: "Muscle Multiplier FIRST → Whey x2 + Post-Workout + Ignite + banana" },
    { hour: 11, min: 30, title: "☀️ LUNCH",              body: "Chicken + rice + spinach | CLA x2 + Turmeric + Liver Health 2nd dose" },
    { hour: 13, min: 30, title: "🥩 MEAL 3",             body: "Ground beef + sweet potato + broccoli" },
    { hour: 16, min: 30, title: "🧀 SNACK",              body: "Cottage cheese + almonds | OR XS Premade Shake" },
    { hour: 17, min: 15, title: "🌙 DINNER",             body: "Salmon + quinoa + asparagus | CLA x2 + Turmeric + Vision Health + Perfect Pack PM" },
    { hour: 21, min: 30, title: "🌙 NIGHT PROTEIN",      body: "1 scoop XS Grass Fed Whey in water. Every night." },
  ],
  rest: [
    { hour: 7,  min: 0,  title: "🛋️ REST BREAKFAST",    body: "4 eggs + Ezekiel bread | Perfect Pack AM + Liver Health + Rhodiola + Lion's Mane" },
    { hour: 7,  min: 0,  title: "💊 MORNING SUPPS",      body: "Perfect Pack AM + Liver Health + Rhodiola + Lion's Mane — take with breakfast" },
    { hour: 11, min: 30, title: "☀️ REST LUNCH",         body: "Chicken + salad + olive oil | CLA x2 + Turmeric + Liver Health 2nd dose" },
    { hour: 14, min: 30, title: "🧀 REST SNACK",         body: "Greek yogurt + blueberries — keep carbs low, protein high" },
    { hour: 17, min: 15, title: "🌙 REST DINNER",        body: "Sirloin + roasted veg | CLA x2 + Turmeric + Vision Health + Perfect Pack PM" },
    { hour: 21, min: 30, title: "🌙 NIGHT PROTEIN",      body: "1 scoop XS Grass Fed Whey. Every night — training day or rest day." },
  ],
};

export default async function handler(req, res) {
  // Vercel Cron authenticates with CRON_SECRET
  if (req.headers.authorization !== `Bearer ${process.env.CRON_SECRET}`) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  // LA time (UTC-7)
  const now = new Date(new Date().toLocaleString('en-US', { timeZone: 'America/Los_Angeles' }));
  const hour = now.getHours();
  const min  = now.getMinutes();
  const day  = now.getDay();
  const isTraining = TRAINING_DAYS.includes(day);
  const schedule   = isTraining ? SCHEDULE.training : SCHEDULE.rest;

  // Find ALL matching notifications for this minute (some times have multiple e.g. 5:05am has breakfast + supps)
  const notifications = schedule.filter(n => n.hour === hour && n.min === min);
  if (!notifications.length) {
    return res.status(200).json({ sent: false, reason: `No notification scheduled at ${hour}:${String(min).padStart(2,'0')} on ${isTraining ? 'training' : 'rest'} day` });
  }

  // In production: load subscriptions from Vercel KV
  // const keys = await kv.keys('sub:*');
  // const subs = await Promise.all(keys.map(k => kv.get(k)));

  // Placeholder subscription list (replace with KV fetch)
  const subscriptions = [];

  let sent = 0;
  // Send each notification that matches this time slot
  for (const notification of notifications) {
    for (const sub of subscriptions) {
      try {
        await webpush.sendNotification(sub, JSON.stringify({
          title: notification.title,
          body:  notification.body,
          tag:   `meal-${hour}-${min}-${notification.title}`,
          url:   '/',
        }));
        sent++;
      } catch (err) {
        if (err.statusCode === 410) {
          // Subscription expired - remove from KV in production
          console.log('Expired subscription, should remove:', sub.endpoint);
        } else {
          console.error('Push send error:', err);
        }
      }
    }
  }

  const dayType = isTraining ? 'TRAINING' : 'REST';
  const titles = notifications.map(n => n.title).join(', ');
  return res.status(200).json({ sent, dayType, notifications: titles, time: `${hour}:${String(min).padStart(2,'0')}` });
}
