import { useEffect, useSyncExternalStore } from "react";
import { Music, Pause, Play } from "lucide-react";

/* ------------------------------------------------------------------ */
/* Música: un único reproductor para toda la web                       */
/* ------------------------------------------------------------------ */

export const tracks = {
  inicio: {
    title: "Tema de inicio",
    text: "Suena en el menú principal del juego.",
    src: "/assets/music/menu-theme.mp3",
  },
  piltover: {
    title: "Piltover",
    text: "Suena cuando tu historia empieza arriba.",
    src: "/assets/music/piltover-theme.mp3",
  },
  zaun: {
    title: "Zaun",
    text: "Suena cuando tu historia empieza abajo.",
    src: "/assets/music/zaun-theme.mp3",
  },
} as const;

export type TrackId = keyof typeof tracks;

type MusicState = { track: TrackId; playing: boolean };
let state: MusicState = { track: "inicio", playing: false };
let audio: HTMLAudioElement | null = null;
const listeners = new Set<() => void>();

function emit(next: MusicState) {
  state = next;
  listeners.forEach((listener) => listener());
}

function getAudio() {
  if (!audio) {
    audio = new Audio(tracks[state.track].src);
    audio.loop = true;
    audio.volume = 0.45;
    audio.addEventListener("pause", () => emit({ ...state, playing: false }));
    audio.addEventListener("play", () => emit({ ...state, playing: true }));
  }
  return audio;
}

/** Pone una pista. Si ya sonaba esa misma, la pausa o la reanuda. */
export function playTrack(track: TrackId) {
  const player = getAudio();
  if (state.track === track) {
    if (player.paused) void player.play().catch(() => undefined);
    else player.pause();
    return;
  }
  emit({ track, playing: false });
  player.src = tracks[track].src;
  void player.play().catch(() => undefined);
}

export function useMusic() {
  return useSyncExternalStore(
    (listener) => {
      listeners.add(listener);
      return () => listeners.delete(listener);
    },
    () => state,
  );
}

/** Botón flotante que acompaña en todas las páginas. */
export function MusicPlayer() {
  const music = useMusic();
  useEffect(() => () => audio?.pause(), []);
  return (
    <div className={`music-player ${music.playing ? "is-playing" : ""}`}>
      <button
        className="music-main"
        onClick={() => playTrack(music.track)}
        aria-label={music.playing ? "Pausar la música" : "Escuchar la música del juego"}
      >
        {music.playing ? <Pause /> : <Music />}
        <span className="music-bars" aria-hidden="true">
          <i />
          <i />
          <i />
        </span>
      </button>
      <div className="music-panel">
        <small>Música del juego</small>
        <strong>{tracks[music.track].title}</strong>
        <div className="music-chips">
          {(Object.keys(tracks) as TrackId[]).map((id) => (
            <button
              key={id}
              className={`${id} ${music.track === id ? "active" : ""}`}
              onClick={() => playTrack(id)}
            >
              {tracks[id].title}
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}

/** Tarjeta para escuchar una pista concreta. */
export function TrackCard({ id }: { id: TrackId }) {
  const music = useMusic();
  const on = music.track === id && music.playing;
  return (
    <button className={`track-card ${id} ${on ? "is-playing" : ""}`} onClick={() => playTrack(id)}>
      <span className="track-icon">{on ? <Pause /> : <Play />}</span>
      <span>
        <strong>{tracks[id].title}</strong>
        <small>{tracks[id].text}</small>
      </span>
      <span className="music-bars" aria-hidden="true">
        <i />
        <i />
        <i />
        <i />
      </span>
    </button>
  );
}

/* ------------------------------------------------------------------ */
/* Animaciones dibujadas para la web                                   */
/* ------------------------------------------------------------------ */

/** Partículas de shimmer que suben despacio. Posiciones fijas, sin azar. */
export function ShimmerField({ count = 26, tone = "shimmer" }: { count?: number; tone?: "shimmer" | "gold" }) {
  return (
    <div className={`shimmer-field ${tone}`} aria-hidden="true">
      {Array.from({ length: count }, (_, i) => {
        const left = (i * 37) % 100;
        const size = 3 + ((i * 7) % 6);
        const delay = -((i * 1.7) % 14);
        const duration = 10 + ((i * 3) % 9);
        return (
          <i
            key={i}
            style={{
              left: `${left}%`,
              width: size,
              height: size,
              animationDelay: `${delay}s`,
              animationDuration: `${duration}s`,
            }}
          />
        );
      })}
    </div>
  );
}

/** Garabato hextech: hexágonos, runas y un cristal que se dibujan solos. */
export function HextechDoodle({ className = "" }: { className?: string }) {
  return (
    <svg className={`hextech-doodle ${className}`} viewBox="0 0 400 400" aria-hidden="true">
      <g className="hx-spin">
        <circle cx="200" cy="200" r="170" className="hx-line" />
        <circle cx="200" cy="200" r="150" className="hx-line thin dashed" />
        {Array.from({ length: 12 }, (_, i) => (
          <line
            key={i}
            x1="200"
            y1="34"
            x2="200"
            y2="52"
            className="hx-line thin"
            transform={`rotate(${i * 30} 200 200)`}
          />
        ))}
      </g>
      <g className="hx-spin reverse">
        <polygon points="200,70 312,135 312,265 200,330 88,265 88,135" className="hx-line" />
        <polygon points="200,110 278,155 278,245 200,290 122,245 122,155" className="hx-line thin" />
      </g>
      <path d="M200 110 L200 150 M278 155 L243 175 M278 245 L243 225 M200 290 L200 250 M122 245 L157 225 M122 155 L157 175" className="hx-line thin" />
      <polygon points="200,150 236,200 200,250 164,200" className="hx-crystal" />
      <polygon points="200,150 236,200 200,250 164,200" className="hx-line" />
      <path d="M182 200 h36 M200 175 v50" className="hx-line thin" />
    </svg>
  );
}

/** Garabatos de graffiti al estilo de las paredes de Zaun. */
export function GraffitiDoodle({ className = "" }: { className?: string }) {
  return (
    <svg className={`graffiti-doodle ${className}`} viewBox="0 0 420 300" aria-hidden="true">
      <path className="gf pink" d="M30 60 l40 40 M70 60 l-40 40" />
      <path className="gf shimmer" d="M110 90 q20 -50 45 0 t45 0 t45 0" />
      <circle className="gf pink" cx="330" cy="70" r="34" />
      <path className="gf pink" d="M316 62 v6 M344 62 v6 M314 84 q16 14 32 0" />
      <path className="gf shimmer" d="M40 200 c30 -40 70 40 100 0 s70 40 100 0" />
      <path className="gf blue" d="M270 170 l60 40 l-25 6 l18 34" />
      <path className="gf pink" d="M120 250 l14 -30 l14 30 l-34 -18 h40 z" />
      <path className="gf blue" d="M360 230 q20 20 0 40 q-20 20 -40 0" />
    </svg>
  );
}

/** Engranaje de latón que gira. */
export function Gear({ size = 120, className = "", teeth = 12 }: { size?: number; className?: string; teeth?: number }) {
  const outer = 46;
  const inner = 38;
  const points: string[] = [];
  for (let i = 0; i < teeth * 2; i++) {
    const a1 = (Math.PI * 2 * i) / (teeth * 2);
    const a2 = (Math.PI * 2 * (i + 1)) / (teeth * 2);
    const r = i % 2 === 0 ? outer : inner;
    points.push(`${50 + r * Math.cos(a1)},${50 + r * Math.sin(a1)}`, `${50 + r * Math.cos(a2)},${50 + r * Math.sin(a2)}`);
  }
  return (
    <svg className={`gear ${className}`} width={size} height={size} viewBox="0 0 100 100" aria-hidden="true">
      <polygon points={points.join(" ")} />
      <circle cx="50" cy="50" r="22" />
      <circle cx="50" cy="50" r="8" />
    </svg>
  );
}
