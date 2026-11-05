// Datos del portal: personajes y lugares con sus imágenes (public/assets/img/...).
// Personajes: ficha resumida (la completa está en el Códice del juego).
// Lugares y ciudades: ficha completa.
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
  inGame: string;
  /** Parada del mapa 3D del juego (Rutas/...) y su posición en el atlas, en %. */
  stop?: { id: string; x: number; y: number };
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
    seasons: "Parte 1 · Parte 2",
    where: "La Última Gota; en la Parte 2, al lado de Caitlyn",
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
    seasons: "Parte 1 · Parte 2",
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
    seasons: "Parte 1 · Parte 2",
    where: "El Árbol, en el Entresuelo",
    ties: "Amigo de infancia de Powder. Benzo fue su mentor.",
    bio: [
      "De pequeño iba detrás de Vi y Powder por los tejados. De mayor lidera a las Luciérnagas, un grupo de chavales que plantan cara a Silco con máscaras, aerotablas y mucho ingenio.",
      "Su refugio es un árbol enorme escondido en el subsuelo, uno de los pocos sitios verdes de Zaun. En la Parte 2 su invento más raro le enseña cómo podrían haber sido las cosas.",
    ],
    image: P + "ekko.webp",
  },
  {
    name: "Vander",
    city: "Zaun",
    role: "Dueño de La Última Gota",
    seasons: "Parte 1 · Parte 2",
    where: "La Última Gota, en la Promenade",
    ties: "Padre adoptivo de Vi y Powder. Antiguo amigo de Silco.",
    bio: [
      "Encabezó la revuelta del Puente y vio morir a demasiada gente. Desde entonces mantiene una tregua con los ejecutores para que no vuelva a pasar, aunque en los Callejones no todos se lo perdonan.",
      "Adoptó a Vi y a Powder después de aquella revuelta. Detrás de la barra es el que pone paz; si tiene que pelear, no hace falta un segundo asalto.",
    ],
    image: P + "vander.webp",
  },
  {
    name: "Silco",
    city: "Zaun",
    role: "Químbarón",
    seasons: "Parte 1",
    where: "Las fábricas del Entresuelo",
    ties: "Antiguo hermano de Vander. Padre adoptivo de Jinx. Singed.",
    bio: [
      "Fue el mejor amigo de Vander hasta que dejaron de pensar igual sobre Piltover. La cicatriz del ojo es un recuerdo de ese día.",
      "Controla las fábricas y la calle, y paga su sueño de una Zaun independiente con el brillo. Es frío con todo el mundo menos con Jinx, la única que puede hacerle dudar.",
    ],
    image: P + "silco.webp",
  },
  {
    name: "Sevika",
    city: "Zaun",
    role: "Mano derecha de Silco",
    seasons: "Parte 1 · Parte 2",
    where: "Las fábricas del Entresuelo",
    ties: "Trabaja para Silco. Poco cariño por Jinx.",
    bio: [
      "Hace el trabajo sucio de Silco sin preguntar. Juega a las cartas, bebe fuerte y no se queja nunca, ni siquiera cuando pierde el brazo y lo cambia por uno mecánico.",
      "En la Parte 2, sin Silco, le toca decidir qué es Zaun y quién habla por ella.",
    ],
    image: P + "sevika.webp",
  },
  {
    name: "Singed",
    city: "Zaun",
    role: "Químico",
    seasons: "Parte 1 · Parte 2",
    where: "Su laboratorio, en el Sumidero",
    ties: "Trabaja para Silco. Viktor acude a él.",
    bio: [
      "Un químico brillante que habla bajo, pregunta cosas incómodas y trata a la gente como si fueran datos de un experimento. Trabaja para Silco y de su laboratorio sale el brillo.",
      "Para él ningún precio es demasiado alto si hace avanzar la ciencia. Lo que pasa en su mesa de operaciones marca a más de un personaje de la serie.",
    ],
    image: P + "singed.webp",
  },
  {
    name: "Viktor",
    city: "Zaun",
    role: "Científico",
    seasons: "Parte 1 · Parte 2",
    where: "El taller de Jayce; en la Parte 2, su comuna en Zaun",
    ties: "Socio de Jayce. Ayudante de Heimerdinger. Sky.",
    bio: [
      "Nació abajo, enfermo y con una cojera, y llegó a la Academia de Piltover solo por talento. Con Jayce consigue que la hextech funcione de verdad.",
      "Su cuerpo se apaga más rápido que su paciencia, y eso le lleva al Hexcore. En la Parte 2 cura a la gente de Zaun… a un precio que nadie le ha pedido.",
    ],
    image: P + "viktor.webp",
  },
  {
    name: "Isha",
    city: "Zaun",
    role: "Niña de Zaun",
    seasons: "Parte 2",
    where: "Siempre detrás de Jinx",
    ties: "Jinx la adopta sin decirlo en voz alta.",
    bio: [
      "Una cría de Zaun que no habla: se explica con gestos, muecas y tirones de manga. Se pega a Jinx y no hay manera de despegarla.",
      "Con ella, Jinx se descubre haciendo de hermana mayor, lo que Vi fue para Powder.",
    ],
    image: P + "isha.webp",
  },
  {
    name: "Caitlyn",
    city: "Piltover",
    role: "Ejecutora",
    seasons: "Parte 1 · Parte 2",
    where: "La Mansión Kiramman; en la Parte 2, al mando de los ejecutores",
    ties: "Hija de Cassandra y Tobias Kiramman. Vi.",
    bio: [
      "Podría vivir de su apellido, pero eligió ser ejecutora. Tiene la mejor puntería de Piltover y una manía: seguir las pruebas aunque lleven a sitios donde nadie quiere mirar.",
      "Eso la lleva a bajar a Zaun con Vi. En la Parte 2 la pérdida la endurece y Piltover le pone un rifle en las manos y una guerra delante.",
    ],
    image: P + "caitlyn.webp",
  },
  {
    name: "Jayce",
    city: "Piltover",
    role: "Inventor",
    seasons: "Parte 1 · Parte 2",
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
    seasons: "Parte 1 · Parte 2",
    where: "La Academia",
    ties: "Fue mentor de Jayce y Viktor. Ekko, en la Parte 2.",
    bio: [
      "Un yordle que lleva siglos en Piltover y ha visto nacer y caer muchas ideas brillantes. Por eso desconfía de las prisas y de la hextech.",
      "El Consejo acaba apartándolo por ser demasiado prudente. En la Parte 2 baja a Zaun y descubre que todavía le quedan cosas por aprender.",
    ],
    image: P + "heimerdinger.webp",
  },
  {
    name: "Mel Medarda",
    city: "Piltover",
    role: "Consejera",
    seasons: "Parte 1 · Parte 2",
    where: "La Sala del Consejo",
    ties: "Hija de Ambessa. Jayce.",
    bio: [
      "La consejera más lista de Piltover. Llegó de Noxus de niña, apartada por su propia madre, y aprendió a ganar sin levantar la voz.",
      "Ve en la hextech la oportunidad de Piltover y en Jayce a la persona que puede ponerle cara. En la Parte 2 descubre que su familia le había ocultado algo de sí misma.",
    ],
    image: P + "mel.webp",
  },
  {
    name: "Cassandra",
    city: "Piltover",
    role: "Consejera",
    seasons: "Parte 1 · Parte 2",
    where: "La Sala del Consejo y la Mansión Kiramman",
    ties: "Madre de Caitlyn. Esposa de Tobias.",
    bio: [
      "Cabeza de la familia Kiramman y voz firme del Consejo. No le hace ninguna gracia que su hija lleve uniforme de ejecutora.",
      "Educada, protectora y muy consciente de lo que pesa un apellido en Piltover.",
    ],
    image: P + "cassandra.webp",
  },
  {
    name: "Maddie",
    city: "Piltover",
    role: "Ejecutora",
    seasons: "Parte 2",
    where: "Con Caitlyn y los ejecutores",
    ties: "Compañera de Caitlyn.",
    bio: [
      "Ejecutora joven, simpática y siempre dispuesta a ayudar a Caitlyn en lo que haga falta.",
      "Demasiado dispuesta, quizá.",
    ],
    image: P + "maddie.webp",
  },
  {
    name: "Ambessa",
    city: "Noxus",
    role: "Señora de la guerra",
    seasons: "Parte 1 · Parte 2",
    where: "La Sala del Consejo, en la Parte 2",
    ties: "Madre de Mel.",
    bio: [
      "Una general noxiana que solo respeta la fuerza. Llega a Piltover buscando hextech para sus guerras y a su hija, por ese orden o por el contrario, según el día.",
      "En la Parte 2 entra en la política de Piltover con sus propios soldados. Quiere a su familia, pero eso no la convierte en alguien en quien confiar.",
    ],
    image: P + "ambessa.webp",
  },
];

export const places: Place[] = [
  {
    name: "Las Hexpuertas",
    city: "Piltover",
    category: "Infraestructura",
    zone: "Muelles",
    seasons: "Parte 1 · Parte 2",
    who: "Comerciantes y marineros de toda Runaterra",
    bio: [
      "Dos grandes arcos de latón a la orilla del mar que, al encenderse, abren un paso de hextech para los barcos. Lo que antes era un rodeo de semanas se hace en un momento, y todo ese comercio pasa ahora por Piltover.",
      "Se inauguran un Día del Progreso, con Jayce y Viktor de héroes, y convierten a Piltover en la ciudad más rica del continente. También la ponen en el punto de mira de Noxus.",
      "En la Parte 2 siguen siendo el orgullo de la ciudad, pero ya nadie las mira solo como un invento: son poder.",
    ],
    inGame: "Primera parada de la línea de Piltover, a la izquierda del mapa 3D.",
    stop: { id: "Piltover/Hexpuertas", x: 3.2, y: 44.8 },
    image: PIL + "hexpuertas-t1.webp",
  },
  {
    name: "La Academia",
    city: "Piltover",
    category: "Institución",
    zone: "Barrio académico",
    seasons: "Parte 1 · Parte 2",
    who: "Heimerdinger, Jayce, Viktor, estudiantes",
    bio: [
      "La escuela de ciencia de Piltover: aulas, archivos, laboratorios y estatuas de los grandes inventores. Estudiar aquí es el mayor orgullo de una familia de arriba y casi imposible para alguien de abajo.",
      "Heimerdinger la dirige desde hace generaciones. Aquí casi expulsan a Jayce por investigar la magia, y aquí trabaja Viktor como ayudante del decano, el único de Zaun con sitio propio.",
      "De sus laboratorios sale la hextech. En la Parte 2 se llena de encargos que tienen más que ver con armas que con ciencia.",
    ],
    inGame: "Si eliges Piltover, tu historia empieza aquí con Heimerdinger. Minijuego: El archivo.",
    stop: { id: "Piltover/Academia", x: 12.4, y: 44.8 },
    image: PIL + "academia-fachada.webp",
  },
  {
    name: "La Sala del Consejo",
    city: "Piltover",
    category: "Institución",
    zone: "Distrito del Consejo",
    seasons: "Parte 1 · Parte 2",
    who: "Mel, Cassandra, Jayce, Salo, Shoola, Heimerdinger; Ambessa en la Parte 2",
    bio: [
      "Mármol, cúpula dorada y una mesa redonda donde las grandes familias deciden el futuro de las dos ciudades. Zaun nunca ha tenido silla.",
      "Aquí Jayce presenta la hextech, Mel mueve sus votos sin que se note y Heimerdinger pierde su puesto. Al final de la Parte 1, cuando por fin se habla de paz, un ataque lo cambia todo.",
      "En la Parte 2 la sala se reconstruye, pero las decisiones se toman con soldados noxianos en la puerta.",
    ],
    inGame: "Minijuego: Debate del Consejo.",
    stop: { id: "Piltover/Consejo", x: 20.3, y: 44.8 },
    image: PIL + "consejo-t2.webp",
  },
  {
    name: "La Plaza del Progreso",
    city: "Piltover",
    category: "Distrito",
    zone: "Centro",
    seasons: "Parte 1 · Parte 2",
    who: "La gente de Piltover",
    bio: [
      "El centro de la ciudad: estatuas, mercados, tranvías y bandas de música. Aquí se celebra el Día del Progreso, cuando Piltover presume de sus inventos y premia a sus genios.",
      "Es el Piltover que ve el visitante: limpio, luminoso y seguro, a pocos pasos del puente que nadie quiere cruzar.",
      "En la Parte 2 los mismos discursos suenan mucho más a guerra.",
    ],
    inGame: "Minijuego: Baile de gala, en la fiesta del Día del Progreso.",
    stop: { id: "Piltover/Plaza", x: 28.3, y: 44.8 },
    image: PIL + "plaza-t1.webp",
  },
  {
    name: "El Taller de Jayce",
    city: "Piltover",
    category: "Taller",
    zone: "Barrio académico",
    seasons: "Parte 1 · Parte 2",
    who: "Jayce, Viktor",
    bio: [
      "Un desván lleno de planos, cristales y prototipos a medio montar. Cuando la serie empieza, el piso de Jayce acaba destrozado tras el robo de Vi y su banda, y eso le pone en el punto de mira del Consejo.",
      "Aquí Jayce y Viktor pasan noches enteras hasta que el primer cristal hextech responde. Aquí nacen las Hexpuertas, el guantelete y, con el tiempo, cosas que se parecen demasiado a armas.",
      "En la Parte 2 el taller sigue lleno de ruido, pero Viktor ya no está.",
    ],
    inGame: "Minijuego: Calibrar el cristal.",
    stop: { id: "Piltover/Taller", x: 35.4, y: 44.8 },
    image: PIL + "taller-jayce-t1.webp",
  },
  {
    name: "La Mansión Kiramman",
    city: "Piltover",
    category: "Distrito",
    zone: "Barrio alto",
    seasons: "Parte 1 · Parte 2",
    who: "Caitlyn, Cassandra, Tobias",
    bio: [
      "La casa de una de las familias más antiguas de Piltover: retratos, jardines en terraza, servicio y un campo de tiro donde Caitlyn practica desde niña.",
      "Es el sitio del que Caitlyn sale cada mañana con su uniforme de ejecutora, para disgusto de su madre.",
      "En la Parte 2 la casa se queda grande y fría.",
    ],
    inGame: "Minijuego: Tiro de precisión, en los jardines.",
    stop: { id: "Piltover/Kiramman", x: 42.5, y: 44.8 },
    image: PIL + "mansion-kiramman-t2.webp",
  },
  {
    name: "El Puente del Progreso",
    city: "Piltover",
    category: "Infraestructura",
    zone: "Entre Piltover y Zaun",
    seasons: "Parte 1 · Parte 2",
    who: "Ejecutores de guardia",
    bio: [
      "Torres de hierro, un reloj dorado y el único paso entre las dos ciudades. Es también su frontera más vigilada.",
      "Años antes de la serie, Vander y Silco lo cruzaron al frente de una revuelta que acabó en masacre. De aquella derrota nacen la tregua de Vander y el odio de Silco.",
      "Debajo empieza Zaun: desde el lado del puente se baja a los Callejones.",
    ],
    inGame: "Siempre apareces aquí, al empezar y al cargar partida. Desde el Puente se baja a Zaun.",
    stop: { id: "Piltover/Puente", x: 53.8, y: 44.8 },
    image: PIL + "puente-progreso-t1.webp",
  },
  {
    name: "Stillwater",
    city: "Piltover",
    category: "Institución",
    zone: "Fuera de la ciudad, en el mar",
    seasons: "Parte 1",
    who: "Presos y carceleros",
    bio: [
      "La prisión de Piltover, aislada en el agua. Aquí acaban los de abajo que molestan demasiado.",
      "Vi pasa años encerrada en Stillwater hasta que Caitlyn la saca para que la ayude a bajar a Zaun.",
    ],
    inGame: "Fuera de la línea principal: solo se llega por misión.",
    image: PIL + "stillwater-t1.webp",
  },
  {
    name: "La Última Gota",
    city: "Zaun",
    category: "Comercio",
    zone: "Promenade",
    seasons: "Parte 1 · Parte 2",
    who: "Vander, Vi, Powder, Mylo, Claggor; Sevika más adelante",
    bio: [
      "El bar de Vander: casa, territorio neutral y ring de peleas, todo a la vez. Detrás de la barra hay una foto de familia y debajo del suelo, un foso donde se arreglan las cuentas.",
      "Mientras Vander está, aquí dentro no hay bandos. Cuando falta, el bar pasa a manos de la gente de Silco y en la mesa del fondo se juega a las cartas con Sevika.",
      "Es el primer sitio al que vuelve cualquiera que se haya criado en los Callejones.",
    ],
    inGame: "Si eliges Zaun, tu historia empieza aquí con Vander. Minijuegos: El foso y Cartas en La Última Gota.",
    stop: { id: "Zaun/Promenade/UltimaGota", x: 66.4, y: 54.3 },
    image: ZA + "ultima-gota-bar.jpg",
  },
  {
    name: "El Mercado",
    city: "Zaun",
    category: "Comercio",
    zone: "Promenade",
    seasons: "Parte 1 · Parte 2",
    who: "Finn y otros químbarones, tenderos",
    bio: [
      "Puestos colgados de tuberías, comida callejera, neón y piezas de dudosa procedencia. En Zaun se compra de todo y casi todo se regatea.",
      "Los químbarones de Silco se pasean por aquí como si fuera suyo, y en parte lo es.",
      "Es el sitio donde mejor se oye lo que pasa en la ciudad.",
    ],
    inGame: "Parada de la Promenade, entre La Última Gota y la Tienda de Benzo.",
    stop: { id: "Zaun/Promenade/Mercado", x: 75.6, y: 54.3 },
    image: ZA + "mercado.png",
  },
  {
    name: "La Tienda de Benzo",
    city: "Zaun",
    category: "Comercio",
    zone: "Promenade",
    seasons: "Parte 1",
    who: "Benzo, Ekko",
    bio: [
      "Una trastienda de los Callejones llena de recambios, chatarra y cosas que nadie sabe de dónde salen. Benzo compra, vende y fía.",
      "Fue el mentor de Ekko y uno de los pocos que siguieron fieles a Vander cuando Silco empezó a mandar.",
    ],
    inGame: "Última parada de la Promenade.",
    stop: { id: "Zaun/Promenade/TiendaBenzo", x: 84.4, y: 54.3 },
    image: ZA + "fisuras-superiores.jpg",
  },
  {
    name: "Las Fábricas",
    city: "Zaun",
    category: "Infraestructura",
    zone: "Entresuelo",
    seasons: "Parte 1 · Parte 2",
    who: "Silco, Sevika, los químbarones",
    bio: [
      "Chimeneas, tuberías y turnos que no acaban nunca. Las fábricas son el motor de Zaun y el negocio de los químbarones.",
      "Silco tiene aquí su despacho, con vistas a la planta donde se fabrica el brillo. Desde aquí controla la calle.",
      "En la Parte 2, sin Silco, la pregunta es quién se queda con todo esto.",
    ],
    inGame: "Parada del Entresuelo; se llega en ascensor desde la Promenade.",
    stop: { id: "Zaun/Entresuelo/Fabricas", x: 68.2, y: 70.1 },
    image: ZA + "fabricas.webp",
  },
  {
    name: "El Árbol",
    city: "Zaun",
    category: "Refugio",
    zone: "Entresuelo",
    seasons: "Parte 1 · Parte 2",
    who: "Ekko y las Luciérnagas",
    bio: [
      "Un árbol gigante escondido en el subsuelo que brilla con luz propia. Las Luciérnagas viven en sus ramas y lo defienden de Silco.",
      "Es casi el único sitio de Zaun donde se respira bien: casas en las ramas, niños, plantas y una comunidad que se ayuda.",
      "Para entrar hay que conocer el camino, o que Ekko quiera que lo conozcas.",
    ],
    inGame: "Parada del Entresuelo. Minijuego cercano: Carrera de aerotabla.",
    stop: { id: "Zaun/Entresuelo/Luciernagas", x: 80.9, y: 70.1 },
    image: ZA + "arbol-fireflight.jpg",
  },
  {
    name: "El laboratorio de Singed",
    city: "Zaun",
    category: "Taller",
    zone: "Sumidero",
    seasons: "Parte 1 · Parte 2",
    who: "Singed",
    bio: [
      "Frascos de colores, jaulas, plantas raras y una mesa de operaciones. Aquí trabaja Singed, siempre en voz baja.",
      "De aquí sale el brillo que Silco vende arriba y abajo, y aquí acaba Vander.",
      "Viktor también baja a este laboratorio cuando la ciencia de arriba ya no le basta.",
    ],
    inGame: "Parada del Sumidero. Minijuego: Mezclas de quimtec.",
    stop: { id: "Zaun/Sumidero/LabSinged", x: 68.0, y: 89.8 },
    image: ZA + "singed-laboratorio.png",
  },
  {
    name: "El Escondite de Jinx",
    city: "Zaun",
    category: "Refugio",
    zone: "Sumidero",
    seasons: "Parte 1 · Parte 2",
    who: "Jinx; Isha en la Parte 2",
    bio: [
      "Un taller lleno de bombas, muñecos, dibujos en las paredes y recuerdos de cuando todavía se llamaba Powder.",
      "Todo está pintado de rosa y azul, y nada está donde parece. Mejor no tocar nada sin preguntar.",
    ],
    inGame: "Parada del Sumidero. Minijuego cercano: Graffiti.",
    stop: { id: "Zaun/Sumidero/EsconditeJinx", x: 80.5, y: 89.8 },
    image: ZA + "escondite-jinx.jpg",
  },
  {
    name: "Los Callejones",
    city: "Zaun",
    category: "Distrito",
    zone: "Promenade",
    seasons: "Parte 1 · Parte 2",
    who: "Vi, Ekko y medio Zaun",
    bio: [
      "Las calles que quedan justo debajo del Puente: pasarelas, tejados, neón, humo y vecinos que se conocen de toda la vida.",
      "Es el barrio de Vander, el de las peleas y los bares, y el que corre por los tejados cuando llegan los ejecutores.",
      "En la Parte 2 las paredes están llenas de los graffiti de Jinx.",
    ],
    inGame: "Toda la Promenade del mapa 3D forma parte de los Callejones.",
    image: ZA + "callejones.webp",
  },
  {
    name: "El Sumidero",
    city: "Zaun",
    category: "Distrito",
    zone: "El nivel más bajo",
    seasons: "Parte 1 · Parte 2",
    who: "Los que no tienen otro sitio",
    bio: [
      "El fondo de Zaun: niebla química, agua estancada y la gente más pobre de las dos ciudades. La luz del sol no llega.",
      "Aquí abajo esconden sus cosas los que no quieren que los encuentren, como Singed o Jinx.",
    ],
    inGame: "El tercer nivel del mapa 3D; se baja en ascensor desde el Entresuelo.",
    image: ZA + "sumidero.webp",
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

export const minigameShots = [
  { src: "/assets/img/minijuegos/foso.webp", label: "El foso · Zaun" },
  { src: "/assets/img/minijuegos/aerotabla.webp", label: "Carrera de aerotabla · Zaun" },
  { src: "/assets/img/minijuegos/cartas.webp", label: "Cartas en La Última Gota · Zaun" },
  { src: "/assets/img/minijuegos/grafiti.webp", label: "Grafiti · Zaun" },
  { src: "/assets/img/minijuegos/mezclas.webp", label: "Mezclas de quimtec · Zaun" },
  { src: "/assets/img/minijuegos/cristal.webp", label: "Calibrar el cristal · Piltover" },
  { src: "/assets/img/minijuegos/consejo.webp", label: "Debate del Consejo · Piltover" },
  { src: "/assets/img/minijuegos/gala.webp", label: "Baile de gala · Piltover" },
  { src: "/assets/img/minijuegos/archivo.webp", label: "El Archivo · Piltover" },
  { src: "/assets/img/minijuegos/tiro.webp", label: "Tiro de precisión · Piltover" },
];

export const GITHUB ="https://github.com/MarinaDP2006/RIFTS-GEARS";
