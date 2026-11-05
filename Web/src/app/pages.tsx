import { useMemo, useRef, useState, type FormEvent } from "react";
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

/** Aviso que cierra cada ficha: aquí solo va un resumen. */
function CodiceNote() {
  return (
    <p className="provisional">
      Esto es un resumen. La ficha completa, con su relación contigo, está en el Códice del juego.
    </p>
  );
}

export function HomePage() {
  return (
    <>
      <section className="home-hero">
        <img
          src="/assets/rifts-gears-hero.webp"
          alt="Piltover al atardecer, con sus torres y dirigibles"
        />
        <div className="home-hero-overlay" />
        <div className="hero-content">
          <h1>
            Rifts <span>&</span> Gears
          </h1>
          <div className="hero-actions">
            <Link to="/universo" className="button primary">
              Entrar
            </Link>
            <Link to="/videojuego" className="button ghost">
              El videojuego
            </Link>
          </div>
        </div>
      </section>

      <section className="intro-section" id="portales">
        <div className="city-duo">
          <Link to="/ciudades#piltover" className="city-panel piltover-panel">
            <div>
              <small>Arriba</small>
              <h3>Piltover</h3>
              <p>La Ciudad del Progreso: la Academia, el Consejo y las Hexpuertas.</p>
              <span>Ver Piltover</span>
            </div>
          </Link>
          <Link to="/ciudades#zaun" className="city-panel zaun-panel">
            <div>
              <small>Abajo</small>
              <h3>Zaun</h3>
              <p>Humo, neón, químbarones y el bar de Vander.</p>
              <span>Bajar a Zaun</span>
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
          <h2>El videojuego</h2>
          <p>
            Rifts & Gears es también el juego que estoy haciendo en Godot para mi TFG. Eliges
            Piltover o Zaun, creas a tu personaje con su familia y su barrio, y vives las dos
            temporadas desde dentro, hablando con Vi, Jinx, Jayce o Silco.
          </p>
          <Link to="/videojuego" className="text-link">
            Ver cómo va
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
      title: "Hextech",
      text: "Runas grabadas en cristales mágicos que canalizan su energía. Jayce la inventa, Viktor la hace funcionar y Heimerdinger avisa de que es peligrosa. Mueve las Hexpuertas, el martillo de Jayce y el rifle de Caitlyn.",
    },
    {
      title: "Quimtec",
      text: "La tecnología de Zaun: química, vapor y chatarra en vez de magia. Más barata y mucho más peligrosa. De aquí salen las prótesis como el brazo de Sevika, las bombas de Jinx y las aerotablas de las Luciérnagas.",
    },
    {
      title: "El brillo",
      text: "Una droga púrpura que fabrica Singed y vende Silco. Da una fuerza enorme a quien la toma y lo va destruyendo por dentro. Con ella Silco paga su sueño de una Zaun libre.",
    },
    {
      title: "El Puente del Progreso",
      text: "El único paso entre las dos ciudades. Años antes de la serie, Vander y Silco encabezaron allí una revuelta que acabó mal. De aquella derrota sale la tregua entre Vander y los ejecutores.",
    },
    {
      title: "El Consejo",
      text: "Gobierna Piltover: las grandes familias, como los Kiramman o los Medarda, y el decano Heimerdinger. Los ejecutores hacen cumplir sus leyes, sobre todo en la frontera con Zaun.",
    },
    {
      title: "Noxus",
      text: "Un imperio que vive de la guerra. Mel viene de allí y su madre, Ambessa, llega a Piltover buscando hextech para sus ejércitos. En la T2 Noxus ya está dentro de la ciudad.",
    },
  ];
  const timeline = [
    ["Antes", "La revuelta del Puente. Vander pacta una tregua con los ejecutores y Silco y él se separan."],
    ["T1 · Infancia", "Vi, Powder, Mylo y Claggor viven con Vander. Un robo en Piltover lo desencadena todo."],
    ["T1 · Infancia", "Jayce investiga la magia y, con Viktor, consigue que la hextech funcione."],
    ["T1 · Infancia", "Silco se hace con el subsuelo. Vi y Powder quedan separadas."],
    ["T1 · Años después", "Piltover vive su edad de oro con las Hexpuertas. En Zaun crece el brillo."],
    ["T1 · Juventud", "Caitlyn y Vi bajan a Zaun, las Luciérnagas sabotean a Silco y el Consejo se divide."],
    ["Final T1", "Un intento de paz… y un ataque al Consejo que lo cambia todo."],
    ["T2 · Después del ataque", "Piltover busca culpables en Zaun, los ejecutores bajan armados y Jinx se convierte en un símbolo."],
    ["T2", "Noxus entra en Piltover, Viktor busca su propio camino y las dos ciudades acaban luchando juntas."],
  ];
  const glossary = [
    ["Runaterra", "El mundo donde pasa todo. Piltover y Zaun son solo una esquina; Noxus, Demacia o Ionia quedan lejos, pero existen."],
    ["Químbarones", "Los jefes de Zaun que controlan fábricas, calles y negocios. Casi todos trabajan para Silco, como Finn."],
    ["Ejecutores", "La policía de Piltover. Arriba protegen; abajo, en Zaun, se les teme. Su sheriff en la T1 es Marcus."],
    ["Luciérnagas", "La banda de Ekko: chavales con máscaras y aerotablas que sabotean a Silco y viven en el Árbol."],
    ["Hexcore", "La investigación de Viktor que mezcla hextech y algo vivo. Funciona demasiado bien."],
    ["Día del Progreso", "La gran fiesta de Piltover: discursos, premios e inventos presentados en público."],
    ["Yordle", "Una raza de seres pequeños y longevos. Heimerdinger es uno de ellos."],
    ["Las familias", "Kiramman, Medarda, Talis… En Piltover el apellido abre o cierra puertas."],
  ];
  return (
    <>
      <PageHero
        title="El universo de Arcane"
        text="Piltover arriba, Zaun abajo y un puente en medio. Esto es lo básico para entender la historia del juego."
      />
      <section className="editorial-lead section-pad">
        <div>
          <h2>Dos ciudades que se necesitan y no se soportan.</h2>
        </div>
        <div className="prose">
          <p>
            Piltover está sobre los acantilados, junto a un canal por el que pasan los barcos de
            medio continente. Cobra por cada uno que cruza, y eso la ha hecho rica. Su gente cree
            que el ingenio lo arregla todo.
          </p>
          <p>
            Debajo está Zaun, la ciudad subterránea. Cuanto más bajas, menos luz y más humo. Arriba
            la miran por encima del hombro, pero sus fábricas, su gente y su química hacen falta
            para que Piltover funcione.
          </p>
          <p>
            Todo lo que pasa en Arcane sale de esa tensión. Aquí tienes lo esencial; el resto está
            en el Códice del juego.
          </p>
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
      <section className="section-pad glossary">
        <h2>Palabras que vas a oír</h2>
        <dl>
          {glossary.map(([word, meaning]) => (
            <div key={word}>
              <dt>{word}</dt>
              <dd>{meaning}</dd>
            </div>
          ))}
        </dl>
      </section>
      <section className="timeline section-pad">
        <h2>Cronología</h2>
        <ol>
          {timeline.map(([when, what]) => (
            <li key={what}>
              <span>{when}</span>
              <p>{what}</p>
            </li>
          ))}
        </ol>
      </section>
      <section className="comparison section-pad">
        <div className="comparison-column piltover-copy">
          <h2>Piltover</h2>
          <p>
            Torres art déco, cúpulas doradas y dirigibles. Mandan el Consejo y los apellidos:
            Kiramman, Medarda, Talis. Estudiar en la Academia es el mayor orgullo y los ejecutores
            vigilan que nadie de abajo suba sin permiso.
          </p>
          <Link to="/ciudades#piltover" className="text-link">
            Ver Piltover
          </Link>
        </div>
        <div className="comparison-line" />
        <div className="comparison-column zaun-copy">
          <h2>Zaun</h2>
          <p>
            Tuberías, neón y humo. Casi nadie tiene padres, pero todo el mundo tiene a alguien que
            lo recogió. Mandan los químbarones de Silco, se pelea en los fosos de los bares y se
            pinta en las paredes para decir «aquí estoy».
          </p>
          <Link to="/ciudades#zaun" className="text-link">
            Ver Zaun
          </Link>
        </div>
      </section>
    </>
  );
}

const cityImages: Record<
  "Piltover" | "Zaun",
  { hero: string; gallery: { src: string; title: string; text: string }[] }
> = {
  Piltover: {
    hero: "/assets/img/ciudades/piltover/panorama-t1.webp",
    gallery: [
      {
        src: "/assets/img/ciudades/piltover/panorama-t2.webp",
        title: "Piltover en la T2",
        text: "La misma ciudad, con luz fría, estandartes noxianos y ejecutores armados.",
      },
      {
        src: "/assets/img/ciudades/piltover/artesanos-t1.webp",
        title: "El barrio de los artesanos",
        text: "Relojeros, talleres y fundiciones: el Piltover que trabaja con las manos.",
      },
      {
        src: "/assets/img/ciudades/piltover/hexpuertas-t2.webp",
        title: "Las Hexpuertas",
        text: "Los barcos cruzan el canal de golpe. De aquí sale la riqueza de la ciudad.",
      },
    ],
  },
  Zaun: {
    hero: "/assets/img/ciudades/zaun/ciudad-subterranea.jpg",
    gallery: [
      {
        src: "/assets/img/ciudades/zaun/centro.jpg",
        title: "El centro de Zaun",
        text: "Pasarelas, carteles de neón y vecinos que se conocen de toda la vida.",
      },
      {
        src: "/assets/img/ciudades/zaun/muelles.jpg",
        title: "Los muelles",
        text: "Contrabando, barcas y mercancía que nunca pasa por la aduana de arriba.",
      },
      {
        src: "/assets/img/ciudades/zaun/comuna-viktor.jpg",
        title: "La comuna de Viktor",
        text: "En la T2, el sitio al que va la gente de Zaun a que la curen.",
      },
    ],
  },
};

function CitySection({
  city,
  title,
  description,
  points,
}: {
  city: "Piltover" | "Zaun";
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
        <h2>{title}</h2>
        <p>{description}</p>
        <ul className="city-points">
          {points.map((point) => (
            <li key={point}>{point}</li>
          ))}
        </ul>
        <Link to={`/atlas?ciudad=${city.toLowerCase()}`} className="button secondary">
          Ver en el atlas
        </Link>
      </div>
      <div className="mini-gallery">
        {images.gallery.map((item, index) => (
          <figure key={item.src} className="gallery-entry">
            <Media src={item.src} alt={item.title} />
            <figcaption>
              <span>0{index + 1}</span>
              <div>
                <strong>{item.title}</strong>
                <p>{item.text}</p>
              </div>
            </figcaption>
          </figure>
        ))}
      </div>
      <div className="city-places">
        <Eyebrow>Lugares</Eyebrow>
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

const cityBlocks: Record<"Piltover" | "Zaun", { title: string; text: string }[]> = {
  Piltover: [
    { title: "Historia", text: "Nació como puerto sobre los acantilados, junto a un canal que corta el continente. Cobrar por cada barco que pasa la hizo rica, y la riqueza atrajo a inventores y familias de todo Runaterra. Lo que quedó debajo, los barrios de los trabajadores, acabó siendo Zaun." },
    { title: "Quién manda", text: "El Consejo: las grandes familias y figuras como Heimerdinger, sentadas en una mesa redonda. Votan leyes, impuestos y quién puede patentar qué. Los ejecutores hacen cumplir sus decisiones." },
    { title: "Su gente", text: "Creen que el ingenio lo arregla todo. Estudiar en la Academia es el mayor honor y el apellido pesa más que el dinero. Muchos miran a los de abajo como un problema que no quieren ver." },
    { title: "Barrios", text: "El barrio académico, el Distrito del Consejo con su cúpula dorada, las terrazas de las grandes familias, el barrio de los artesanos y los muelles de las Hexpuertas. Todo acaba en el Puente." },
    { title: "Tecnología", text: "La hextech: runas y cristales mágicos. Mueve las Hexpuertas, el martillo de Jayce y el rifle de Caitlyn. Heimerdinger avisa de que es peligrosa y nadie le hace caso." },
    { title: "T1 y T2", text: "En la T1 es un atardecer dorado de torres, dirigibles y vidrieras. En la T2 la luz se enfría: ejecutores armados, estandartes rojos de Noxus y una ciudad que se prepara para la guerra." },
  ],
  Zaun: [
    { title: "Historia", text: "Era la parte baja de la misma ciudad hasta que Piltover se separó y la dejó a la sombra. Años antes de la serie, Vander y Silco intentaron cruzar el Puente para reclamar lo suyo y perdieron. Desde entonces hay tregua." },
    { title: "Quién manda", text: "Nadie y todos. Vander mantiene la paz en los Callejones; Silco y sus químbarones controlan las fábricas y la calle. Para Silco, una Zaun independiente es un sueño que se paga con brillo." },
    { title: "Su gente", text: "Casi nadie tiene padres, pero todo el mundo tiene a alguien que lo recogió. Se pelea en los fosos de los bares, se pinta en las paredes y se desconfía de cualquiera que venga de arriba." },
    { title: "Niveles", text: "La Promenade, la más cercana al Puente, con La Última Gota y el mercado. El Entresuelo, de fábricas y puentes colgantes. Y el Sumidero, donde la niebla química no deja ver el sol. Los une un ascensor." },
    { title: "Tecnología", text: "Quimtec: química, vapor y chatarra. Filtros contra el humo, prótesis como el brazo de Sevika, las bombas de Jinx y las aerotablas de las Luciérnagas. Y el brillo, que da fuerza y destroza a quien lo toma." },
    { title: "T1 y T2", text: "En la T1, humo verde, neón y tuberías. En la T2 las paredes se llenan de los graffiti de Jinx, el púrpura del brillo está por todas partes y la ciudad se levanta contra Piltover." },
  ],
};

function CityBlocks({ city }: { city: "Piltover" | "Zaun" }) {
  return (
    <section className={`topic-grid section-pad city-blocks ${city.toLowerCase()}`}>
      {cityBlocks[city].map((block) => (
        <article className="topic-card" key={block.title}>
          <h3>{block.title}</h3>
          <p>{block.text}</p>
        </article>
      ))}
    </section>
  );
}

export function CitiesPage() {
  return (
    <>
      <PageHero
        title="Ciudades"
        text="Cómo son Piltover y Zaun, quién manda en cada una y cómo cambian de la T1 a la T2."
      />
      <nav className="local-nav" aria-label="Ciudades">
        <a href="#piltover">Piltover</a>
        <a href="#zaun">Zaun</a>
      </nav>
      <CitySection
        city="Piltover"
        title="Piltover, la Ciudad del Progreso"
        description="En la T1 es un atardecer dorado: torres escalonadas, cúpulas de oro, vidrieras y engranajes de latón. En la T2 la luz se enfría, la hextech se convierte en arma y los soldados de Noxus pasean por sus calles."
        points={[
          "Gobierna el Consejo de las grandes familias",
          "Los ejecutores guardan la ley y la frontera",
          "Se hace rica con las Hexpuertas y el comercio",
        ]}
      />
      <CityBlocks city="Piltover" />
      <CitySection
        city="Zaun"
        title="Zaun, la ciudad de abajo"
        description="Hecha de capas: la Promenade, la más cercana a Piltover; el Entresuelo, de fábricas y puentes colgantes; y el Sumidero, donde no llega el sol. En la T2 las paredes se llenan de los graffiti de Jinx y el púrpura del brillo."
        points={[
          "Tres niveles unidos por ascensores",
          "Mandan los químbarones de Silco",
          "Funciona con quimtec… y con brillo",
        ]}
      />
      <CityBlocks city="Zaun" />
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
        title="Personajes"
        text="Los 16 personajes que te encontrarás en el juego. Pulsa en uno para ver su ficha."
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
          <p>{visible.length} personajes</p>
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
              <h2>{selected.name}</h2>
              <span className="record-role">{selected.role}</span>
              <dl className="record-facts">
                <div>
                  <dt>Ciudad</dt>
                  <dd>{selected.city}</dd>
                </div>
                <div>
                  <dt>Temporadas</dt>
                  <dd>{selected.seasons}</dd>
                </div>
                <div>
                  <dt>En el juego</dt>
                  <dd>{selected.where}</dd>
                </div>
                <div>
                  <dt>Vínculos</dt>
                  <dd>{selected.ties}</dd>
                </div>
              </dl>
              {selected.bio.map((paragraph) => (
                <p key={paragraph}>{paragraph}</p>
              ))}
              <CodiceNote />
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
        title="Lugares"
        text="Los sitios de Piltover y Zaun que salen en la serie y en el juego, con su historia completa."
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
            <span>Tipo</span>
            <select value={category} onChange={(event) => setCategory(event.target.value)}>
              {categories.map((item) => (
                <option key={item}>{item}</option>
              ))}
            </select>
          </label>
        </div>
        <p className="result-count">{visible.length} lugares</p>
        <div className="place-grid">
          {visible.map((place) => (
            <article className="place-card" key={place.name}>
              <Media src={place.image} alt={place.name} />
              <div>
                <span className={`city-tag ${place.city.toLowerCase()}`}>{place.city}</span>
                <small>{place.zone}</small>
                <h2>{place.name}</h2>
                <p>{place.bio[0]}</p>
                <button className="text-link" onClick={() => setSelected(place)}>
                  Ver ficha
                </button>
              </div>
            </article>
          ))}
        </div>
        {visible.length === 0 && (
          <div className="empty-state">
            <h2>No hay ningún lugar con esos filtros.</h2>
            <button
              onClick={() => {
                setCity("Todas");
                setCategory("Todas");
                setQuery("");
              }}
            >
              Quitar filtros
            </button>
          </div>
        )}
      </section>
      <Dialog open={!!selected} onClose={() => setSelected(null)} title={selected?.name ?? ""}>
        {selected && (
          <div className="place-detail">
            <Media src={selected.image} alt={selected.name} />
            <h2>{selected.name}</h2>
            <dl className="record-facts">
              <div>
                <dt>Ciudad</dt>
                <dd>
                  {selected.city} · {selected.zone}
                </dd>
              </div>
              <div>
                <dt>Tipo</dt>
                <dd>{selected.category}</dd>
              </div>
              <div>
                <dt>Temporadas</dt>
                <dd>{selected.seasons}</dd>
              </div>
              <div>
                <dt>Quién suele estar</dt>
                <dd>{selected.who}</dd>
              </div>
              <div>
                <dt>En el juego</dt>
                <dd>{selected.inGame}</dd>
              </div>
            </dl>
            {selected.bio.map((paragraph) => (
              <p key={paragraph}>{paragraph}</p>
            ))}
          </div>
        )}
      </Dialog>
    </>
  );
}

export function AtlasPage() {
  const stops = places.filter((place) => place.stop);
  const [selected, setSelected] = useState<Place>(stops[0]);
  const [zoom, setZoom] = useState(1);
  const scroller = useRef<HTMLDivElement>(null);
  const drag = useRef<{ x: number; y: number; left: number; top: number } | null>(null);

  // Cambia el zoom manteniendo centrado lo que se está mirando.
  function changeZoom(next: number) {
    const box = scroller.current;
    const value = Math.min(3, Math.max(1, Math.round(next * 100) / 100));
    if (!box) {
      setZoom(value);
      return;
    }
    const cx = (box.scrollLeft + box.clientWidth / 2) / box.scrollWidth;
    const cy = (box.scrollTop + box.clientHeight / 2) / box.scrollHeight;
    setZoom(value);
    requestAnimationFrame(() => {
      box.scrollLeft = cx * box.scrollWidth - box.clientWidth / 2;
      box.scrollTop = cy * box.scrollHeight - box.clientHeight / 2;
    });
  }

  return (
    <>
      <PageHero
        title="Atlas"
        text="El mapa 3D del juego tal como se ve en Godot. Amplía, arrastra y pulsa un punto para ver qué hay allí."
      />
      <section className="atlas section-pad">
        <div className="atlas-notice">
          <p>
            <strong>Cómo se lee:</strong> Piltover va en una línea arriba, de las Hexpuertas al
            Puente. Desde el Puente se baja a Zaun, que tiene tres niveles unidos por un ascensor:
            Promenade, Entresuelo y Sumidero.
          </p>
        </div>
        <div className="atlas-layout">
          <div className="map-stage">
            <div
              className={`map-scroll ${zoom > 1 ? "can-drag" : ""}`}
              ref={scroller}
              onPointerDown={(event) => {
                const box = scroller.current;
                if (!box || zoom === 1 || (event.target as HTMLElement).closest("button")) return;
                drag.current = {
                  x: event.clientX,
                  y: event.clientY,
                  left: box.scrollLeft,
                  top: box.scrollTop,
                };
                box.setPointerCapture(event.pointerId);
              }}
              onPointerMove={(event) => {
                const box = scroller.current;
                if (!box || !drag.current) return;
                box.scrollLeft = drag.current.left - (event.clientX - drag.current.x);
                box.scrollTop = drag.current.top - (event.clientY - drag.current.y);
              }}
              onPointerUp={() => {
                drag.current = null;
              }}
              onPointerCancel={() => {
                drag.current = null;
              }}
            >
              <div className="map-canvas" style={{ width: `${zoom * 100}%` }}>
                <img
                  className="map-render"
                  src="/assets/img/atlas/mapa-3d.webp"
                  alt="Mapa 3D del juego: Piltover arriba en línea y Zaun abajo en tres niveles"
                  draggable={false}
                />
                {stops.map((place, index) => (
                  <button
                    key={place.name}
                    className={`map-marker ${place.city.toLowerCase()} ${selected.name === place.name ? "active" : ""}`}
                    style={{ left: `${place.stop!.x}%`, top: `${place.stop!.y}%` }}
                    onClick={() => setSelected(place)}
                    aria-label={`Ver ${place.name}`}
                  >
                    <span>{index + 1}</span>
                  </button>
                ))}
              </div>
            </div>
            <div className="zoom-controls">
              <button onClick={() => changeZoom(zoom + 0.5)} aria-label="Ampliar mapa" disabled={zoom >= 3}>
                <ZoomIn />
              </button>
              <button onClick={() => changeZoom(zoom - 0.5)} aria-label="Reducir mapa" disabled={zoom <= 1}>
                <ZoomOut />
              </button>
              <span className="zoom-value">{Math.round(zoom * 100)}%</span>
            </div>
          </div>
          <aside className={`atlas-panel ${selected.city.toLowerCase()}`}>
            <span className="map-index">{String(stops.indexOf(selected) + 1).padStart(2, "0")}</span>
            <h2>{selected.name}</h2>
            <small>
              {selected.city} · {selected.zone}
            </small>
            <p>{selected.bio[0]}</p>
            <p>
              <strong>Quién suele estar:</strong> {selected.who}
            </p>
            <p>
              <strong>En el juego:</strong> {selected.inGame}
            </p>
            <Link to="/lugares" className="text-link">
              Ver todos los lugares
            </Link>
          </aside>
        </div>
      </section>
    </>
  );
}

export function GamePage() {
  const features = [
    [
      "Creas a tu personaje",
      "Siete apartados: ciudad, familia, barrio, oficio, rasgos, aficiones y cuatro estadísticas (Ingenio, Carisma, Valor y Sigilo). Puedes ser prima de Vi, hermano de Jayce o hija de Silco.",
    ],
    [
      "Te mueves por un mapa 3D",
      "Piltover va en línea, de parada en parada. Desde el Puente bajas a Zaun y cambias de nivel en ascensor. Al empezar y al cargar partida apareces siempre en el Puente.",
    ],
    [
      "Hablas por chat",
      "Cada personaje escribe con su propia voz: Jinx a ráfagas, Silco con pausas largas, Heimerdinger con mensajes eternos. En cada mensaje tienes entre 5 y 9 respuestas.",
    ],
    [
      "Las relaciones cambian",
      "Confianza, amistad, afecto y rivalidad. Puedes pasar de desconocido a confidente, a pareja… o a rival y a guerra. Tu ciudad y tu familia deciden cómo te tratan al principio.",
    ],
    [
      "Una historia larga",
      "30 capítulos en dos partes, una por temporada, y 8 finales distintos según lo que hagas y con quién te lleves bien.",
    ],
    [
      "Un Códice siempre abierto",
      "Un libro con tu propia historia, los personajes, Piltover, Zaun, la tecnología, la cultura y la cronología. Está completo desde el principio: no hay que desbloquear nada.",
    ],
  ];
  const minigames = {
    Piltover: ["Calibrar el cristal", "Tiro de precisión", "Debate del Consejo", "El archivo", "Baile de gala"],
    Zaun: ["El foso", "Carrera de aerotabla", "Graffiti", "Mezclas de quimtec", "Cartas en La Última Gota"],
  };
  const done = [
    "Menú de inicio",
    "Nueva partida y elegir ciudad",
    "Creación de personaje",
    "Ajustes",
    "Cargar partida (diseño)",
    "Códice",
    "Mapa 3D de las dos ciudades",
  ];
  const pending = [
    "Prólogo en vídeo",
    "Pantalla de cada lugar",
    "Chats y relaciones",
    "Misiones y capítulos",
    "Menú de pausa y guardado",
    "Los 10 minijuegos",
  ];
  return (
    <>
      <section className="game-hero">
        <div className="game-hero-copy">
          <h1>Rifts & Gears, el videojuego</h1>
          <p>
            Un fangame narrativo para un jugador que estoy haciendo en Godot 4 como TFG. Creas a tu
            personaje, eliges Piltover o Zaun y vives la historia de las dos temporadas de Arcane
            desde dentro. Lo que eliges al crearlo decide cómo te habla y cómo te trata cada
            personaje.
          </p>
          <span className="development-badge">En desarrollo</span>
        </div>
        <Media
          src="/assets/img/capturas/creacion-personaje.webp"
          alt="Pantalla de creación de personaje del videojuego"
        />
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
      <section className="game-lists section-pad">
        <div>
          <h2>Minijuegos</h2>
          <p>
            Cinco por ciudad. Se juegan desde la pausa y solo entran en la historia cuando una
            misión los pide.
          </p>
          <div className="list-columns">
            {(Object.keys(minigames) as (keyof typeof minigames)[]).map((cityName) => (
              <div key={cityName} className={cityName.toLowerCase()}>
                <h3>{cityName}</h3>
                <ul>
                  {minigames[cityName].map((game) => (
                    <li key={game}>{game}</li>
                  ))}
                </ul>
              </div>
            ))}
          </div>
        </div>
        <div>
          <h2>Cómo va</h2>
          <p>Lo que ya funciona en Godot y lo que me queda por hacer.</p>
          <div className="list-columns">
            <div>
              <h3>Hecho</h3>
              <ul>
                {done.map((item) => (
                  <li key={item}>{item}</li>
                ))}
              </ul>
            </div>
            <div>
              <h3>Falta</h3>
              <ul>
                {pending.map((item) => (
                  <li key={item}>{item}</li>
                ))}
              </ul>
            </div>
          </div>
        </div>
      </section>
      <section className="game-shots section-pad">
        <div className="section-heading">
          <h2>Capturas</h2>
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
          <h2>Todavía no se puede descargar.</h2>
          <p>
            Cuando haya una versión jugable la pondré aquí. Mientras tanto, el código está en
            GitHub.
          </p>
        </div>
        <a href={GITHUB} className="button secondary">
          Ver en GitHub
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
        title="Contacto"
        text="¿Has visto un dato mal, una imagen que no carga o tienes una idea para el juego? Cuéntamelo."
      />
      <section className="contact-layout section-pad">
        <aside>
          <h2>Cómo me llega</h2>
          <p>
            Todo lo de la web y del juego lo llevo en GitHub, así que es ahí donde leo los
            mensajes. Si algo no cuadra con Arcane, dime en qué capítulo sale y lo corrijo.
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
