import { useState, type CSSProperties, type FormEvent } from "react";
import { color, font } from "../theme/tokens";
import { useAuth } from "./AuthProvider";

export function AuthPage() {
  const { signIn, signUp } = useAuth();
  const [mode, setMode] = useState<"login" | "signup">("login");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [displayName, setDisplayName] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [info, setInfo] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    setError(null);
    setInfo(null);
    setBusy(true);
    const result =
      mode === "login" ? await signIn(email, password) : await signUp(email, password, displayName || email.split("@")[0]);
    setBusy(false);
    if (result.error) {
      setError(result.error);
    } else if (mode === "signup") {
      setInfo("Account created. Check your email if confirmation is required, then sign in.");
      setMode("login");
    }
  };

  return (
    <div
      style={{
        background: color.bg,
        minHeight: "100vh",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "center",
        padding: 24,
        maxWidth: 430,
        margin: "0 auto",
      }}
    >
      <div style={{ textAlign: "center", marginBottom: 32 }}>
        <p style={{ margin: "0 0 2px", fontSize: 13, color: color.yellow, letterSpacing: "0.4em", fontFamily: font.condensed }}>
          HUSTLE &amp; HEART
        </p>
        <p style={{ margin: 0, fontSize: 40, fontFamily: font.display, letterSpacing: "0.08em", color: color.text, lineHeight: 1 }}>
          BUILD THE BODY
        </p>
        <p style={{ margin: "6px 0 0", fontSize: 12, color: color.muted, fontFamily: font.body }}>
          {mode === "login" ? "Sign in to your training" : "Create your account"}
        </p>
      </div>

      <form onSubmit={handleSubmit} style={{ width: "100%", display: "flex", flexDirection: "column", gap: 12 }}>
        {mode === "signup" && (
          <input
            placeholder="Display name"
            value={displayName}
            onChange={(e) => setDisplayName(e.target.value)}
            style={inputStyle}
          />
        )}
        <input
          type="email"
          required
          placeholder="Email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          style={inputStyle}
        />
        <input
          type="password"
          required
          minLength={6}
          placeholder="Password (min 6 characters)"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          style={inputStyle}
        />
        {error && <p style={{ margin: 0, fontSize: 12, color: color.red, fontFamily: font.body }}>{error}</p>}
        {info && <p style={{ margin: 0, fontSize: 12, color: color.greenBright, fontFamily: font.body }}>{info}</p>}
        <button
          type="submit"
          disabled={busy}
          style={{
            marginTop: 4,
            background: color.yellow,
            color: "#000",
            border: "none",
            borderRadius: 10,
            padding: "14px",
            fontSize: 15,
            fontWeight: "bold",
            cursor: busy ? "default" : "pointer",
            fontFamily: font.condensed,
            letterSpacing: "0.1em",
            opacity: busy ? 0.6 : 1,
          }}
        >
          {busy ? "WORKING…" : mode === "login" ? "SIGN IN" : "CREATE ACCOUNT"}
        </button>
      </form>

      <button
        onClick={() => {
          setMode(mode === "login" ? "signup" : "login");
          setError(null);
          setInfo(null);
        }}
        style={{
          marginTop: 20,
          background: "none",
          border: "none",
          color: color.steel,
          fontSize: 12,
          cursor: "pointer",
          fontFamily: font.body,
          textDecoration: "underline",
        }}
      >
        {mode === "login" ? "Need an account? Sign up" : "Already have an account? Sign in"}
      </button>
    </div>
  );
}

const inputStyle: CSSProperties = {
  background: color.card,
  border: `1px solid ${color.border}`,
  borderRadius: 10,
  padding: "14px 12px",
  color: color.text,
  fontSize: 14,
  fontFamily: font.body,
  outline: "none",
};
