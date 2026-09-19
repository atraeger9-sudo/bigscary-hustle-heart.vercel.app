import type { ReactNode } from "react";
import { BrowserRouter, Navigate, Route, Routes } from "react-router-dom";
import { AuthProvider, useAuth } from "./auth/AuthProvider";
import { AuthPage } from "./auth/AuthPage";
import { TodayPage } from "./pages/TodayPage";
import { TrainPage } from "./pages/TrainPage";
import { ProgressPage } from "./pages/ProgressPage";
import { SkillsPage } from "./pages/SkillsPage";
import { SettingsPage } from "./pages/SettingsPage";
import { ImportPage } from "./pages/ImportPage";
import { color } from "./theme/tokens";

function ProtectedRoute({ children }: { children: ReactNode }) {
  const { session, loading } = useAuth();
  if (loading) {
    return (
      <div style={{ background: color.bg, color: color.text, minHeight: "100vh", display: "flex", alignItems: "center", justifyContent: "center" }}>
        Loading…
      </div>
    );
  }
  if (!session) return <Navigate to="/login" replace />;
  return <>{children}</>;
}

function Routed() {
  const { session } = useAuth();
  return (
    <Routes>
      <Route path="/login" element={session ? <Navigate to="/" replace /> : <AuthPage />} />
      <Route path="/" element={<ProtectedRoute><TodayPage /></ProtectedRoute>} />
      <Route path="/train" element={<ProtectedRoute><TrainPage /></ProtectedRoute>} />
      <Route path="/progress" element={<ProtectedRoute><ProgressPage /></ProtectedRoute>} />
      <Route path="/skills" element={<ProtectedRoute><SkillsPage /></ProtectedRoute>} />
      <Route path="/settings" element={<ProtectedRoute><SettingsPage /></ProtectedRoute>} />
      <Route path="/import" element={<ProtectedRoute><ImportPage /></ProtectedRoute>} />
    </Routes>
  );
}

export default function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <Routed />
      </AuthProvider>
    </BrowserRouter>
  );
}
