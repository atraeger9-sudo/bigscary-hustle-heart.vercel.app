import { NavLink } from "react-router-dom";
import { color, font } from "../theme/tokens";

const NAV = [
  { to: "/", label: "Today" },
  { to: "/train", label: "Train" },
  { to: "/progress", label: "Progress" },
  { to: "/skills", label: "Skills" },
  { to: "/settings", label: "Settings" },
];

export function NavBar() {
  return (
    <nav
      style={{
        position: "fixed",
        bottom: 0,
        left: 0,
        right: 0,
        display: "flex",
        maxWidth: 430,
        margin: "0 auto",
        background: color.surface,
        borderTop: `1px solid ${color.border}`,
        padding: "8px 4px",
      }}
    >
      {NAV.map((item) => (
        <NavLink
          key={item.to}
          to={item.to}
          end={item.to === "/"}
          style={({ isActive }) => ({
            flex: 1,
            textAlign: "center",
            padding: "8px 2px",
            fontSize: 10,
            fontFamily: font.condensed,
            letterSpacing: "0.08em",
            textTransform: "uppercase",
            textDecoration: "none",
            color: isActive ? color.yellow : color.muted,
          })}
        >
          {item.label}
        </NavLink>
      ))}
    </nav>
  );
}
