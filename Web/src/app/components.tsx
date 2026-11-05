import { useEffect, useState, type ReactNode } from "react";
import { Menu, X } from "lucide-react";
import { Link, NavLink, Outlet, useLocation } from "react-router";
import { GITHUB } from "./data";

const nav = [
  ["Inicio", "/"],
  ["Universo", "/universo"],
  ["Ciudades", "/ciudades"],
  ["Personajes", "/personajes"],
  ["Lugares", "/lugares"],
  ["Atlas", "/atlas"],
  ["Videojuego", "/videojuego"],
  ["Contacto", "/contacto"],
];

export function Brand() {
  return (
    <Link to="/" className="brand" aria-label="Rifts & Gears, inicio">
      <span className="brand-mark" aria-hidden="true">
        <img src="/icono-arcane.svg" alt="" width="26" height="26" />
      </span>
      <span className="brand-name">Rifts & Gears</span>
    </Link>
  );
}

export function Layout() {
  const [open, setOpen] = useState(false);
  const location = useLocation();

  useEffect(() => {
    setOpen(false);
    const titles: Record<string, string> = {
      "/": "Rifts & Gears — Arcane",
      "/universo": "Universo — Rifts & Gears",
      "/ciudades": "Ciudades — Rifts & Gears",
      "/personajes": "Personajes — Rifts & Gears",
      "/lugares": "Lugares — Rifts & Gears",
      "/atlas": "Atlas — Rifts & Gears",
      "/videojuego": "Videojuego — Rifts & Gears",
      "/contacto": "Contacto — Rifts & Gears",
    };
    document.title = titles[location.pathname] ?? "Rifts & Gears";

    const targetId = location.hash.slice(1);
    if (targetId) {
      window.requestAnimationFrame(() => document.getElementById(targetId)?.scrollIntoView());
    } else {
      window.scrollTo({ top: 0, behavior: "smooth" });
    }
  }, [location.pathname, location.hash]);

  return (
    <div className="site-shell">
      <a href="#contenido" className="skip-link">
        Saltar al contenido
      </a>
      <header className="site-header">
        <Brand />
        <button
          className="menu-button"
          onClick={() => setOpen(!open)}
          aria-expanded={open}
          aria-label={open ? "Cerrar menú" : "Abrir menú"}
        >
          {open ? <X /> : <Menu />}
        </button>
        <nav className={`main-nav ${open ? "is-open" : ""}`} aria-label="Navegación principal">
          {nav.map(([label, href]) => (
            <NavLink
              key={href}
              to={href}
              end={href === "/"}
              className={({ isActive }) => (isActive ? "active" : "")}
            >
              {label}
            </NavLink>
          ))}
        </nav>
      </header>
      <main id="contenido">
        <Outlet />
      </main>
      <footer className="site-footer">
        <div>
          <Brand />
          <p>
            Una web de fan sobre Piltover y Zaun, y el juego que estoy haciendo en Godot.
          </p>
        </div>
        <div className="footer-links">
          <Link to="/universo">Universo</Link>
          <Link to="/videojuego">Videojuego</Link>
          <Link to="/contacto">Contacto</Link>
          <a href={GITHUB}>GitHub</a>
        </div>
        <p className="legal">
          Rifts & Gears es un proyecto de fans no oficial. Arcane y League of Legends pertenecen a
          sus respectivos titulares.
        </p>
      </footer>
    </div>
  );
}

export function Eyebrow({ children }: { children: ReactNode }) {
  return <p className="eyebrow">{children}</p>;
}

export function PageHero({
  eyebrow,
  title,
  text,
  tone = "neutral",
}: {
  eyebrow?: string;
  title: string;
  text: string;
  tone?: "neutral" | "piltover" | "zaun";
}) {
  return (
    <section className={`page-hero tone-${tone}`}>
      <div className="orb" />
      <div className="page-hero-inner">
        {eyebrow && <Eyebrow>{eyebrow}</Eyebrow>}
        <h1>{title}</h1>
        <p>{text}</p>
      </div>
    </section>
  );
}

/** Marco de imagen con el mismo estilo que los espacios reservados del diseño. */
export function Media({
  src,
  alt,
  ratio = "landscape",
}: {
  src: string;
  alt: string;
  ratio?: "landscape" | "portrait" | "map";
}) {
  return (
    <div className={`placeholder media placeholder-${ratio}`}>
      <img src={src} alt={alt} loading="lazy" />
      <i className="placeholder-corner corner-a" aria-hidden="true" />
      <i className="placeholder-corner corner-b" aria-hidden="true" />
    </div>
  );
}

export function FeatureLink({
  to,
  kicker,
  title,
  text,
}: {
  to: string;
  kicker: string;
  title: string;
  text: string;
}) {
  return (
    <Link to={to} className="feature-link">
      <span>
        <small>{kicker}</small>
        <strong>{title}</strong>
        <span>{text}</span>
      </span>
    </Link>
  );
}

export function Dialog({
  open,
  onClose,
  title,
  children,
}: {
  open: boolean;
  onClose: () => void;
  title: string;
  children: ReactNode;
}) {
  useEffect(() => {
    if (!open) return;
    const onKey = (event: KeyboardEvent) => event.key === "Escape" && onClose();
    document.addEventListener("keydown", onKey);
    document.body.style.overflow = "hidden";
    return () => {
      document.removeEventListener("keydown", onKey);
      document.body.style.overflow = "";
    };
  }, [open, onClose]);

  if (!open) return null;
  return (
    <div className="dialog-backdrop" onMouseDown={onClose}>
      <section
        className="dialog"
        role="dialog"
        aria-modal="true"
        aria-label={title}
        onMouseDown={(event) => event.stopPropagation()}
      >
        <div className="dialog-ornament ornament-left" aria-hidden="true" />
        <div className="dialog-ornament ornament-right" aria-hidden="true" />
        <header className="dialog-header">
          <span>Ficha</span>
          <strong>{title}</strong>
          <button className="dialog-close" onClick={onClose} aria-label="Cerrar ficha">
            <span>Cerrar</span>
            <X />
          </button>
        </header>
        <div className="dialog-content">{children}</div>
      </section>
    </div>
  );
}

export const portalLinks = [
  {
    to: "/universo",
    kicker: "Universo",
    title: "Hextech, brillo y un puente",
    text: "Lo básico para entender por qué Piltover y Zaun no se soportan.",
  },
  {
    to: "/atlas",
    kicker: "Atlas",
    title: "Dónde está cada sitio",
    text: "De las Hexpuertas al Sumidero, sobre el mapa del juego.",
  },
  {
    to: "/videojuego",
    kicker: "Videojuego",
    title: "El juego que estoy haciendo",
    text: "Un fangame narrativo en Godot: creas a tu personaje y vives las dos temporadas desde dentro.",
  },
  {
    to: "/contacto",
    kicker: "Contacto",
    title: "¿Has visto un error?",
    text: "Si algo no cuadra con la serie, cuéntamelo.",
  },
];

export function NotFound() {
  return (
    <section className="not-found">
      <h1>Aquí no hay nada.</h1>
      <p>Esta página no existe, o se ha perdido en algún callejón de Zaun.</p>
      <Link to="/" className="button primary">
        Volver al inicio
      </Link>
    </section>
  );
}
