// Design tokens ported from the legacy Big & Scary app (index.html) so the
// new platform keeps the same premium/dark/athletic feel rather than
// starting the visual identity over. Extend, don't replace, as new training
// domains (mobility, skills, conditioning) need their own accent colors.
export const color = {
  bg: "#080a0f",
  surface: "#0f1218",
  card: "#141920",
  border: "#1e2530",
  yellow: "#e8c840",
  yellowDim: "#a08a20",
  red: "#d43030",
  redDim: "#8a1a1a",
  blue: "#2a6aad",
  blueBright: "#4a8fd4",
  steel: "#8a9bb0",
  muted: "#4a5568",
  text: "#e8eaf0",
  dim: "#2a3344",
  green: "#2a8a4a",
  greenBright: "#3ab860",
  purple: "#7c4daa",
  orange: "#d4782a",
} as const;

export const font = {
  display: "'Bebas Neue', sans-serif",
  condensed: "'Barlow Condensed', sans-serif",
  body: "'Barlow', sans-serif",
} as const;

// Training-domain accent colors (RESET -> PERFORM). Kept separate from the
// legacy phase colors above so mobility/skill screens don't inherit the
// lifting program's yellow/blue/red phase palette by accident.
export const domainColor: Record<string, string> = {
  reset: color.blueBright,
  restore: color.green,
  mobilize: color.greenBright,
  control: color.purple,
  strengthen: color.orange,
  master: color.yellow,
  build: color.red,
  perform: color.redDim,
};
