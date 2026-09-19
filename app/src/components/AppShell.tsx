import type { ReactNode } from "react";
import { color } from "../theme/tokens";
import { NavBar } from "./NavBar";

export function AppShell({ children }: { children: ReactNode }) {
  return (
    <div
      style={{
        background: color.bg,
        minHeight: "100vh",
        color: color.text,
        maxWidth: 430,
        margin: "0 auto",
        position: "relative",
        paddingBottom: 80,
      }}
    >
      {children}
      <NavBar />
    </div>
  );
}
