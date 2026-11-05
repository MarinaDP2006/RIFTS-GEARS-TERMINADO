// Datos del portal: personajes y lugares con sus imágenes reales (public/assets/img/...).
export type City = "Piltover" | "Zaun" | "Noxus";

export type Character = {
  name: string;
  city: City;
  role: string;
  summary: string;
  image: string;
};

export type Place = {
  name: string;
  city: Exclude<City, "Noxus">;
  category: "Institución" | "Distrito" | "Comercio" | "Infraestructura" | "Refugio";
  zone: string;
  summary: string;
  image: string;
};

const P = "/assets/img/personajes/";
const PIL = "/assets/img/ciudades/piltover/";
const ZA = "/assets/img/ciudades/zaun/";

export const characters: Character[] = [
  { name: "Vi", city: "Zaun", role: "Luchadora", summary: "Puños de acero y una lealtad que no sabe rendirse.", image: P + "vi.webp" },
  { name: "Jinx", city: "Zaun", role: "Inventora", summary: "Un genio de los explosivos y un mundo que no deja de hacer ruido.", image: P + "jinx.webp" },
  { name: "Ekko", city: "Zaun", role: "Luciérnagas", summary: "Ingenio, comunidad y aerotablas para un futuro que aún vale defender.", image: P + "ekko.webp" },
  { name: "Vander", city: "Zaun", role: "Tabernero", summary: "El viejo león de La Última Gota: familia por encima de todo.", image: P + "vander.webp" },
  { name: "Sevika", city: "Zaun", role: "Lugarteniente", summary: "Brazo mecánico, pragmatismo y una lealtad forjada a golpes.", image: P + "sevika.webp" },
  { name: "Silco", city: "Zaun", role: "El barón del brillo", summary: "Antiguo hermano de armas de Vander que sueña con un Zaun libre.", image: P + "silco.webp" },
  { name: "Viktor", city: "Zaun", role: "Científico", summary: "Una mente brillante decidida a superar los límites del dolor.", image: P + "viktor.webp" },
  { name: "Isha", city: "Zaun", role: "Niña de Zaun", summary: "Una niña de gestos y travesuras que devuelve algo de Powder a Jinx.", image: P + "isha.webp" },
  { name: "Caitlyn", city: "Piltover", role: "Ejecutora", summary: "Detective obstinada y tiradora excepcional; sigue las pruebas hasta el fondo.", image: P + "caitlyn.webp" },
  { name: "Jayce", city: "Piltover", role: "Inventor", summary: "El hombre del progreso: idealismo, ambición y un martillo hextec.", image: P + "jayce.webp" },
  { name: "Heimerdinger", city: "Piltover", role: "Decano", summary: "Yordle centenario, prudente hasta el exceso y memoria viva de la ciudad.", image: P + "heimerdinger.webp" },
  { name: "Mel Medarda", city: "Piltover", role: "Consejera", summary: "Elegante, calculadora y más compasiva de lo que deja ver.", image: P + "mel.webp" },
  { name: "Cassandra", city: "Piltover", role: "Consejera", summary: "Madre de Caitlyn y voz firme de una de las familias de la ciudad.", image: P + "cassandra.webp" },
  { name: "Maddie", city: "Piltover", role: "Ejecutora", summary: "Eficiente, cercana y siempre con una taza de té a mano.", image: P + "maddie.webp" },
  { name: "Ambessa", city: "Noxus", role: "Señora de la guerra", summary: "La loba de Noxus: la hextec como arma y la familia como debilidad.", image: P + "ambessa.webp" },
  { name: "Kino", city: "Noxus", role: "Hijo de Ambessa", summary: "Hijo de Ambessa y hermano de Mel: prefería las palabras a las espadas.", image: P + "kino.webp" },
];

export const places: Place[] = [
  { name: "La Academia", city: "Piltover", category: "Institución", zone: "Barrio académico", summary: "Centro de investigación y formación de la Ciudad del Progreso, cuna de la hextech.", image: PIL + "academia-fachada.webp" },
  { name: "La Sala del Consejo", city: "Piltover", category: "Institución", zone: "Distrito del Consejo", summary: "Sede del poder político, donde se toman las grandes decisiones de Piltover.", image: PIL + "consejo-t2.webp" },
  { name: "La Mansión Kiramman", city: "Piltover", category: "Distrito", zone: "Terrazas Kiramman", summary: "Hogar de una de las familias más influyentes de la ciudad.", image: PIL + "mansion-kiramman-t2.webp" },
  { name: "Las Hexpuertas", city: "Piltover", category: "Infraestructura", zone: "Muelles", summary: "Puertas hextech que conectan Piltover con el resto de Runaterra.", image: PIL + "hexpuertas-t1.webp" },
  { name: "El Taller de Jayce", city: "Piltover", category: "Comercio", zone: "Barrio académico", summary: "Un taller lleno de planos, prototipos y el primer brillo de la hextech.", image: PIL + "taller-jayce-t1.webp" },
  { name: "La Plaza del Progreso", city: "Piltover", category: "Distrito", zone: "Centro cívico", summary: "El corazón público de la ciudad, entre estatuas, comercio y celebraciones.", image: PIL + "plaza-t1.webp" },
  { name: "El Puente del Progreso", city: "Piltover", category: "Infraestructura", zone: "Entre Piltover y Zaun", summary: "La conexión entre las dos ciudades. En el juego, siempre apareces aquí.", image: PIL + "puente-progreso-t1.webp" },
  { name: "La Última Gota", city: "Zaun", category: "Comercio", zone: "Los callejones", summary: "La taberna de Vander, refugio y punto de encuentro de los bajos fondos.", image: ZA + "ultima-gota-bar.jpg" },
  { name: "El Mercado Vertical", city: "Zaun", category: "Comercio", zone: "Mercado de las tuberías", summary: "Puestos colgados entre niveles donde se compra, se vende y se negocia todo.", image: ZA + "mercado.png" },
  { name: "Los Callejones", city: "Zaun", category: "Distrito", zone: "Fisuras superiores", summary: "Calles, pasarelas y neón químico atravesados por la vida diaria de Zaun.", image: ZA + "fisuras-superiores.jpg" },
  { name: "El laboratorio de Singed", city: "Zaun", category: "Institución", zone: "Laboratorio", summary: "Instrumental, experimentos y la cara más inquietante de la química de Zaun.", image: ZA + "singed-laboratorio.png" },
  { name: "El Árbol", city: "Zaun", category: "Refugio", zone: "Refugio de las Luciérnagas", summary: "El hogar escondido de Ekko y las Luciérnagas, verde en medio del humo.", image: ZA + "arbol-fireflight.jpg" },
  { name: "El Escondite de Jinx", city: "Zaun", category: "Refugio", zone: "El Sumidero", summary: "Un taller caótico de inventos, recuerdos y explosivos.", image: ZA + "escondite-jinx.jpg" },
  { name: "El Sumidero", city: "Zaun", category: "Distrito", zone: "El nivel más bajo", summary: "El fondo de Zaun, donde la ciudad sobrevive lejos de cualquier mirada.", image: ZA + "punto-seguridad.jpg" },
];

// Capturas reales del juego (Godot).
export const screenshots = [
  { src: "/assets/img/capturas/inicio.webp", label: "Menú de inicio" },
  { src: "/assets/img/capturas/nueva-partida.webp", label: "Nueva partida" },
  { src: "/assets/img/capturas/creacion-personaje.webp", label: "Creación de personaje" },
  { src: "/assets/img/capturas/ajustes.webp", label: "Ajustes" },
  { src: "/assets/img/capturas/codice.webp", label: "Códice" },
  { src: "/assets/img/capturas/cargar-partida.webp", label: "Cargar partida" },
  { src: "/assets/img/capturas/mapa-3d-puente.webp", label: "Mapa 3D · el Puente" },
];

export const GITHUB = "https://github.com/MarinaDP2006/RIFTS-GEARS";
