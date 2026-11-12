class_name Historia
extends RefCounted

# Contenido de los 30 capítulos (15 de la Parte 1 y 15 de la Parte 2).
# En los textos, {nombre} es el nombre del personaje del jugador y {ciudad} su ciudad.
# Cada capítulo: título, lugar del mapa 3D, personaje con el que se habla,
# líneas de diálogo, una decisión y, si la historia lo pide, un minijuego.

const NOMBRES := {
	"vi": "Vi", "jinx": "Jinx", "powder": "Powder", "vander": "Vander", "silco": "Silco",
	"jayce": "Jayce", "viktor": "Viktor", "caitlyn": "Caitlyn", "mel": "Mel",
	"heimerdinger": "Heimerdinger", "ekko": "Ekko", "sevika": "Sevika", "singed": "Singed",
	"benzo": "Benzo", "ambessa": "Ambessa", "cassandra": "Cassandra",
	"marcus": "Marcus", "finn": "Finn", "salo": "Salo", "shoola": "Shoola", "maddie": "Maddie",
	"tu": "Tú", "narrador": "",
}

# Imagen de fondo de cada lugar en la Parte 1 y en la Parte 2.
const FONDOS := {
	"Puente": ["s1/puente.webp", "s2/puente-zaun.webp"],
	"Hexpuertas": ["s1/hexpuertas.webp", "s2/hexpuertas.webp"],
	"Academia": ["s1/piltover.webp", "s2/piltover.webp"],
	"Consejo": ["s1/plaza.webp", "s2/consejo.webp"],
	"Plaza": ["s1/plaza.webp", "s2/plaza.webp"],
	"Taller": ["s1/taller-jayce.webp", "s2/taller-jayce.webp"],
	"Kiramman": ["s1/artesanos.webp", "s2/mansion-kiramman.webp"],
	"UltimaGota": ["s1/ultima-gota.webp", "s1/zaun-ultima-gota-bar.jpg"],
	"Mercado": ["s1/mercado.webp", "s2/mercado.webp"],
	"TiendaBenzo": ["s1/zaun-centro.jpg", "s2/callejones.webp"],
	"Fabricas": ["s1/fabrica.webp", "s2/zaun-fisuras-superiores.jpg"],
	"Luciernagas": ["s1/arbol.webp", "s2/zaun-comuna-viktor.jpg"],
	"LabSinged": ["s1/sumidero.webp", "s2/zaun-singed-laboratorio.png"],
	"EsconditeJinx": ["s1/zaun-ciudad-subterranea.jpg", "s2/escondite-jinx.webp"],
}

const CAPITULOS := [
	# ---------------- PARTE 1 ----------------
	{
		"titulo": "Un bar sin Vander",
		"lugar": "UltimaGota", "personaje": "sevika",
		"lineas": [
			["narrador", "Han pasado siete años desde la explosión. Vander está muerto y La Última Gota ya no es suya: ahora es de Silco."],
			["sevika", "Si buscas al viejo, llegas tarde. Aquí ya nadie sirve zumo ni cuenta cuentos."],
			["sevika", "Las reglas son sencillas: pagas, bebes y no preguntas por lo que pasó aquella noche."],
			["narrador", "En la pared aún se ve la marca de un puño que nadie se ha atrevido a tapar."],
		],
		"saludo": {"Zaun": "Te conozco. Eras de los que venían cuando el bar era de Vander.", "Piltover": "Un piltillano. Aquí abajo eso se paga caro, o se cobra caro."},
		"decision": {
			"pregunta": "Sevika te ofrece un taburete y un trabajo. ¿Qué le dices?",
			"opciones": [
				{"texto": "«Acepto. Dime qué hay que hacer.»", "respuesta": "Bien. Empieza cargando cajas. Y no hagas preguntas que no quieras oír.", "afinidad": {"sevika": 10, "silco": 4}},
				{"texto": "«Vengo por Vander.»", "respuesta": "Sevika se queda callada un segundo. «Entonces brinda por él. Y luego olvídalo.»", "afinidad": {"sevika": 2, "vi": 6}},
				{"texto": "«¿Qué gano yo?»", "respuesta": "Ganas no acabar en el Sumidero. Que no es poco.", "afinidad": {"sevika": 4}},
			],
		},
	},
	{
		"titulo": "El mercado del brillo",
		"lugar": "Mercado", "personaje": "ekko",
		"lineas": [
			["narrador", "El mercado de la Promenade es un río de gente. Entre los puestos, frascos de un líquido púrpura cambian de mano en voz baja."],
			["ekko", "Lo llaman brillo. Silco lo reparte desde que Vander ya no está para impedirlo."],
			["ekko", "Antes este barrio tenía a alguien que daba la cara por él. Ahora solo tiene a quien cobra más."],
			["ekko", "Yo intento que la gente no se olvide de cómo era. Aunque cada año cuesta más."],
		],
		"saludo": {"Zaun": "Tú también te acuerdas de cómo era esto antes, ¿verdad?", "Piltover": "Si vienes a comprar brillo, te has equivocado de persona."},
		"decision": {
			"pregunta": "Un vendedor de brillo te ofrece un frasco. ¿Qué haces?",
			"opciones": [
				{"texto": "Lo rechazas delante de todos.", "respuesta": "Ekko sonríe. «Así se empieza.»", "afinidad": {"ekko": 12}, "stat": {"valor": 1}},
				{"texto": "Lo compras para ver qué es.", "respuesta": "Ekko te mira decepcionado. «Ten cuidado con eso.»", "afinidad": {"ekko": -4, "silco": 4}},
				{"texto": "Sigues al vendedor para ver de dónde lo saca.", "respuesta": "Te lleva hasta el Entresuelo. Ekko apunta la dirección.", "afinidad": {"ekko": 8}, "stat": {"sigilo": 1}},
			],
		},
	},
	{
		"titulo": "La academia de los que miran hacia arriba",
		"lugar": "Academia", "personaje": "jayce",
		"lineas": [
			["narrador", "En lo alto de Piltover, la Academia brilla como si el sol le perteneciera. Un joven con las manos quemadas discute con un tablero lleno de cálculos."],
			["jayce", "Lo tengo casi. La magia no es un misterio: es energía que nadie se ha atrevido a medir."],
			["jayce", "El Consejo dice que es peligroso. Lo peligroso es quedarse quieto."],
			["heimerdinger", "Joven Talis, la paciencia también es una forma de progreso. Una que dura más."],
		],
		"saludo": {"Zaun": "¿Vienes de abajo? Entonces sabes lo que es construir con lo que hay.", "Piltover": "Otro vecino de la ciudad. ¿Vienes a ver cómo cambia el mundo?"},
		"decision": {
			"pregunta": "Jayce te pregunta qué opinas de sus experimentos.",
			"opciones": [
				{"texto": "«Hazlo. El mundo necesita valientes.»", "respuesta": "¡Eso! Alguien con sentido común por fin.", "afinidad": {"jayce": 10, "heimerdinger": -4}},
				{"texto": "«Escucha a Heimerdinger.»", "respuesta": "Hmpf. Tú también. Bueno, al menos eres sincero.", "afinidad": {"heimerdinger": 8, "jayce": -2}},
				{"texto": "«¿Quién lo pagará si sale mal?»", "respuesta": "...Esa es la pregunta que nadie se hace aquí arriba. Gracias.", "afinidad": {"jayce": 3, "viktor": 4}, "stat": {"ingenio": 1}},
			],
		},
	},
	{
		"titulo": "Un hombre de Zaun en la Academia",
		"lugar": "Taller", "personaje": "viktor",
		"lineas": [
			["narrador", "El taller está lleno de engranajes y polvo. Un hombre apoyado en un bastón revisa los cálculos de Jayce sin pedir permiso."],
			["viktor", "Tus números son buenos. Tu caligrafía, no tanto. Aquí hay un error que te habría costado los dedos."],
			["jayce", "¿Quién eres?"],
			["viktor", "Alguien que sabe lo que es trabajar sin que nadie te mire. Viktor. Del Entresuelo."],
		],
		"saludo": {"Zaun": "Otro de abajo que ha subido las escaleras. Pocos lo consiguen.", "Piltover": "Encantado. No todos los de arriba se paran a hablar conmigo."},
		"minijuego": "cristal",
		"decision": {
			"pregunta": "Viktor necesita ayuda para estabilizar un cristal. ¿Cómo lo haces?",
			"opciones": [
				{"texto": "Sigues sus indicaciones al pie de la letra.", "respuesta": "Perfecto. Precisión: eso es todo lo que pido.", "afinidad": {"viktor": 10}},
				{"texto": "Propones una idea arriesgada.", "respuesta": "Interesante... muy interesante. Funciona, aunque no sé por qué.", "afinidad": {"viktor": 6, "jayce": 6}, "stat": {"ingenio": 1}},
			],
		},
	},
	{
		"titulo": "El cargamento",
		"lugar": "Kiramman", "personaje": "jinx",
		"lineas": [
			["narrador", "Noche en los tejados de Piltover. Un cargamento de hextech cruza el distrito de los artesanos."],
			["jinx", "¡Hola! Tú no eres un ejecutor, ¿verdad? Bien. Los ejecutores hacen demasiado ruido al morir."],
			["jinx", "Silco quiere esas cajas. Y yo quiero que Silco esté contento. Así que vamos a hacer mucho ruido."],
			["narrador", "Abajo, los ejecutores escoltan las cajas sin mirar hacia arriba."],
		],
		"saludo": {"Zaun": "¡Otro de abajo! Mejor. Los de abajo no lloran tanto.", "Piltover": "Un piltillano en mi tejado. Qué valiente. O qué tonto."},
		"minijuego": "foso",
		"decision": {
			"pregunta": "Jinx va a volar el carro y hay gente cerca. ¿Qué haces?",
			"opciones": [
				{"texto": "Avisas a la gente para que se aparte.", "respuesta": "Jinx pone los ojos en blanco. «Aguafiestas.» Pero espera.", "afinidad": {"jinx": -2, "caitlyn": 6}, "stat": {"valor": 1}},
				{"texto": "Ayudas a Jinx con las cajas.", "respuesta": "«¡Sabía que me caerías bien!» Las cajas acaban en Zaun.", "afinidad": {"jinx": 12, "silco": 6}},
			],
		},
	},
	{
		"titulo": "Ejecutores en la Promenade",
		"lugar": "TiendaBenzo", "personaje": "marcus",
		"lineas": [
			["narrador", "La vieja tienda de Benzo está cerrada desde que lo mataron. Delante, el sheriff Marcus interroga a los vecinos."],
			["marcus", "Alguien robó un cargamento de hextech anoche. Y alguien de este barrio sabe quién fue."],
			["marcus", "No me gusta bajar aquí. Pero me gusta menos volver arriba con las manos vacías."],
			["narrador", "Detrás de él, una pintada de colores chillones parece reírse de todos."],
		],
		"saludo": {"Zaun": "Tú eres de aquí. Seguro que oyes cosas.", "Piltover": "¿Qué hace alguien de arriba en este agujero? Habla."},
		"decision": {
			"pregunta": "Marcus te pregunta por el robo.",
			"opciones": [
				{"texto": "Mientes para cubrir al barrio.", "respuesta": "Marcus te mira mucho rato y se va. Los vecinos te lo agradecen con un gesto.", "afinidad": {"ekko": 6, "silco": 4}, "stat": {"sigilo": 1}},
				{"texto": "Le dices que no viste nada.", "respuesta": "Marcus apunta tu nombre en una libreta. Eso no puede ser bueno.", "afinidad": {"marcus": 2}},
				{"texto": "Le das una pista falsa hacia el Sumidero.", "respuesta": "Los ejecutores bajan por el camino equivocado. Alguien se ríe desde un tejado.", "afinidad": {"jinx": 6, "ekko": 4}, "stat": {"ingenio": 1}},
			],
		},
	},
	{
		"titulo": "El hombre de los ojos distintos",
		"lugar": "Fabricas", "personaje": "silco",
		"lineas": [
			["narrador", "En el Entresuelo, entre chimeneas, un hombre con un ojo rojo te espera como si te conociera."],
			["silco", "No tengas miedo. El miedo es para quienes no entienden cómo funciona esta ciudad."],
			["silco", "Piltover nos deja las sobras y llama a eso paz. Yo lo llamo paciencia. Y la paciencia se acaba."],
			["sevika", "Jefe, el envío del Sumidero está listo."],
		],
		"saludo": {"Zaun": "Tú eres de aquí. Sabes lo que nos deben.", "Piltover": "Un piltillano que baja a mis fábricas. Valiente o perdido."},
		"decision": {
			"pregunta": "Silco te ofrece trabajar para él. ¿Qué respondes?",
			"opciones": [
				{"texto": "«Lo pensaré.»", "respuesta": "Hazlo. Pero no tardes. Zaun no espera a nadie.", "afinidad": {"silco": 3}},
				{"texto": "«Trabajo por mi cuenta.»", "respuesta": "Nadie trabaja por su cuenta en Zaun. Ya te darás cuenta.", "afinidad": {"silco": -6, "ekko": 6}},
				{"texto": "«¿Cuánto pagas?»", "respuesta": "Me gusta la gente práctica. Sevika te dirá los detalles.", "afinidad": {"silco": 10, "sevika": 5, "ekko": -4}},
			],
		},
	},
	{
		"titulo": "Lo que se pierde en el agua",
		"lugar": "Puente", "personaje": "finn",
		"lineas": [
			["narrador", "Bajo el Puente del Progreso el agua es negra. Aquí murió Vander, y aquí se cerró para siempre una forma de vivir en Zaun."],
			["finn", "Los barones del brillo nos repartimos lo que dejó el viejo. Silco se queda con la mejor parte, claro."],
			["finn", "Pero los reyes no duran para siempre. Y alguien tendrá que sentarse en su silla."],
			["finn", "Tú pareces de los que saben cuándo cambia el viento."],
		],
		"saludo": {"Zaun": "Uno de los nuestros. Aquí abajo nos ayudamos... cuando nos conviene.", "Piltover": "Un piltillano bajo el Puente. Qué cosa más rara."},
		"decision": {
			"pregunta": "Finn quiere que le ayudes a traicionar a Silco.",
			"opciones": [
				{"texto": "Le dices que no.", "respuesta": "Finn se encoge de hombros. «Tú te lo pierdes.»", "afinidad": {"silco": 6, "finn": -6}},
				{"texto": "Le sigues el juego para avisar a Silco.", "respuesta": "Silco se entera esa misma noche. Finn no volverá a hablarte.", "afinidad": {"silco": 12, "sevika": 6}, "stat": {"sigilo": 1}},
				{"texto": "Aceptas.", "respuesta": "Finn sonríe. «Sabía que eras de los listos.»", "afinidad": {"finn": 12, "silco": -8}},
			],
		},
	},
	{
		"titulo": "El Día del Progreso",
		"lugar": "Hexpuertas", "personaje": "jayce",
		"lineas": [
			["narrador", "Las Hexpuertas se alzan sobre el puerto y Piltover se prepara para el Día del Progreso."],
			["jayce", "Lo conseguimos. La hextech funciona, y va a cambiarlo todo."],
			["viktor", "Lo va a cambiar todo para quien pueda pagarla, Jayce. No te olvides de eso."],
			["mel", "Una invención es tan buena como las manos que la reparten. Y yo tengo buenas manos."],
		],
		"saludo": {"Zaun": "Tú también has visto crecer esto desde abajo. ¿Qué te parece?", "Piltover": "Hoy es un gran día para nuestra ciudad, {nombre}."},
		"minijuego": "consejo",
		"decision": {
			"pregunta": "El Consejo debate quién controla la hextech. ¿A quién apoyas?",
			"opciones": [
				{"texto": "A Jayce: que la Academia la gestione.", "respuesta": "Jayce sonríe. Mel toma nota en silencio.", "afinidad": {"jayce": 10, "mel": -2}},
				{"texto": "A Mel: que se reparta con contratos.", "respuesta": "Mel inclina la cabeza: «Sabía que eras de los que piensan».", "afinidad": {"mel": 12}},
				{"texto": "A Viktor: que llegue también a Zaun.", "respuesta": "Viktor no dice nada, pero te mira como a un aliado.", "afinidad": {"viktor": 12, "jayce": 2}},
			],
		},
	},
	{
		"titulo": "La cárcel de Stillwater",
		"lugar": "Plaza", "personaje": "caitlyn",
		"lineas": [
			["narrador", "Una ejecutora joven, Caitlyn Kiramman, revisa expedientes que nadie más quiere mirar."],
			["caitlyn", "Hay algo que se mueve en Zaun. Un químico nuevo. Lo llaman brillo."],
			["caitlyn", "Necesito a alguien que conozca las dos ciudades. Y una prisionera de Stillwater que dice saber quién lo fabrica."],
			["vi", "Llévame abajo y te lo cuento todo. Bueno, casi todo."],
		],
		"saludo": {"Zaun": "Tú conoces las calles de abajo. Me vendría bien tu ayuda.", "Piltover": "Te he visto en las fiestas de mi madre. Aquí estamos más cómodas, ¿no?"},
		"minijuego": "archivo",
		"decision": {
			"pregunta": "Caitlyn quiere bajar a Zaun con Vi. ¿Qué le aconsejas?",
			"opciones": [
				{"texto": "«Hazlo, pero sin uniforme.»", "respuesta": "Buena idea. Allí abajo, el uniforme es una diana.", "afinidad": {"caitlyn": 10, "vi": 6}, "stat": {"sigilo": 1}},
				{"texto": "«Pide permiso al Consejo.»", "respuesta": "Si espero al Consejo, para cuando decidan ya será tarde.", "afinidad": {"caitlyn": -2, "marcus": 4}},
			],
		},
	},
	{
		"titulo": "Luciérnagas",
		"lugar": "Luciernagas", "personaje": "ekko",
		"lineas": [
			["narrador", "Un árbol enorme crece donde no debería crecer nada. Entre sus ramas brillan cientos de lámparas."],
			["ekko", "Bienvenido al único sitio de Zaun donde nadie te pide nada a cambio."],
			["ekko", "Aquí la gente aprende un oficio, a volar en aerotabla y a no deberle nada a Silco."],
			["ekko", "Si quieres ayudar, demuéstrame que sabes moverte por los tejados."],
		],
		"saludo": {"Zaun": "¡Eh, te conozco del mercado! Siempre fuiste de los buenos.", "Piltover": "¿Un piltillano en el árbol? Vale... pero aquí no hay privilegios."},
		"minijuego": "aerotabla",
		"decision": {
			"pregunta": "Ekko te pide que guardes el secreto de dónde está el árbol.",
			"opciones": [
				{"texto": "«Tu secreto está a salvo.»", "respuesta": "Gracias. Aquí arriba, la confianza vale más que el oro.", "afinidad": {"ekko": 14}},
				{"texto": "«Silco acabará encontrándolo.»", "respuesta": "Que lo intente. Ya nos hemos escondido antes.", "afinidad": {"ekko": 4}, "stat": {"valor": 1}},
			],
		},
	},
	{
		"titulo": "El laboratorio del fondo",
		"lugar": "LabSinged", "personaje": "singed",
		"lineas": [
			["narrador", "El Sumidero huele a química. Entre jaulas y probetas trabaja un hombre que no parpadea."],
			["singed", "La naturaleza no es cruel. Simplemente no le importa. Yo tampoco puedo permitirme que me importe."],
			["singed", "El brillo es un comienzo. Lo que viene después... eso sí será hermoso."],
			["silco", "Doctor, el cliente quiere resultados, no poesía."],
		],
		"saludo": {"Zaun": "Un cuerpo joven de Zaun. Resistente. Interesante.", "Piltover": "Los de arriba siempre bajan buscando algo. ¿Qué buscas tú?"},
		"minijuego": "mezclas",
		"decision": {
			"pregunta": "Singed te pide que mezcles un compuesto. ¿Lo haces bien?",
			"opciones": [
				{"texto": "Lo haces bien, pero apuntas la fórmula.", "respuesta": "Esa fórmula podría salvar a alguien algún día.", "afinidad": {"singed": 6, "caitlyn": 6}, "stat": {"ingenio": 1}},
				{"texto": "Lo estropeas a propósito.", "respuesta": "Singed te mira mucho rato. «Qué pena. Tenías buen pulso.»", "afinidad": {"singed": -8, "ekko": 8}, "stat": {"valor": 1}},
			],
		},
	},
	{
		"titulo": "Jinx",
		"lugar": "EsconditeJinx", "personaje": "jinx",
		"lineas": [
			["narrador", "Las paredes están cubiertas de dibujos y risas pintadas. En medio, una chica con trenzas largas balancea un arma enorme."],
			["jinx", "¡Hola! ¿Has venido a jugar? Aquí todo el mundo viene a jugar. Pocos se van."],
			["jinx", "Antes me llamaba Powder. Powder era una niña que lo estropeaba todo. Jinx también lo estropea todo, pero a propósito."],
			["jinx", "Vi ha vuelto, ¿sabes? Y viene con una de arriba. Qué gracioso. Qué. Gracioso."],
		],
		"saludo": {"Zaun": "Te acuerdas de mí, ¿verdad? ¡Claro que te acuerdas!", "Piltover": "Un piltillano. Me encantan. Hacen ruido cuando se asustan."},
		"minijuego": "grafiti",
		"decision": {
			"pregunta": "Jinx te pregunta si Vi la echó de menos.",
			"opciones": [
				{"texto": "«Nunca dejó de buscarte.»", "respuesta": "...Mentira. Mentira. ¿Mentira? No lo sé. Vete.", "afinidad": {"jinx": 8, "vi": 8}},
				{"texto": "«Ahora tienes a Silco.»", "respuesta": "¡Exacto! Silco nunca se va. Silco nunca miente. Eres listo.", "afinidad": {"jinx": 10, "silco": 6, "vi": -6}},
				{"texto": "«Pregúntaselo tú.»", "respuesta": "Jinx se ríe tan fuerte que tiemblan las paredes. Luego se calla.", "afinidad": {"jinx": 4}, "stat": {"carisma": 1}},
			],
		},
	},
	{
		"titulo": "La gala",
		"lugar": "Kiramman", "personaje": "mel",
		"lineas": [
			["narrador", "La mansión Kiramman se llena de música y vestidos. Piltover celebra mientras Zaun se ahoga en brillo."],
			["mel", "Las fiestas son para que la gente importante finja que no lo es. Disfrútala."],
			["mel", "Mi madre me enseñó que el poder se baila, no se grita. Ella lo hace con espadas. Yo, con conversaciones."],
			["caitlyn", "Si mi madre me ve con el uniforme debajo del vestido, me mata."],
		],
		"saludo": {"Zaun": "No pareces de esta fiesta. Eso me gusta.", "Piltover": "Te sienta bien la ropa de gala, {nombre}."},
		"minijuego": "gala",
		"decision": {
			"pregunta": "Mel te pide un baile. ¿Aceptas?",
			"opciones": [
				{"texto": "Aceptas y la sigues.", "respuesta": "Bailas sin pisarla. Mel sonríe de verdad, solo un segundo.", "afinidad": {"mel": 12}, "stat": {"carisma": 1}},
				{"texto": "Prefieres hablar con Caitlyn.", "respuesta": "Caitlyn agradece la compañía. Mel lo apunta, sin rencor.", "afinidad": {"caitlyn": 10, "mel": -2}},
			],
		},
	},
	{
		"titulo": "El cohete",
		"lugar": "Consejo", "personaje": "jayce",
		"lineas": [
			["narrador", "El Consejo vota la paz. Por primera vez, Zaun y Piltover hablan de iguales."],
			["jayce", "Hoy firmamos un futuro distinto. No el que nos dejaron: el que elegimos."],
			["narrador", "Por la ventana entra una luz azul. Demasiado azul. Demasiado rápida."],
			["narrador", "FIN DE LA PARTE 1."],
		],
		"saludo": {"Zaun": "Estás aquí por Zaun. Gracias por venir.", "Piltover": "Tu ciudad te necesita hoy, {nombre}."},
		"decision": {
			"pregunta": "La sala tiembla. Tienes un segundo.",
			"opciones": [
				{"texto": "Te lanzas a proteger a Jayce.", "respuesta": "Todo se vuelve blanco.", "afinidad": {"jayce": 10}, "stat": {"valor": 1}},
				{"texto": "Te lanzas a proteger a Mel.", "respuesta": "Todo se vuelve blanco.", "afinidad": {"mel": 10}, "stat": {"valor": 1}},
				{"texto": "Corres hacia la ventana.", "respuesta": "Ves una silueta de trenzas sobre los tejados. Luego, todo se vuelve blanco.", "afinidad": {"jinx": 6}},
			],
		},
	},
	# ---------------- PARTE 2 ----------------
	{
		"titulo": "Ceniza",
		"lugar": "Consejo", "personaje": "caitlyn",
		"lineas": [
			["narrador", "El Consejo es un esqueleto de piedra. Huele a quemado y a miedo."],
			["caitlyn", "Mi madre ha muerto. Y la ciudad quiere un culpable antes del amanecer."],
			["caitlyn", "Voy a bajar a Zaun con todos los ejecutores que me den. Y no voy a pedir perdón."],
			["vi", "Cait, si haces esto, no habrá vuelta atrás. Para nadie."],
		],
		"saludo": {"Zaun": "Tú sobreviviste. Algunos de abajo también. No todos.", "Piltover": "Me alegra verte vivo. De verdad."},
		"decision": {
			"pregunta": "Caitlyn quiere venganza. ¿Qué le dices?",
			"opciones": [
				{"texto": "«Haz justicia, no venganza.»", "respuesta": "Caitlyn aprieta los dientes. «No sé si sé distinguirlas ahora mismo.»", "afinidad": {"caitlyn": 6, "vi": 8}},
				{"texto": "«Te acompaño.»", "respuesta": "Gracias. No quiero bajar sola.", "afinidad": {"caitlyn": 12, "ekko": -6}, "stat": {"valor": 1}},
			],
		},
	},
	{
		"titulo": "Estandartes rojos",
		"lugar": "Plaza", "personaje": "ambessa",
		"lineas": [
			["narrador", "En la plaza ondean estandartes rojos. Los soldados de Noxus pasean como si ya fuera suya."],
			["ambessa", "Piltover es una ciudad de genios que no saben defenderse. Yo puedo enseñarles."],
			["ambessa", "Mi hija cree que la palabra vence a la espada. Mi hija sigue viva gracias a mi espada."],
			["mel", "Madre. Esta ciudad no es un campo de batalla."],
		],
		"saludo": {"Zaun": "Los de abajo sabéis luchar. Eso os honra.", "Piltover": "Una ciudad rica y blanda. Tú no pareces blando."},
		"decision": {
			"pregunta": "Ambessa te ofrece un puesto en su guardia.",
			"opciones": [
				{"texto": "Lo aceptas.", "respuesta": "Bien. Noxus recompensa a los que eligen pronto.", "afinidad": {"ambessa": 14, "mel": -6}},
				{"texto": "Lo rechazas mirando a Mel.", "respuesta": "Ambessa sonríe con frialdad. Mel te lo agradece con la mirada.", "afinidad": {"mel": 12, "ambessa": -6}},
			],
		},
	},
	{
		"titulo": "La que se queda en las sombras",
		"lugar": "UltimaGota", "personaje": "sevika",
		"lineas": [
			["narrador", "La Última Gota ya no es de Vander. Ahora es de quien tenga el puño más duro."],
			["sevika", "Silco me dejó un imperio y una chica con un arma. Lo primero me gusta más."],
			["sevika", "Piltover ha bajado con soldados. Esto ya no va de negocios, va de sobrevivir."],
			["sevika", "Y si la loca de las trenzas vuelve a volar algo, que no sea mi bar."],
		],
		"saludo": {"Zaun": "Tú eres de los nuestros. Aquí no hay sitio para dudas.", "Piltover": "¿Qué hace un piltillano en mi bar? Habla rápido."},
		"minijuego": "cartas",
		"decision": {
			"pregunta": "Sevika te reta a una partida de cartas por información.",
			"opciones": [
				{"texto": "Juegas limpio.", "respuesta": "Sevika gruñe. «Al menos no haces trampas. Eso escasea.»", "afinidad": {"sevika": 8}},
				{"texto": "Te guardas una carta en la manga.", "respuesta": "Sevika lo ve. Se ríe. «Vale. Me caes bien.»", "afinidad": {"sevika": 10}, "stat": {"sigilo": 1}},
			],
		},
	},
	{
		"titulo": "Las paredes de colores",
		"lugar": "EsconditeJinx", "personaje": "jinx",
		"lineas": [
			["narrador", "En el escondite de Jinx las paredes están llenas de dibujos nuevos: dos figuras cogidas de la mano, una y otra vez."],
			["jinx", "No los he pintado yo. Bueno, sí. Pero no me acuerdo de haberlo hecho."],
			["jinx", "Piltover dice que soy un monstruo. Los monstruos no pintan, ¿no? Los monstruos solo rompen cosas."],
			["jinx", "Quédate un rato. Aquí abajo hay mucho silencio cuando no explota nada."],
		],
		"saludo": {"Zaun": "Tú no me tienes miedo. Eso es nuevo.", "Piltover": "Un piltillano en mi casa. Qué atrevido."},
		"decision": {
			"pregunta": "Jinx te ofrece uno de sus dibujos.",
			"opciones": [
				{"texto": "Lo guardas con cuidado.", "respuesta": "Jinx finge que no le importa. Le importa.", "afinidad": {"jinx": 14}},
				{"texto": "Le dices que se lo dé a Vi.", "respuesta": "Jinx lo mira mucho rato. Luego lo dobla y se lo guarda.", "afinidad": {"jinx": 8, "vi": 6}},
			],
		},
	},
	{
		"titulo": "Lo que queda de Viktor",
		"lugar": "Luciernagas", "personaje": "viktor",
		"lineas": [
			["narrador", "Bajo el árbol de las luciérnagas, Viktor cura a la gente con una luz que no es del todo humana."],
			["viktor", "La hextech me salvó. Ahora quiero que salve a los demás. Sin precio. Sin Consejo."],
			["viktor", "Hay quien dice que ya no soy yo. Quizá tengan razón. Quizá sea mejor."],
			["ekko", "Viktor... la gente que curas deja de soñar. ¿Eso es salvarlos?"],
		],
		"saludo": {"Zaun": "Tú y yo somos del mismo barro. Quédate.", "Piltover": "Has bajado otra vez. Empiezo a pensar que eres de aquí."},
		"decision": {
			"pregunta": "Viktor te ofrece curarte una vieja herida.",
			"opciones": [
				{"texto": "Aceptas.", "respuesta": "El dolor desaparece. Algo más también, aunque no sabes qué.", "afinidad": {"viktor": 14, "ekko": -6}},
				{"texto": "Te niegas con respeto.", "respuesta": "Viktor asiente. «La libertad también es una forma de dolor.»", "afinidad": {"ekko": 10, "viktor": 2}},
			],
		},
	},
	{
		"titulo": "Jayce sin martillo",
		"lugar": "Taller", "personaje": "jayce",
		"lineas": [
			["narrador", "El taller está en silencio. Jayce mira los planos de un arma que nunca quiso construir."],
			["jayce", "Creí que la hextech traería un mundo nuevo. Ha traído uno peor."],
			["jayce", "Viktor está ahí fuera, convirtiéndose en algo que no entiendo. Y es culpa mía."],
			["heimerdinger", "La culpa es un mal combustible, muchacho. Arde rápido y no lleva a ninguna parte."],
		],
		"saludo": {"Zaun": "Tú lo viste desde abajo. ¿Fuimos los malos?", "Piltover": "Me alegro de que sigas aquí, {nombre}. Quedan pocos amigos."},
		"minijuego": "tiro",
		"decision": {
			"pregunta": "Jayce te pregunta si debe buscar a Viktor o detenerlo.",
			"opciones": [
				{"texto": "«Búscalo. Sigue siendo tu amigo.»", "respuesta": "Jayce respira hondo. «Entonces iré. Aunque me cueste.»", "afinidad": {"jayce": 10, "viktor": 6}},
				{"texto": "«Detenlo antes de que sea tarde.»", "respuesta": "Jayce asiente despacio. Coge el martillo.", "afinidad": {"jayce": 6, "caitlyn": 6}, "stat": {"valor": 1}},
			],
		},
	},
	{
		"titulo": "Hermanas",
		"lugar": "Puente", "personaje": "vi",
		"lineas": [
			["narrador", "Bajo el Puente, otra vez. El mismo agua negra. Las mismas dos ciudades mirándose."],
			["vi", "Todo empezó aquí. Cuando éramos críos y creíamos que un puente unía cosas."],
			["vi", "Voy a hablar con Jinx. Sin ejecutores, sin armas. Solo yo."],
			["caitlyn", "Vi... si no vuelves, voy a bajar a buscarte. Con todo."],
		],
		"saludo": {"Zaun": "Siempre has estado aquí cuando hacía falta. Siempre.", "Piltover": "Tú elegiste bajar con nosotras. No lo olvido."},
		"decision": {
			"pregunta": "Vi te pide que la acompañes a ver a Jinx.",
			"opciones": [
				{"texto": "La acompañas en silencio.", "respuesta": "Vi te coge del hombro. «Gracias por no decir nada.»", "afinidad": {"vi": 12, "jinx": 4}},
				{"texto": "Te quedas con Caitlyn.", "respuesta": "Caitlyn te lo agradece. Las dos miráis el puente hasta que oscurece.", "afinidad": {"caitlyn": 10}},
			],
		},
	},
	{
		"titulo": "El mercado en guerra",
		"lugar": "Mercado", "personaje": "ekko",
		"lineas": [
			["narrador", "El mercado se ha llenado de barricadas. Hay obreros con llaves inglesas y abuelas con cuchillos de cocina."],
			["ekko", "Si Piltover vuelve a bajar, esta vez nos encontrará preparados."],
			["ekko", "Pero no quiero una guerra. Quiero un barrio donde se pueda vivir."],
			["benzo", "Eso decía yo. Y mira cómo acabé... vale, acabé bien. Más o menos."],
		],
		"saludo": {"Zaun": "Este es tu barrio también. Defiéndelo.", "Piltover": "Ahora que has visto esto, ¿qué piensas de tu ciudad?"},
		"decision": {
			"pregunta": "Ekko organiza la defensa. ¿Qué propones?",
			"opciones": [
				{"texto": "Hablar con Piltover antes de luchar.", "respuesta": "Ekko te mira sorprendido. «...Vale. Pero si sale mal, volvemos a las barricadas.»", "afinidad": {"ekko": 8, "caitlyn": 6}, "stat": {"carisma": 1}},
				{"texto": "Reforzar las barricadas.", "respuesta": "Trabajáis toda la noche. El mercado parece una fortaleza.", "afinidad": {"ekko": 10, "sevika": 4}, "stat": {"valor": 1}},
			],
		},
	},
	{
		"titulo": "Consejo de guerra",
		"lugar": "Hexpuertas", "personaje": "mel",
		"lineas": [
			["narrador", "Las Hexpuertas están cerradas. En su sombra, Mel habla en voz baja, como siempre."],
			["mel", "Mi madre quiere convertir la hextech en un ejército. Yo quiero que no haga falta."],
			["mel", "He descubierto que hay algo en mí, una luz dorada, que mi familia me ocultó. Quizá por eso me alejaron."],
			["ambessa", "Hija. No hagas que tenga que elegir entre Noxus y tú."],
		],
		"saludo": {"Zaun": "Tú representas a la gente que siempre olvidamos en el Consejo.", "Piltover": "Necesito a alguien de confianza, {nombre}. Quedan pocos."},
		"decision": {
			"pregunta": "Mel te pide que lleves un mensaje secreto a Zaun.",
			"opciones": [
				{"texto": "Lo llevas sin abrirlo.", "respuesta": "Mel te besa en la mejilla. «Sabía que podía confiar en ti.»", "afinidad": {"mel": 14}, "stat": {"sigilo": 1}},
				{"texto": "Se lo das a Ambessa.", "respuesta": "Ambessa lo lee y sonríe. Mel nunca lo sabrá. O quizá sí.", "afinidad": {"ambessa": 12, "mel": -14}},
			],
		},
	},
	{
		"titulo": "Heimerdinger se despide",
		"lugar": "Academia", "personaje": "heimerdinger",
		"lineas": [
			["narrador", "La Academia está casi vacía. Heimerdinger guarda libros en cajas que nunca se llenan."],
			["heimerdinger", "He vivido siglos, ¿sabes? Y nunca vi a una ciudad equivocarse tan deprisa."],
			["heimerdinger", "Me voy con Ekko. Allí abajo aún creen que el futuro se construye juntos."],
			["heimerdinger", "Cuida de esta ciudad. Aunque ella no sepa cuidarse sola."],
		],
		"saludo": {"Zaun": "¡Ah, un joven de abajo! Los mejores alumnos que nunca tuve.", "Piltover": "Siempre fuiste un buen vecino. Y eso es rarísimo."},
		"decision": {
			"pregunta": "Heimerdinger te regala un libro. ¿Cuál eliges?",
			"opciones": [
				{"texto": "Uno de ingeniería.", "respuesta": "Excelente elección. Que te enseñe a no repetir nuestros errores.", "afinidad": {"heimerdinger": 10}, "stat": {"ingenio": 1}},
				{"texto": "Uno de poesía.", "respuesta": "¡Ja! Nadie elige ese. Por eso lo guardaba para alguien especial.", "afinidad": {"heimerdinger": 12}, "stat": {"carisma": 1}},
			],
		},
	},
	{
		"titulo": "Las fábricas despiertan",
		"lugar": "Fabricas", "personaje": "sevika",
		"lineas": [
			["narrador", "Las chimeneas del Entresuelo vuelven a echar humo. Esta vez fabrican armas."],
			["sevika", "Si viene la guerra, que nos pille con algo en las manos."],
			["sevika", "Silco lo habría hecho mejor. Pero Silco no está. Estoy yo."],
			["vi", "Sevika. Por una vez, estamos en el mismo bando. No lo estropees."],
		],
		"saludo": {"Zaun": "Bien. Necesito manos de aquí.", "Piltover": "Si estás aquí, es que ya has elegido."},
		"decision": {
			"pregunta": "Sevika y Vi discuten. ¿A quién das la razón?",
			"opciones": [
				{"texto": "A Vi: primero la gente.", "respuesta": "Sevika escupe al suelo. Pero cede.", "afinidad": {"vi": 10, "sevika": -4}},
				{"texto": "A Sevika: primero las armas.", "respuesta": "Vi se aleja en silencio. Sevika te da una palmada en la espalda.", "afinidad": {"sevika": 12, "vi": -6}},
			],
		},
	},
	{
		"titulo": "La última copa",
		"lugar": "UltimaGota", "personaje": "jinx",
		"lineas": [
			["narrador", "La Última Gota está vacía. Solo Jinx, sentada en la barra, dibujando en una servilleta."],
			["jinx", "Aquí Vander nos daba zumo y nos contaba cuentos. Los cuentos eran mentira, pero el zumo no."],
			["jinx", "Vander quería que fuéramos una familia. Las familias son difíciles. Las bombas son fáciles."],
			["jinx", "¿Tú crees que la gente puede volver a ser quien era?"],
		],
		"saludo": {"Zaun": "Tú estuviste allí. Cuando yo era Powder. Lo sé.", "Piltover": "Has bajado tantas veces que ya hueles a Zaun."},
		"decision": {
			"pregunta": "Jinx te pregunta si la gente puede cambiar.",
			"opciones": [
				{"texto": "«Sí. Tú también.»", "respuesta": "Jinx sonríe de verdad. Por un momento parece Powder.", "afinidad": {"jinx": 14, "vi": 8}},
				{"texto": "«No hace falta. Ya eres tú.»", "respuesta": "Jinx se ríe y llora a la vez. «Eso es lo más raro que me han dicho.»", "afinidad": {"jinx": 12}, "stat": {"carisma": 1}},
			],
		},
	},
	{
		"titulo": "Las dos ciudades",
		"lugar": "Puente", "personaje": "caitlyn",
		"lineas": [
			["narrador", "En mitad del Puente se encuentran los dos ejércitos. Ejecutores y gente de Zaun, codo con codo."],
			["caitlyn", "Por primera vez, no luchamos unos contra otros. Luchamos juntos."],
			["vi", "Lo que viene ahora no es Noxus ni Piltover. Es Viktor. Y quiere cambiarnos a todos."],
			["ekko", "Pues que venga. Tenemos un barrio entero que defender."],
		],
		"saludo": {"Zaun": "Zaun está contigo.", "Piltover": "Piltover está contigo."},
		"minijuego": "foso",
		"decision": {
			"pregunta": "Antes de la batalla, ¿a quién te acercas?",
			"opciones": [
				{"texto": "A Vi.", "respuesta": "Vi choca su puño con el tuyo. «Como en los viejos tiempos.»", "afinidad": {"vi": 10}},
				{"texto": "A Caitlyn.", "respuesta": "Caitlyn te pasa un rifle. «Cúbreme.»", "afinidad": {"caitlyn": 10}},
				{"texto": "A Ekko.", "respuesta": "Ekko sonríe. «Si salimos de esta, te invito al árbol.»", "afinidad": {"ekko": 10}},
			],
		},
	},
	{
		"titulo": "La luz de Viktor",
		"lugar": "Hexpuertas", "personaje": "viktor",
		"lineas": [
			["narrador", "La hextech brilla en el cielo. Viktor flota, rodeado de luz, ya casi sin rostro."],
			["viktor", "Puedo acabar con el dolor. Con el miedo. Con todo lo que nos separa."],
			["jayce", "Viktor. Eso no es un futuro. Es un final."],
			["viktor", "...Jayce. Siempre tan ruidoso."],
		],
		"saludo": {"Zaun": "Tú entiendes por qué hago esto.", "Piltover": "Incluso tú puedes ser libre."},
		"decision": {
			"pregunta": "Viktor te tiende la mano.",
			"opciones": [
				{"texto": "Le recuerdas quién era.", "respuesta": "Algo se quiebra en su mirada. Por un instante, vuelve a ser Viktor.", "afinidad": {"viktor": 10, "jayce": 10}, "stat": {"carisma": 1}},
				{"texto": "Le das la espalda.", "respuesta": "La luz se apaga un poco. Jayce da un paso adelante.", "afinidad": {"jayce": 8}},
			],
		},
	},
	{
		"titulo": "Después del humo",
		"lugar": "UltimaGota", "personaje": "vi",
		"lineas": [
			["narrador", "El humo se ha ido. Las dos ciudades siguen ahí, heridas, pero de pie."],
			["vi", "Hemos perdido a mucha gente. Pero estamos aquí. Tú también."],
			["vi", "Vander siempre decía que el barrio es la gente que se queda. Tú te has quedado."],
			["narrador", "FIN DE LA PARTE 2. Gracias por vivir esta historia, {nombre}."],
		],
		"saludo": {"Zaun": "Bienvenido a casa.", "Piltover": "Ya eres de los dos lados del Puente."},
		"decision": {
			"pregunta": "¿Qué harás ahora?",
			"opciones": [
				{"texto": "Quedarte en Zaun.", "respuesta": "Reabrirás La Última Gota. Vander estaría orgulloso.", "afinidad": {"vi": 10}},
				{"texto": "Volver a Piltover.", "respuesta": "Ayudarás a reconstruir el Consejo. Esta vez, con sillas para Zaun.", "afinidad": {"caitlyn": 10}},
				{"texto": "Vivir en el Puente.", "respuesta": "Ni arriba ni abajo: en medio, donde se encuentran.", "afinidad": {"ekko": 6, "vi": 6, "caitlyn": 6}},
			],
		},
	},
]

# Devuelve el capítulo (1 a 30) como diccionario.
static func capitulo(numero_global: int) -> Dictionary:
	return CAPITULOS[clampi(numero_global, 1, CAPITULOS.size()) - 1]

static func nombre(id: String) -> String:
	return NOMBRES.get(id, id.capitalize())

# Sustituye {nombre} y {ciudad} por los datos del jugador.
static func formatear(texto: String) -> String:
	var n := DatosPartida.nombre_personaje if DatosPartida.nombre_personaje != "" else "vecino"
	return texto.replace("{nombre}", n).replace("{ciudad}", DatosPartida.ciudad_elegida)

static func fondo(lugar: String, parte: int) -> String:
	var opciones: Array = FONDOS.get(lugar, ["s1/puente.webp", "s2/puente-zaun.webp"])
	return "res://assets/lugares/" + opciones[clampi(parte, 1, 2) - 1]
