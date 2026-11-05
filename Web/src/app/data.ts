// Datos del portal: personajes y lugares con sus imágenes (public/assets/img/...).
// Las fichas son un resumen: la versión completa de cada una está en el Códice del juego.
export type City = "Piltover" | "Zaun" | "Noxus";

export type Character = {
  name: string;
  city: City;
  role: string;
  seasons: string;
  where: string;
  ties: string;
  bio: string[];
  image: string;
};

export type Place = {
  name: string;
  city: Exclude<City, "Noxus">;
  category: "Institución" | "Distrito" | "Comercio" | "Infraestructura" | "Refugio" | "Taller";
  zone: string;
  seasons: string;
  who: string;
  bio: string[];
  image: string;
};

const P = "/assets/img/personajes/";
const PIL = "/assets/img/ciudades/piltover/";
const ZA = "/assets/img/ciudades/zaun/";

export const characters: Character[] = [
  {
    name: "Vi",
    city: "Zaun",
    role: "Luchadora",
    seasons: "T1 · T2",
    where: "La Última Gota; en la T2, al lado de Caitlyn",
    ties: "Hermana mayor de Powder. Criada por Vander. Caitlyn.",
    bio: [
      "Se crio en los Callejones con Vander, su hermana Powder, Mylo y Claggor. Pega primero y piensa después, pero casi siempre pega para proteger a alguien.",
      "La noche en que lo pierde todo, Silco se queda con Powder y a Vi la encierran años en Stillwater. Cuando sale, solo tiene una cosa en la cabeza: encontrar a su hermana. La que encuentra ya no se llama Powder.",
    ],
    image: P + "vi.webp",
  },
  {
    name: "Jinx",
    city: "Zaun",
    role: "Inventora",
    seasons: "T1 · T2",
    where: "Su escondite, en el Sumidero",
    ties: "Antes Powder. Hermana de Vi. Silco la crio. Isha.",
    bio: [
      "De niña era Powder: la pequeña del grupo, la que fabricaba cacharros que casi nunca funcionaban y quería que la dejaran ir con los mayores. Una noche, uno de sus inventos funcionó demasiado bien.",
      "Silco la recogió y la hizo suya. Creció entre voces, pólvora y graffiti rosa y azul, y acabó convertida en lo que Piltover más teme de Zaun.",
    ],
    image: P + "jinx.webp",
  },
  {
    name: "Ekko",
    city: "Zaun",
    role: "Líder de las Luciérnagas",
    seasons: "T1 · T2",
    where: "El Árbol, en el Entresuelo",
    ties: "Amigo de infancia de Powder. Benzo fue su mentor.",
    bio: [
      "De pequeño iba detrás de Vi y Powder por los tejados. De mayor lidera a las Luciérnagas, un grupo de chavales que plantan cara a Silco con máscaras, aerotablas y mucho ingenio.",
      "Su refugio es un árbol enorme escondido en el subsuelo, uno de los pocos sitios verdes de Zaun. En la T2 su invento más raro le enseña cómo podrían haber sido las cosas.",
    ],
    image: P + "ekko.webp",
  },
  {
    name: "Vander",
    city: "Zaun",
    role: "Dueño de La Última Gota",
    seasons: "T1 · T2",
    where: "La Última Gota, en la Promenade",
    ties: "Padre adoptivo de Vi y Powder. Antiguo amigo de Silco.",
    bio: [
      "Encabezó la revuelta del Puente y vio morir a demasiada gente. Desde entonces mantiene una tregua con los ejecutores para que no vuelva a pasar, aunque en los Callejones no todos se lo perdonan.",
      "Adoptó a Vi y a Powder después de aquella revuelta. Detrás de la barra es el que pone paz; si tiene que pelear, no hace falta un segundo asalto.",
    ],
    image: P + "vander.webp",
  },
  {
    name: "Sevika",
    city: "Zaun",
    role: "Mano derecha de Silco",
    seasons: "T1 · T2",
    where: "Las fábricas del Entresuelo",
    ties: "Trabaja para Silco. Poco cariño por Jinx.",
    bio: [
      "Hace el trabajo sucio de Silco sin preguntar. Juega a las cartas, bebe fuerte y no se queja nunca, ni siquiera cuando pierde el brazo y lo cambia por uno mecánico.",
      "En la T2, sin Silco, le toca decidir qué es Zaun y quién habla por ella.",
    ],
    image: P + "sevika.webp",
  },
  {
    name: "Silco",
    city: "Zaun",
    role: "Químbarón",
    seasons: "T1",
    where: "Las fábricas del Entresuelo",
    ties: "Antiguo hermano de Vander. Padre adoptivo de Jinx. Singed.",
    bio: [
      "Fue el mejor amigo de Vander hasta que dejaron de pensar igual sobre Piltover. La cicatriz del ojo es un recuerdo de ese día.",
      "Controla las fábricas y la calle, y paga su sueño de una Zaun independiente con el brillo. Es frío con todo el mundo menos con Jinx, la única que puede hacerle dudar.",
    ],
    image: P + "silco.webp",
  },
  {
    name: "Viktor",
    city: "Zaun",
    role: "Científico",
    seasons: "T1 · T2",
    where: "El taller de Jayce; en la T2, su comuna en Zaun",
    ties: "Socio de Jayce. Ayudante de Heimerdinger. Sky.",
    bio: [
      "Nació abajo, enfermo y con una cojera, y llegó a la Academia de Piltover solo por talento. Con Jayce consigue que la hextech funcione de verdad.",
      "Su cuerpo se apaga más rápido que su paciencia, y eso le lleva al Hexcore. En la T2 cura a la gente de Zaun… a un precio que nadie le ha pedido.",
    ],
    image: P + "viktor.webp",
  },
  {
    name: "Isha",
    city: "Zaun",
    role: "Niña de Zaun",
    seasons: "T2",
    where: "Siempre detrás de Jinx",
    ties: "Jinx la adopta sin decirlo en voz alta.",
    bio: [
      "Una cría de Zaun que no habla: se explica con gestos, muecas y tirones de manga. Se pega a Jinx y no hay manera de despegarla.",
      "Con ella, Jinx se descubre haciendo de hermana mayor, lo que Vi fue para Powder. Pocas historias de la T2 duelen tanto como la suya.",
    ],
    image: P + "isha.webp",
  },
  {
    name: "Caitlyn",
    city: "Piltover",
    role: "Ejecutora",
    seasons: "T1 · T2",
    where: "La Mansión Kiramman; en la T2, al mando de los ejecutores",
    ties: "Hija de Cassandra y Tobias Kiramman. Vi.",
    bio: [
      "Podría vivir de su apellido, pero eligió ser ejecutora. Tiene la mejor puntería de Piltover y una manía: seguir las pruebas aunque lleven a sitios donde nadie quiere mirar.",
      "Eso la lleva a bajar a Zaun con Vi. En la T2 la pérdida la endurece y Piltover le pone un rifle en las manos y una guerra delante.",
    ],
    image: P + "caitlyn.webp",
  },
  {
    name: "Jayce",
    city: "Piltover",
    role: "Inventor",
    seasons: "T1 · T2",
    where: "Su taller, cerca de la Academia",
    ties: "Socio de Viktor. Mel. Heimerdinger fue su decano.",
    bio: [
      "De niño, una maga le salvó la vida y desde entonces quiere que la magia sea para todo el mundo. Casi lo expulsan de la Academia por intentarlo.",
      "Con Viktor crea la hextech, y con Mel aprende a moverse en el Consejo. Cuanto más poder tiene, más difícil le resulta decir que no.",
    ],
    image: P + "jayce.webp",
  },
  {
    name: "Heimerdinger",
    city: "Piltover",
    role: "Decano de la Academia",
    seasons: "T1 · T2",
    where: "La Academia",
    ties: "Fue mentor de Jayce y Viktor. Ekko, en la T2.",
    bio: [
      "Un yordle que lleva siglos en Piltover y ha visto nacer y caer muchas ideas brillantes. Por eso desconfía de las prisas y de la hextech.",
      "El Consejo acaba apartándolo por ser demasiado prudente. En la T2 baja a Zaun y descubre que todavía le quedan cosas por aprender.",
    ],
    image: P + "heimerdinger.webp",
  },
  {
    name: "Mel Medarda",
    city: "Piltover",
    role: "Consejera",
    seasons: "T1 · T2",
    where: "La Sala del Consejo",
    ties: "Hija de Ambessa. Hermana de Kino. Jayce.",
    bio: [
      "La consejera más lista de Piltover. Llegó de Noxus de niña, desterrada por su propia madre, y aprendió a ganar sin levantar la voz.",
      "Ve en la hextech la oportunidad de Piltover y en Jayce a la persona que puede ponerle cara. En la T2 descubre que su familia le había ocultado algo de sí misma.",
    ],
    image: P + "mel.webp",
  },
  {
    name: "Cassandra",
    city: "Piltover",
    role: "Consejera",
    seasons: "T1 · T2",
    where: "La Sala del Consejo y la Mansión Kiramman",
    ties: "Madre de Caitlyn. Esposa de Tobias.",
    bio: [
      "Cabeza de la familia Kiramman y voz firme del Consejo. No le hace ninguna gracia que su hija lleve uniforme de ejecutora.",
      "Educada, protectora y muy consciente de lo que pesa un apellido en Piltover. El ataque al Consejo cambia para siempre a su familia.",
    ],
    image: P + "cassandra.webp",
  },
  {
    name: "Maddie",
    city: "Piltover",
    role: "Ejecutora",
    seasons: "T2",
    where: "Con Caitlyn y los ejecutores",
    ties: "Compañera de Caitlyn. Ambessa.",
    bio: [
      "Ejecutora joven, simpática y siempre dispuesta a ayudar a Caitlyn en lo que haga falta.",
      "Demasiado dispuesta, quizá. Su lealtad no está exactamente donde todos creen.",
    ],
    image: P + "maddie.webp",
  },
  {
    name: "Ambessa",
    city: "Noxus",
    role: "Señora de la guerra",
    seasons: "T1 · T2",
    where: "La Sala del Consejo, en la T2",
    ties: "Madre de Mel y de Kino.",
    bio: [
      "Una general noxiana que solo respeta la fuerza. Llega a Piltover buscando hextech para sus guerras y a su hija, por ese orden o por el contrario, según el día.",
      "En la T2 entra en la política de Piltover con sus propios soldados. Quiere a su familia, pero eso no la convierte en alguien en quien confiar.",
    ],
    image: P + "ambessa.webp",
  },
  {
    name: "Kino",
    city: "Noxus",
    role: "Hijo de Ambessa",
    seasons: "T2",
    where: "En los recuerdos de Mel",
    ties: "Hermano mayor de Mel. Hijo de Ambessa.",
    bio: [
      "El hermano mayor de Mel. Ambessa lo crio para ser un guerrero noxiano y ella lo da por muerto desde hace años.",
      "En la T2 su cara vuelve a aparecer delante de Mel, pero en Noxus no todo es lo que parece.",
    ],
    image: P + "kino.webp",
  },
];

export const places: Place[] = [
  {
    name: "La Academia",
    city: "Piltover",
    category: "Institución",
    zone: "Barrio académico",
    seasons: "T1 · T2",
    who: "Heimerdinger, Jayce, Viktor",
    bio: [
      "La escuela de ciencia de Piltover. Estudiar aquí es el mayor orgullo de una familia de arriba, y casi imposible para alguien de abajo, como Viktor.",
      "Aquí nace la hextech, y aquí empieza tu historia si eliges Piltover.",
    ],
    image: PIL + "academia-fachada.webp",
  },
  {
    name: "La Sala del Consejo",
    city: "Piltover",
    category: "Institución",
    zone: "Distrito del Consejo",
    seasons: "T1 · T2",
    who: "Mel, Cassandra, Jayce, Salo, Shoola; Ambessa en la T2",
    bio: [
      "Mármol, cúpula dorada y una mesa redonda donde las grandes familias deciden el futuro de las dos ciudades. Zaun nunca ha tenido silla.",
      "Es el escenario de los votos, los pactos a escondidas y del ataque que cierra la T1.",
    ],
    image: PIL + "consejo-t2.webp",
  },
  {
    name: "La Mansión Kiramman",
    city: "Piltover",
    category: "Distrito",
    zone: "Barrio alto",
    seasons: "T1 · T2",
    who: "Caitlyn, Cassandra",
    bio: [
      "La casa de una de las familias más antiguas de Piltover: retratos, jardines y un campo de tiro donde Caitlyn practica desde niña.",
      "En la T2 la casa se queda grande y fría.",
    ],
    image: PIL + "mansion-kiramman-t2.webp",
  },
  {
    name: "Las Hexpuertas",
    city: "Piltover",
    category: "Infraestructura",
    zone: "Muelles",
    seasons: "T1 · T2",
    who: "Comerciantes de toda Runaterra",
    bio: [
      "Unas puertas de hextech que lanzan los barcos de un lado a otro del canal. Gracias a ellas Piltover pasa a ser la ciudad más rica del continente.",
      "Son el gran logro de Jayce y Viktor, y la prueba de que la hextech también puede hacer mucho daño.",
    ],
    image: PIL + "hexpuertas-t1.webp",
  },
  {
    name: "El Taller de Jayce",
    city: "Piltover",
    category: "Taller",
    zone: "Barrio académico",
    seasons: "T1 · T2",
    who: "Jayce, Viktor",
    bio: [
      "Un desván lleno de planos, cristales y prototipos a medio montar. Aquí Jayce y Viktor pasan noches enteras hasta conseguir que la hextech funcione.",
      "Con el tiempo, los inventos de este taller se van pareciendo cada vez más a armas.",
    ],
    image: PIL + "taller-jayce-t1.webp",
  },
  {
    name: "La Plaza del Progreso",
    city: "Piltover",
    category: "Distrito",
    zone: "Centro",
    seasons: "T1 · T2",
    who: "La gente de Piltover",
    bio: [
      "Estatuas, mercados y bandas de música. Aquí se celebra el Día del Progreso, cuando la ciudad presume de sus inventos.",
      "En la T2 los mismos discursos suenan mucho más a guerra.",
    ],
    image: PIL + "plaza-t1.webp",
  },
  {
    name: "El Puente del Progreso",
    city: "Piltover",
    category: "Infraestructura",
    zone: "Entre Piltover y Zaun",
    seasons: "T1 · T2",
    who: "Ejecutores de guardia",
    bio: [
      "El único paso entre las dos ciudades y la frontera más vigilada. Aquí fue la revuelta en la que Vander perdió a tanta gente.",
      "En el juego siempre apareces aquí, al empezar y al cargar partida.",
    ],
    image: PIL + "puente-progreso-t1.webp",
  },
  {
    name: "La Última Gota",
    city: "Zaun",
    category: "Comercio",
    zone: "Promenade",
    seasons: "T1 · T2",
    who: "Vander, Vi, Powder; Sevika en la T2",
    bio: [
      "El bar de Vander: casa, territorio neutral y ring de peleas, todo a la vez. Detrás de la barra hay una foto de familia y debajo del suelo, un foso.",
      "Cuando falta Vander, el bar cambia de dueño y de ambiente. Si eliges Zaun, tu historia empieza aquí.",
    ],
    image: ZA + "ultima-gota-bar.jpg",
  },
  {
    name: "El Mercado",
    city: "Zaun",
    category: "Comercio",
    zone: "Promenade",
    seasons: "T1 · T2",
    who: "Benzo, Finn",
    bio: [
      "Puestos colgados de tuberías, comida callejera y piezas de dudosa procedencia. En Zaun se compra de todo, y casi todo se regatea.",
      "Es el sitio donde mejor se oye lo que pasa en la ciudad.",
    ],
    image: ZA + "mercado.png",
  },
  {
    name: "Los Callejones",
    city: "Zaun",
    category: "Distrito",
    zone: "Promenade",
    seasons: "T1 · T2",
    who: "Vi, Ekko y medio Zaun",
    bio: [
      "Las calles que quedan justo debajo del Puente: pasarelas, neón, humo y vecinos que se conocen de toda la vida.",
      "En la T2 las paredes están llenas de los graffiti de Jinx.",
    ],
    image: ZA + "fisuras-superiores.jpg",
  },
  {
    name: "El laboratorio de Singed",
    city: "Zaun",
    category: "Taller",
    zone: "Sumidero",
    seasons: "T1 · T2",
    who: "Singed",
    bio: [
      "Frascos, jaulas y mesas de operaciones. Singed trabaja para Silco y trata a la gente como si fueran datos.",
      "De aquí sale el brillo, y también lo que hizo con Vander.",
    ],
    image: ZA + "singed-laboratorio.png",
  },
  {
    name: "El Árbol",
    city: "Zaun",
    category: "Refugio",
    zone: "Entresuelo",
    seasons: "T1 · T2",
    who: "Ekko y las Luciérnagas",
    bio: [
      "Un árbol gigante escondido en el subsuelo que brilla con luz propia. Las Luciérnagas viven en sus ramas y lo defienden de Silco.",
      "Es casi el único sitio de Zaun donde se respira bien.",
    ],
    image: ZA + "arbol-fireflight.jpg",
  },
  {
    name: "El Escondite de Jinx",
    city: "Zaun",
    category: "Refugio",
    zone: "Sumidero",
    seasons: "T1 · T2",
    who: "Jinx; Isha en la T2",
    bio: [
      "Un taller lleno de bombas, muñecos, dibujos en las paredes y recuerdos de cuando todavía se llamaba Powder.",
      "Mejor no tocar nada sin preguntar.",
    ],
    image: ZA + "escondite-jinx.jpg",
  },
  {
    name: "El Sumidero",
    city: "Zaun",
    category: "Distrito",
    zone: "El nivel más bajo",
    seasons: "T1 · T2",
    who: "Los que no tienen otro sitio",
    bio: [
      "El fondo de Zaun: niebla química, agua estancada y la gente más pobre de las dos ciudades. La luz del sol no llega.",
      "Aquí abajo, Piltover parece otro mundo.",
    ],
    image: ZA + "punto-seguridad.jpg",
  },
];

// Capturas del juego (Godot).
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
