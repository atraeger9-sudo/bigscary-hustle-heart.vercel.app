// Big & Scary Service Worker v1
// Hustle & Heart

const CACHE = 'bigscary-v1';
const ASSETS = ['/', '/index.html', '/manifest.json', '/logo.svg'];

// Meal notification schedule - matches your reminder plan
const MEAL_SCHEDULE = {
  training: [
    { hour: 5,  min: 0,  title: "💪 PRE-WORKOUT", body: "XS Pre-Workout now. No coffee. 115mg caffeine." },
    { hour: 5,  min: 5,  title: "🥣 TRAINING BREAKFAST", body: "Option A: Overnight oats jar + 3 hard boiled eggs | Option B: XS Premade Shake + banana + almonds" },
    { hour: 5,  min: 5,  title: "💊 MORNING SUPPS", body: "Perfect Pack AM + Liver Health + Rhodiola + Lion's Mane" },
    { hour: 7,  min: 15, title: "🏋️ POST-WORKOUT TRINITY", body: "Muscle Multiplier FIRST → Whey x2 + Post-Workout + Ignite + banana" },
    { hour: 11, min: 30, title: "☀️ LUNCH", body: "Chicken + rice + spinach + olive oil | Supps: CLA x2 + Turmeric + Liver Health 2nd dose" },
    { hour: 13, min: 30, title: "🥩 MEAL 3", body: "Ground beef + sweet potato + broccoli" },
    { hour: 16, min: 30, title: "🧀 SNACK", body: "Cottage cheese + almonds | OR XS Premade Shake" },
    { hour: 17, min: 15, title: "🌙 DINNER", body: "Salmon + quinoa + asparagus | Supps: CLA x2 + Turmeric + Vision Health + Perfect Pack PM" },
    { hour: 21, min: 30, title: "🌙 NIGHT PROTEIN", body: "1 scoop XS Grass Fed Whey in water. Every night. Non-negotiable." },
  ],
  rest: [
    { hour: 7,  min: 0,  title: "🛋️ REST BREAKFAST",  body: "4 eggs + Ezekiel bread — grab and eat" },
    { hour: 7,  min: 0,  title: "💊 MORNING SUPPS",    body: "Perfect Pack AM + Liver Health + Rhodiola + Lion's Mane — take with breakfast" },
    { hour: 11, min: 30, title: "☀️ REST LUNCH",       body: "Chicken + big salad + olive oil | CLA x2 + Turmeric + Liver Health 2nd dose" },
    { hour: 14, min: 30, title: "🧀 REST SNACK",       body: "Greek yogurt + blueberries — protein high, carbs low" },
    { hour: 17, min: 15, title: "🌙 REST DINNER",      body: "Sirloin + roasted veg | CLA x2 + Turmeric + Vision Health + Perfect Pack PM" },
    { hour: 21, min: 30, title: "🌙 NIGHT PROTEIN",    body: "1 scoop XS Grass Fed Whey. Every night." },
  ],
};

// Install - cache assets
self.addEventListener('install', e => {
  e.waitUntil(
    caches.open(CACHE).then(cache => cache.addAll(ASSETS)).then(() => self.skipWaiting())
  );
});

// Activate - clean old caches
self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))
    ).then(() => self.clients.claim())
  );
});

// Fetch - cache first, network fallback
self.addEventListener('fetch', e => {
  e.respondWith(
    caches.match(e.request).then(cached => cached || fetch(e.request).then(res => {
      const clone = res.clone();
      caches.open(CACHE).then(cache => cache.put(e.request, clone));
      return res;
    }))
  );
});

// Push notification received from server
self.addEventListener('push', e => {
  const data = e.data ? e.data.json() : {};
  const title = data.title || 'Big & Scary';
  const options = {
    body: data.body || 'Time to eat.',
    icon: '/logo.svg',
    badge: '/logo.svg',
    tag: data.tag || 'bigscary',
    renotify: true,
    vibrate: [200, 100, 200],
    data: { url: data.url || '/' },
    actions: [
      { action: 'open', title: 'Open App' },
      { action: 'dismiss', title: 'Dismiss' }
    ]
  };
  e.waitUntil(self.registration.showNotification(title, options));
});

// Notification click handler
self.addEventListener('notificationclick', e => {
  e.notification.close();
  if (e.action === 'dismiss') return;
  e.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then(clientList => {
      for (const client of clientList) {
        if (client.url.includes(self.location.origin) && 'focus' in client) {
          return client.focus();
        }
      }
      if (clients.openWindow) return clients.openWindow('/');
    })
  );
});

// Background sync for offline resilience
self.addEventListener('sync', e => {
  if (e.tag === 'meal-reminder') {
    e.waitUntil(sendMealReminder());
  }
});

async function sendMealReminder() {
  const now = new Date();
  const hour = now.getHours();
  const min = now.getMinutes();
  const day = now.getDay(); // 0=Sun, 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat
  // Mon=1 Tue=2 Thu=4 Fri=5 = training | Wed=3 Sat=6 Sun=0 = rest
  const isTraining = [1, 2, 4, 5].includes(day);
  const schedule = isTraining ? MEAL_SCHEDULE.training : MEAL_SCHEDULE.rest;

  const matches = schedule.filter(n => n.hour === hour && Math.abs(n.min - min) <= 2);
  for (const meal of matches) {
    await self.registration.showNotification(meal.title, {
      body: meal.body,
      icon: '/logo.svg',
      badge: '/logo.svg',
      vibrate: [200, 100, 200],
      tag: `meal-${meal.hour}-${meal.min}-${meal.title}`,
      renotify: true,
    });
  }
}
