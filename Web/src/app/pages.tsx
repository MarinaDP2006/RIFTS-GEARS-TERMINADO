import { useMemo, useState, type FormEvent } from "react";
import { Search, ZoomIn, ZoomOut } from "lucide-react";
import { Link } from "react-router";
import { Dialog, Eyebrow, FeatureLink, Media, PageHero, portalLinks } from "./components";
import {
  GITHUB,
  characters,
  places,
  screenshots,
  type Character,
  type City,
  type Place,
} from "./data";

export function HomePage() {
  return (
    <>
      <section className="home-hero">
        <img
          src="/assets/rifts-gears-hero.webp"
          alt="Vista panorámica de una ciudad elevada entre nubes al atardecer"
        />
        <div className="home-hero-overlay" />
        <div className="hero-content">
          <Eyebrow>Un archivo entre dos ciudades</Eyebrow>
          <h1>
            Rifts <span>&</span> Gears
          </h1>
          <p>
            Explora una frontera hecha de progreso, humo y decisiones. Un portal narrativo dedicado
            a Piltover, Zaun y a las historias que surgen entre ambas.
          </p>
          <div className="hero-actions">
            <Link to="/universo" className="button primary">
              Explorar el universo
            </Link>
            <Link to="/videojuego" className="button ghost">
              El videojuego
            </Link>
          </div>
        </div>
        <a href="#portales" className="scroll-cue" aria-label="Descubrir contenido">
          <span>Descubrir</span>
        </a>
      </section>

      <section className="intro-section" id="portales">
        <div className="section-heading split-heading">
          <div>
            <Eyebrow>Dos ciudades · una fractura</Eyebrow>
            <h2>Todo progreso proyecta una sombra.</h2>
          </div>
          <p>
            Este portal separa el archivo informativo del proyecto de videojuego y organiza cada
            contenido para crecer sin perder claridad.
          </p>
        </div>
        <div className="city-duo">
          <Link to="/ciudades#piltover" className="city-panel piltover-panel">
            <div>
              <small>Ciudad del progreso</small>
              <h3>Piltover</h3>
              <p>Torres de bronce, instituciones y una promesa de avance.</p>
              <span>Entrar en la ciudad</span>
            </div>
          </Link>
          <Link to="/ciudades#zaun" className="city-panel zaun-panel">
            <div>
              <small>La ciudad subterránea</small>
              <h3>Zaun</h3>
              <p>Industria, resistencia y vida bajo el resplandor químico.</p>
              <span>Descender a Zaun</span>
            </div>
          </Link>
        </div>
      </section>

      <section className="portal-grid section-pad">
        {portalLinks.map((item) => (
          <FeatureLink key={item.to} {...item} />
        ))}
      </section>

      <section className="game-teaser">
        <div className="game-teaser-copy">
          <Eyebrow>En desarrollo · Godot Engine</Eyebrow>
          <h2>Una historia para jugar. Otro proyecto, el mismo universo.</h2>
          <p>
            Rifts & Gears también da nombre a una aventura narrativa para un jugador. Eliges
            Piltover o Zaun, creas tu personaje y empiezas tu historia en el Puente. El videojuego se
            desarrolla de forma independiente y no forma parte del funcionamiento de este portal.
          </p>
          <Link to="/videojuego" className="text-link">
            Conocer el proyecto
          </Link>
        </div>
        <Media src="/assets/img/capturas/inicio.webp" alt="Menú de inicio del videojuego Rifts & Gears" />
      </section>
    </>
  );
}

export function UniversePage() {
  const topics = [
    {
      title: "Una frontera vertical",
      text: "Piltover se alza sobre Zaun. Su proximidad física contrasta con una profunda separación social, política y económica.",
    },
    {
      title: "Hextech",
      text: "Una tecnología que combina magia y ciencia, ligada al desarrollo y al poder de Piltover.",
    },
    {
      title: "Shimmer",
      text: "Una sustancia asociada a Zaun con efectos transformadores y consecuencias peligrosas.",
    },
    {
      title: "Poder y resistencia",
      text: "Instituciones, inventores, comerciantes y comunidades disputan quién decide el futuro de ambas ciudades.",
    },
  ];
  return (
    <>
      <PageHero
        eyebrow="Archivo I · Universo"
        title="Dos visiones del progreso."
        text="Una introducción al escenario de Rifts & Gears: Piltover arriba, Zaun debajo y el Puente del Progreso entre las dos."
      />
      <section className="editorial-lead section-pad">
        <div>
          <Eyebrow>Contexto</Eyebrow>
          <h2>Piltover y Zaun comparten cimientos, pero no el mismo horizonte.</h2>
        </div>
        <div className="prose">
          <p>
            Piltover representa la prosperidad, la investigación y el reconocimiento público. Bajo
            sus puentes y torres, Zaun convive con la industria, la contaminación y una identidad
            construida desde la resistencia.
          </p>
          <p>
            El Códice del juego reúne 53 entradas en cinco categorías: personajes, lugares,
            criaturas y razas, tecnologías, y mundos y facciones.
          </p>
          <span className="status-note">Archivo en ampliación</span>
        </div>
      </section>
      <section className="topic-grid section-pad">
        {topics.map((topic, index) => (
          <article className="topic-card" key={topic.title}>
            <span className="topic-number">0{index + 1}</span>
            <h3>{topic.title}</h3>
            <p>{topic.text}</p>
          </article>
        ))}
      </section>
      <section className="comparison section-pad">
        <div className="comparison-column piltover-copy">
          <Eyebrow>Piltover</Eyebrow>
          <h2>La promesa visible.</h2>
          <p>
            El progreso se expresa a través de academias, comercio, arquitectura monumental y
            tecnología. Su brillo también plantea preguntas sobre quién puede acceder a ese futuro.
          </p>
          <Link to="/ciudades#piltover" className="text-link">
            Explorar Piltover
          </Link>
        </div>
        <div className="comparison-line" />
        <div className="comparison-column zaun-copy">
          <Eyebrow>Zaun</Eyebrow>
          <h2>La vida bajo la superficie.</h2>
          <p>
            Talleres, mercados, comunidades e inventos sobreviven entre niveles industriales. Zaun
            no es solo decadencia: es adaptación, identidad y resistencia.
          </p>
          <Link to="/ciudades#zaun" className="text-link">
            Explorar Zaun
          </Link>
        </div>
      </section>
    </>
  );
}

const cityImages: Record<"Piltover" | "Zaun", { hero: string; gallery: string[] }> = {
  Piltover: {
    hero: "/assets/img/ciudades/piltover/panorama-t1.webp",
    gallery: [
      "/assets/img/ciudades/piltover/panorama-t2.webp",
      "/assets/img/ciudades/piltover/artesanos-t1.webp",
      "/assets/img/ciudades/piltover/hexpuertas-t2.webp",
    ],
  },
  Zaun: {
    hero: "/assets/img/ciudades/zaun/ciudad-subterranea.jpg",
    gallery: [
      "/assets/img/ciudades/zaun/centro.jpg",
      "/assets/img/ciudades/zaun/muelles.jpg",
      "/assets/img/ciudades/zaun/comuna-viktor.jpg",
    ],
  },
};

const galleryText = [
  ["Arquitectura y escala", "Cómo se construye la ciudad y a quién está pensada para impresionar."],
  ["Vida entre distritos", "Mercados, calles y vecinos que hacen que la ciudad funcione."],
  ["Tecnología y atmósfera", "La luz, el humo y los inventos que dan a cada nivel su carácter."],
];

function CitySection({
  city,
  kicker,
  title,
  description,
  points,
}: {
  city: "Piltover" | "Zaun";
  kicker: string;
  title: string;
  description: string;
  points: string[];
}) {
  const isPiltover = city === "Piltover";
  const images = cityImages[city];
  return (
    <section id={city.toLowerCase()} className={`city-section ${city.toLowerCase()}`}>
      <div className="city-visual">
        <Media src={images.hero} alt={`Panorámica de ${city}`} />
      </div>
      <div className="city-copy">
        <Eyebrow>{kicker}</Eyebrow>
        <h2>{title}</h2>
        <p>{description}</p>
        <ul className="city-points">
          {points.map((point) => (
            <li key={point}>{point}</li>
          ))}
        </ul>
        <Link to={`/atlas?ciudad=${city.toLowerCase()}`} className="button secondary">
          Abrir en el atlas
        </Link>
      </div>
      <div className="mini-gallery">
        {images.gallery.map((src, index) => (
          <figure key={src} className="gallery-entry">
            <Media src={src} alt={`${city}: ${galleryText[index][0]}`} />
            <figcaption>
              <span>0{index + 1}</span>
              <div>
                <strong>{galleryText[index][0]}</strong>
                <p>{galleryText[index][1]}</p>
              </div>
            </figcaption>
          </figure>
        ))}
      </div>
      <div className="city-places">
        <Eyebrow>Lugares destacados</Eyebrow>
        <div>
          {places
            .filter((place) => place.city === city)
            .slice(0, 3)
            .map((place) => (
              <Link to="/lugares" key={place.name}>
                <span>{place.category}</span>
                <strong>{place.name}</strong>
              </Link>
            ))}
        </div>
      </div>
      {isPiltover && <div className="city-divider" />}
    </section>
  );
}

export function CitiesPage() {
  return (
    <>
      <PageHero
        eyebrow="Archivo II · Ciudades"
        title="Arriba, el oro. Debajo, el neón."
        text="Dos identidades visuales dentro de un mismo mundo. Recorre su arquitectura, su sociedad y los lugares que definen cada nivel."
      />
      <nav className="local-nav" aria-label="Ciudades">
        <a href="#piltover">Piltover</a>
        <a href="#zaun">Zaun</a>
      </nav>
      <CitySection
        city="Piltover"
        kicker="Ciudad del progreso"
        title="Una ciudad construida para mirar al futuro."
        description="Piltover expresa su poder mediante grandes avenidas, torres, puentes e instituciones dedicadas al conocimiento. La luz cálida y los metales pulidos definen su presencia visual."
        points={["Arquitectura monumental", "Investigación y comercio", "Desarrollo de Hextech"]}
      />
      <CitySection
        city="Zaun"
        kicker="La ciudad subterránea"
        title="Ingenio, peligro y vida entre niveles."
        description="Zaun crece de forma vertical entre tuberías, talleres, pasarelas y gases industriales. Su identidad nace de la adaptación y de las comunidades que resisten bajo Piltover."
        points={["Estructura industrial", "Comunidades autónomas", "Química y tecnología propia"]}
      />
    </>
  );
}

export function CharactersPage() {
  const [selected, setSelected] = useState<Character | null>(null);
  const [filter, setFilter] = useState<"Todos" | City>("Todos");
  const visible = characters.filter((character) => filter === "Todos" || character.city === filter);
  return (
    <>
      <PageHero
        eyebrow="Archivo III · Personajes"
        title="Vidas a ambos lados de la grieta."
        text="Las 16 figuras de Piltover, Zaun y Noxus que encontrarás en el juego. Sus historias ya están en marcha; tus decisiones pueden cruzarse con las suyas."
      />
      <section className="library section-pad">
        <div className="library-tools">
          <div className="filter-group" aria-label="Filtrar personajes">
            {(["Todos", "Piltover", "Zaun", "Noxus"] as const).map((item) => (
              <button
                key={item}
                className={filter === item ? "active" : ""}
                onClick={() => setFilter(item)}
              >
                {item}
              </button>
            ))}
          </div>
          <p>{visible.length} registros</p>
        </div>
        <div className="character-grid">
          {visible.map((character) => (
            <button
              className={`character-card ${character.city.toLowerCase()}`}
              key={character.name}
              onClick={() => setSelected(character)}
            >
              <Media src={character.image} alt={`Retrato de ${character.name}`} ratio="portrait" />
              <span className="card-city">{character.city}</span>
              <span className="card-copy">
                <small>{character.role}</small>
                <strong>{character.name}</strong>
                <span>Ver ficha</span>
              </span>
            </button>
          ))}
        </div>
      </section>
      <Dialog open={!!selected} onClose={() => setSelected(null)} title={selected?.name ?? ""}>
        {selected && (
          <div className="record-detail">
            <Media src={selected.image} alt={`Retrato de ${selected.name}`} ratio="portrait" />
            <div>
              <Eyebrow>{selected.city}</Eyebrow>
              <h2>{selected.name}</h2>
              <span className="record-role">{selected.role}</span>
              <p>{selected.summary}</p>
              <p className="provisional">
                Su ficha completa, con relaciones y cronología, está en el Códice del juego.
              </p>
            </div>
          </div>
        )}
      </Dialog>
    </>
  );
}

export function PlacesPage() {
  const [city, setCity] = useState<"Todas" | Place["city"]>("Todas");
  const [category, setCategory] = useState("Todas");
  const [query, setQuery] = useState("");
  const [selected, setSelected] = useState<Place | null>(null);
  const categories = ["Todas", ...new Set(places.map((place) => place.category))];
  const visible = useMemo(
    () =>
      places.filter(
        (place) =>
          (city === "Todas" || place.city === city) &&
          (category === "Todas" || place.category === category) &&
          place.name.toLowerCase().includes(query.toLowerCase()),
      ),
    [city, category, query],
  );
  return (
    <>
      <PageHero
        eyebrow="Archivo IV · Lugares"
        title="Cada esquina guarda una historia."
        text="Los 14 lugares de Piltover y Zaun: instituciones, distritos, comercios, infraestructuras y refugios."
      />
      <section className="library section-pad">
        <div className="place-toolbar">
          <label className="search-field">
            <Search />
            <span className="sr-only">Buscar lugar</span>
            <input
              value={query}
              onChange={(event) => setQuery(event.target.value)}
              placeholder="Buscar un lugar..."
            />
          </label>
          <label>
            <span>Ciudad</span>
            <select
              value={city}
              onChange={(event) => setCity(event.target.value as "Todas" | Place["city"])}
            >
              <option>Todas</option>
              <option>Piltover</option>
              <option>Zaun</option>
            </select>
          </label>
          <label>
            <span>Categoría</span>
            <select value={category} onChange={(event) => setCategory(event.target.value)}>
              {categories.map((item) => (
                <option key={item}>{item}</option>
              ))}
            </select>
          </label>
        </div>
        <p className="result-count">{visible.length} lugares encontrados</p>
        <div className="place-grid">
          {visible.map((place) => (
            <article className="place-card" key={place.name}>
              <Media src={place.image} alt={place.name} />
              <div>
                <span className={`city-tag ${place.city.toLowerCase()}`}>{place.city}</span>
                <small>{place.category}</small>
                <h2>{place.name}</h2>
                <p>{place.summary}</p>
                <button className="text-link" onClick={() => setSelected(place)}>
                  Abrir ficha
                </button>
              </div>
            </article>
          ))}
        </div>
        {visible.length === 0 && (
          <div className="empty-state">
            <h2>No hay lugares con estos filtros.</h2>
            <button
              onClick={() => {
                setCity("Todas");
                setCategory("Todas");
                setQuery("");
              }}
            >
              Limpiar filtros
            </button>
          </div>
        )}
      </section>
      <Dialog open={!!selected} onClose={() => setSelected(null)} title={selected?.name ?? ""}>
        {selected && (
          <div className="place-detail">
            <Media src={selected.image} alt={selected.name} />
            <Eyebrow>
              {selected.city} · {selected.zone}
            </Eyebrow>
            <h2>{selected.name}</h2>
            <p>{selected.summary}</p>
            <p className="provisional">Categoría: {selected.category}.</p>
          </div>
        )}
      </Dialog>
    </>
  );
}

export function AtlasPage() {
  const [selected, setSelected] = useState<Place>(places[0]);
  const [zoom, setZoom] = useState(1);
  return (
    <>
      <PageHero
        eyebrow="Archivo V · Atlas"
        title="Un mapa preparado para crecer."
        text="Piltover arriba, Zaun debajo. Selecciona un marcador para ver la ficha de cada lugar."
      />
      <section className="atlas section-pad">
        <div className="atlas-notice">
          <p>
            <strong>Mapa en desarrollo.</strong> Las posiciones de los marcadores son orientativas;
            el mapa definitivo llegará con el juego.
          </p>
        </div>
        <div className="atlas-layout">
          <div className="map-stage">
            <div className="map-placeholder" style={{ transform: `scale(${zoom})` }}>
              <img className="map-backdrop" src="/assets/img/capturas/mapa-3d.webp" alt="" />
              <div className="map-half piltover-map">
                <span>Piltover</span>
              </div>
              <div className="map-half zaun-map">
                <span>Zaun</span>
              </div>
              {places.map((place, index) => (
                <button
                  key={place.name}
                  className={`map-marker ${selected.name === place.name ? "active" : ""}`}
                  style={{
                    left: `${18 + ((index * 17) % 65)}%`,
                    top: `${place.city === "Piltover" ? 22 + (index % 3) * 9 : 58 + (index % 3) * 8}%`,
                  }}
                  onClick={() => setSelected(place)}
                  aria-label={`Seleccionar ${place.name}`}
                >
                  <span>{index + 1}</span>
                </button>
              ))}
            </div>
            <div className="zoom-controls">
              <button
                onClick={() => setZoom((value) => Math.min(1.25, value + 0.1))}
                aria-label="Ampliar mapa"
              >
                <ZoomIn />
              </button>
              <button
                onClick={() => setZoom((value) => Math.max(0.9, value - 0.1))}
                aria-label="Reducir mapa"
              >
                <ZoomOut />
              </button>
            </div>
          </div>
          <aside className={`atlas-panel ${selected.city.toLowerCase()}`}>
            <span className="map-index">
              {String(places.indexOf(selected) + 1).padStart(2, "0")}
            </span>
            <Eyebrow>{selected.city}</Eyebrow>
            <h2>{selected.name}</h2>
            <small>{selected.zone}</small>
            <p>{selected.summary}</p>
            <Link to="/lugares" className="text-link">
              Ver biblioteca de lugares
            </Link>
          </aside>
        </div>
      </section>
    </>
  );
}

export function GamePage() {
  const features = [
    ["Creación de personaje", "Eliges ciudad, procedencia, familia y aspecto de tu protagonista en siete apartados."],
    ["Historia y decisiones", "30 capítulos en dos partes y 8 finales que dependen de lo que decides."],
    ["Mapa 3D lineal", "Avanzas de parada en parada, cruzas el Puente y bajas a Zaun por el ascensor de carga."],
    ["Códice y atlas", "53 entradas del Códice, siempre completas, y un Atlas 2D para orientarte."],
    ["Relaciones y misiones", "Historia principal, misiones secundarias e historias jugables con 16 personajes."],
    ["Dos partidas", "Un espacio de guardado para Piltover y otro para Zaun, con cargar, borrar y exportar."],
  ];
  return (
    <>
      <section className="game-hero">
        <div className="game-hero-copy">
          <Eyebrow>Videojuego narrativo · Godot Engine</Eyebrow>
          <h1>Tu historia comienza entre dos mundos.</h1>
          <p>
            Una experiencia para un jugador desarrollada de forma independiente en Godot 4. Al
            empezar y al cargar partida apareces siempre en el Puente, entre Piltover y Zaun. Esta
            página presenta el proyecto; el juego todavía no está disponible para descargar.
          </p>
          <span className="development-badge">Actualmente en desarrollo</span>
        </div>
        <Media
          src="/assets/img/capturas/creacion-personaje.webp"
          alt="Pantalla de creación de personaje del videojuego"
        />
      </section>
      <section className="game-intro section-pad">
        <div>
          <Eyebrow>Concepto</Eyebrow>
          <h2>Una experiencia propia dentro de un universo conocido.</h2>
        </div>
        <p>
          Una historia interactiva ambientada entre Piltover y Zaun: creas tu personaje, eliges
          ciudad y vives una aventura de diálogos, misiones y relaciones. Las mecánicas se
          construyen por etapas y pueden cambiar mientras el juego avanza.
        </p>
      </section>
      <section className="game-features section-pad">
        {features.map(([title, text], index) => (
          <article key={title}>
            <span className="feature-index">{String(index + 1).padStart(2, "0")}</span>
            <h3>{title}</h3>
            <p>{text}</p>
          </article>
        ))}
      </section>
      <section className="game-shots section-pad">
        <div className="section-heading">
          <Eyebrow>Capturas del juego</Eyebrow>
          <h2>El juego, pantalla a pantalla.</h2>
        </div>
        <div className="shots-grid">
          {screenshots.map((shot) => (
            <figure key={shot.src}>
              <Media src={shot.src} alt={`Captura del juego: ${shot.label}`} />
              <figcaption>{shot.label}</figcaption>
            </figure>
          ))}
        </div>
      </section>
      <section className="game-status section-pad">
        <div>
          <Eyebrow>Disponibilidad</Eyebrow>
          <h2>Sin descarga pública por ahora.</h2>
          <p>
            Puedes seguir el desarrollo en el repositorio del proyecto. Cuando haya una versión
            jugable, aparecerá aquí con su enlace de descarga.
          </p>
        </div>
        <a href={GITHUB} className="button secondary">
          Ver el repositorio
        </a>
      </section>
    </>
  );
}

type FormErrors = Partial<Record<"name" | "subject" | "message" | "email", string>>;

export function ContactPage() {
  const [errors, setErrors] = useState<FormErrors>({});
  const [saved, setSaved] = useState(false);

  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const form = new FormData(event.currentTarget);
    const nextErrors: FormErrors = {};
    const name = String(form.get("name") || "").trim();
    const subject = String(form.get("subject") || "").trim();
    const message = String(form.get("message") || "").trim();
    const email = String(form.get("email") || "").trim();
    if (name.length < 2) nextErrors.name = "Introduce al menos 2 caracteres.";
    if (subject.length < 4) nextErrors.subject = "El asunto debe ser más descriptivo.";
    if (message.length < 20) nextErrors.message = "El mensaje debe tener al menos 20 caracteres.";
    if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email))
      nextErrors.email = "Introduce un correo válido o deja el campo vacío.";
    setErrors(nextErrors);
    if (Object.keys(nextErrors).length) return;
    try {
      localStorage.setItem(
        "rifts-gears-contact-draft",
        JSON.stringify(Object.fromEntries(form.entries())),
      );
    } catch {
      // Si el navegador no deja guardar, el borrador se pierde, pero la validación sigue siendo válida.
    }
    setSaved(true);
  }

  return (
    <>
      <PageHero
        eyebrow="Contacto · Comunidad"
        title="Ayuda a construir el archivo."
        text="Comparte correcciones, ideas o recursos. Las propuestas se gestionan en el repositorio del proyecto en GitHub."
      />
      <section className="contact-layout section-pad">
        <aside>
          <Eyebrow>Antes de enviar</Eyebrow>
          <h2>Tu mensaje importa.</h2>
          <p>
            El portal está preparado para crecer con contenido revisado. Puedes señalar errores de
            accesibilidad, lore, navegación o proponer nuevos registros.
          </p>
          <div className="integration-note">
            <div>
              <strong>Envío por GitHub</strong>
              <p>
                El formulario valida tu mensaje y guarda un borrador en este navegador. Para
                enviarlo, abre una incidencia en el{" "}
                <a href={`${GITHUB}/issues`} className="inline-link">
                  repositorio del proyecto
                </a>
                .
              </p>
            </div>
          </div>
        </aside>
        <form className="contact-form" onSubmit={submit} noValidate>
          {saved && (
            <div className="form-success" role="status">
              <div>
                <strong>Borrador validado y guardado.</strong>
                <p>
                  No se ha enviado nada. Copia tu mensaje en una{" "}
                  <a href={`${GITHUB}/issues/new`} className="inline-link">
                    incidencia nueva de GitHub
                  </a>
                  .
                </p>
              </div>
            </div>
          )}
          <div className="form-row">
            <Field label="Nombre o alias" name="name" required error={errors.name} />
            <Field label="Correo (opcional)" name="email" type="email" error={errors.email} />
          </div>
          <div className="form-row">
            <Field label="Asunto" name="subject" required error={errors.subject} />
            <label className="form-field">
              <span>Tipo de sugerencia</span>
              <select name="type" defaultValue="Contenido">
                <option>Contenido</option>
                <option>Corrección de lore</option>
                <option>Accesibilidad</option>
                <option>Problema técnico</option>
                <option>Otro</option>
              </select>
            </label>
          </div>
          <label className="form-field">
            <span>Mensaje</span>
            <textarea name="message" rows={7} aria-invalid={!!errors.message} />
            {errors.message && <small className="field-error">{errors.message}</small>}
          </label>
          <button className="button primary" type="submit">
            Validar y guardar borrador
          </button>
        </form>
      </section>
    </>
  );
}

function Field({
  label,
  name,
  type = "text",
  required,
  error,
}: {
  label: string;
  name: string;
  type?: string;
  required?: boolean;
  error?: string;
}) {
  return (
    <label className="form-field">
      <span>
        {label} {required && <em>Requerido</em>}
      </span>
      <input name={name} type={type} aria-invalid={!!error} />
      {error && <small className="field-error">{error}</small>}
    </label>
  );
}
