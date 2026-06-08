// api/subscribe.js
// Vercel Serverless Function — saves push subscriptions
// Hustle & Heart Big & Scary PWA

// In production use a database (Vercel KV, PlanetScale, etc.)
// For simplicity this uses Vercel KV (key-value store - free tier)

export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    const { subscription } = req.body;
    if (!subscription) {
      return res.status(400).json({ error: 'No subscription provided' });
    }

    // Store subscription - in production use Vercel KV:
    // import { kv } from "@vercel/kv";
    // await kv.set(`sub:${Date.now()}`, JSON.stringify(subscription));

    // For now log it (replace with KV storage)
    console.log('New push subscription:', JSON.stringify(subscription));

    return res.status(200).json({ success: true });
  } catch (err) {
    console.error('Subscribe error:', err);
    return res.status(500).json({ error: 'Internal server error' });
  }
}
