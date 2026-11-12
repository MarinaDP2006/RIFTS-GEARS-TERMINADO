extends RefCounted
# Listas de opciones: la pantalla crea un botón por cada opción de estas listas.

# Máximo de rasgos y aficiones que se pueden elegir.
const MAX_RASGOS := 5
const MAX_AFICIONES := 4

# Nombres de las cuatro estadísticas.
const ESTADISTICAS := {"ingenio": "Ingenio","carisma": "Carisma","valor": "Valor","sigilo": "Sigilo"}

# Nombres de los géneros para la ficha final.
const GENEROS := {	"mujer": "Mujer", "hombre": "Hombre"}

# Opciones de "Tus padres"; {g:o|a} cambia según el género: hombre o mujer.
const PADRES := [
	{ "id": "ambos", "texto": "Tengo a mis padres" },
	{ "id": "madre", "texto": "Solo tengo a mi madre" },
	{ "id": "padre", "texto": "Solo tengo a mi padre" },
	{ "id": "ninguno", "texto": "Huérfan{g:o|a}, sin familia" }]

# Opciones de "Te atraen".
const ATRACCIONES := [
	{ "id": "hombres", "texto": "Hombres" },
	{ "id": "mujeres", "texto": "Mujeres" },
	{ "id": "todos", "texto": "Ambos" },
	{ "id": "nadie", "texto": "Nadie" }]

# Listas de cada ciudad; "stats" suma puntos y "falta_familia" pide no tener a los dos padres.
const CIUDADES := {
	"Zaun": {
		# Vínculos familiares de Zaun.
		"familias": [
			{
				"id": "ninguna", "texto": "Ninguna",
				"descripcion": "Nadie te conoce: cada primer encuentro de la historia es de verdad el primero.",
			},
			# Personajes importantes.
			{
				"id": "vander", "texto": "Hij{g:o|a} adoptiv{g:o|a} de Vander", "stats": { "valor": 1 }, "falta_familia": true,
				"descripcion": "Vander te crio como a su propi{g:o|a} hij{g:o|a}. Vi y tú os consideráis familia. Con tu familia nunca hay romance.",
				"afinidad": { "vander": 3, "vi": 2, "jinx": 1 },
			},
			{
				"id": "silco", "texto": "Hij{g:o|a} de Silco", "stats": { "ingenio": 1, "sigilo": 1 }, "falta_familia": true,
				"descripcion": "Silco te crio y te considera parte de su legado. Creciste cerca de Jinx. Con tu familia nunca hay romance.",
				"afinidad": { "silco": 3, "jinx": 1 },
			},
			{
				"id": "viktor", "texto": "Herman{g:o|a} de Viktor", "stats": { "ingenio": 2 },
				"descripcion": "Tu vínculo cambia su confianza y sus decisiones. Jayce Talis te aprecia. Con tu familia nunca hay romance.",
				"afinidad": { "viktor": 3, "jayce": 1 },
			},
			{
				"id": "prima_vi", "texto": "Prim{g:o|a} de Vi y Powder", "stats": { "valor": 2 },
				"descripcion": "Compartiste con ellas las calles de los Callejones. Con tu familia nunca hay romance.",
				"afinidad": { "vi": 3, "jinx": 2 },
			},
			{
				"id": "primo_ekko", "texto": "Prim{g:o|a} de Ekko", "stats": { "sigilo": 2 },
				"descripcion": "Conoces a Ekko desde niño y sabes moverte entre las Luciérnagas. Con tu familia nunca hay romance.",
				"afinidad": { "ekko": 3 },
			},
			{
				"id": "sevika", "texto": "Hij{g:o|a} de Sevika", "stats": { "valor": 1, "sigilo": 1 },
				"descripcion": "Creciste con la mano derecha de Silco: aprendiste pronto a no bajar la guardia. Con tu familia nunca hay romance.",
				"afinidad": { "sevika": 3, "silco": 1 },
			},
			# Personajes secundarios.
			{
				"id": "benzo", "texto": "Sobrin{g:o|a} de Benzo", "stats": { "carisma": 1, "ingenio": 1 },
				"descripcion": "Creciste entre los trueques de su tienda. Vander y Ekko te conocen. Con tu familia nunca hay romance.",
				"afinidad": { "benzo": 3, "ekko": 1, "vander": 1 },
			},
			{
				"id": "singed", "texto": "Sobrin{g:o|a} de Singed", "stats": { "ingenio": 2 },
				"descripcion": "Te asomaste de pequeñ{g:o|a} a su laboratorio y no has olvidado lo que viste. Con tu familia nunca hay romance.",
				"afinidad": { "singed": 3 },
			},
			{
				"id": "finn", "texto": "Sobrin{g:o|a} de Finn", "stats": { "carisma": 1, "sigilo": 1 },
				"descripcion": "Tu tío es un químbarón: abre puertas y también te gana enemigos. Con tu familia nunca hay romance.",
				"afinidad": { "finn": 3, "silco": 1 },
			},
		],
		# Lugares de procedencia de Zaun.
		"distritos": [
			# Barrios.
			{ "id": "callejones", "texto": "Los Callejones" },
			{ "id": "sumidero", "texto": "El Sumidero" },
			{ "id": "entresuelo", "texto": "Las Fábricas de Entresuelo" },
			{ "id": "tuberias", "texto": "El Mercado de las Tuberías" },
			{ "id": "chimeneas", "texto": "Barrio de las Chimeneas" },
			# Sitios donde alguien puede vivir.
			{ "id": "ultima_gota", "texto": "La Última Gota" },
			{ "id": "luciernagas", "texto": "Refugio de las Luciérnagas" },
			{ "id": "tienda_benzo", "texto": "La tienda de Benzo" },
		],
		# Ocupaciones de Zaun.
		"ocupaciones": [
			{ "id": "mecanico", "texto": "Mecánic{g:o|a} de quimtec", "stats": { "ingenio": 2 } },
			{ "id": "contrabandista", "texto": "Contrabandista", "stats": { "sigilo": 2 } },
			{ "id": "luchador", "texto": "Luchad{g:or|ora} de foso", "stats": { "valor": 2 } },
			{ "id": "tabernero", "texto": "Taberner{g:o|a} de La Última Gota", "stats": { "carisma": 2 } },
			{ "id": "medico", "texto": "Médic{g:o|a} clandestin{g:o|a}", "stats": { "ingenio": 1, "carisma": 1 } },
			{ "id": "mensajero", "texto": "Mensajer{g:o|a} de los químbarones", "stats": { "sigilo": 1, "valor": 1 } },
			{ "id": "quimico", "texto": "Químic{g:o|a} aprendiz", "stats": { "ingenio": 2 } },
		],
	},
	"Piltover": {
		# Vínculos familiares de Piltover.
		"familias": [
			{
				"id": "ninguna", "texto": "Ninguna",
				"descripcion": "Nadie te conoce: cada primer encuentro de la historia es de verdad el primero.",
			},
			# Personajes importantes.
			{
				"id": "jayce", "texto": "Herman{g:o|a} de Jayce Talis", "stats": { "carisma": 1 },
				"descripcion": "Compartís el peso del apellido Talis. Con tu familia nunca hay romance.",
				"afinidad": { "jayce": 3 },
			},
			{
				"id": "mel", "texto": "Herman{g:o|a} de Mel Medarda", "stats": { "carisma": 2 },
				"descripcion": "Conoces desde dentro la presión política de los Medarda. Ambessa te aprecia. Con tu familia nunca hay romance.",
				"afinidad": { "mel": 3, "ambessa": 1 },
			},
			{
				"id": "primo_caitlyn", "texto": "Prim{g:o|a} de Caitlyn Kiramman", "stats": { "carisma": 1, "valor": 1 },
				"descripcion": "Creciste en la órbita de la casa Kiramman. Cassandra te vigila de cerca. Con tu familia nunca hay romance.",
				"afinidad": { "caitlyn": 3, "cassandra": 1 },
			},
			{
				"id": "heimerdinger", "texto": "Ahijad{g:o|a} de Heimerdinger", "stats": { "ingenio": 2 }, "falta_familia": true,
				"descripcion": "El decano te acogió y te enseñó a pensar con paciencia. Viktor te conoce de la Academia. Con tu familia nunca hay romance.",
				"afinidad": { "heimerdinger": 3, "viktor": 1 },
			},
			{
				"id": "ambessa", "texto": "Pupil{g:o|a} de Ambessa Medarda", "stats": { "valor": 2 }, "falta_familia": true,
				"descripcion": "Ambessa te adiestró como a una más de los suyos. Mel desconfía de lo que has aprendido. Con tu familia nunca hay romance.",
				"afinidad": { "ambessa": 3, "mel": 1 },
			},
			# Personajes secundarios.
			{
				"id": "maddie", "texto": "Herman{g:o|a} de Maddie Nolen", "stats": { "valor": 1, "sigilo": 1 },
				"descripcion": "Conoces a los ejecutores desde dentro gracias a Maddie. Con tu familia nunca hay romance.",
				"afinidad": { "maddie": 3, "caitlyn": 1 },
			},
			{
				"id": "salo", "texto": "Hij{g:o|a} del consejero Salo", "stats": { "carisma": 2 },
				"descripcion": "Creciste oyendo cómo se pactan las votaciones del Consejo. Con tu familia nunca hay romance.",
				"afinidad": { "salo": 3, "cassandra": 1 },
			},
			{
				"id": "shoola", "texto": "Sobrin{g:o|a} de la consejera Shoola", "stats": { "carisma": 1, "ingenio": 1 },
				"descripcion": "Tu tía te abrió las puertas de los salones de Piltover. Con tu familia nunca hay romance.",
				"afinidad": { "shoola": 3, "mel": 1 },
			},
			{
				"id": "marcus", "texto": "Sobrin{g:o|a} de Marcus", "stats": { "sigilo": 2 },
				"descripcion": "Tu tío manda a los ejecutores y sabes lo que esconde su uniforme. Con tu familia nunca hay romance.",
				"afinidad": { "marcus": 3 },
			},
		],
		# Lugares de procedencia de Piltover.
		"distritos": [
			# Barrios.
			{ "id": "academico", "texto": "Barrio Académico" },
			{ "id": "consejo", "texto": "Distrito del Consejo" },
			{ "id": "terrazas", "texto": "Las Terrazas Kiramman" },
			{ "id": "artesanos", "texto": "Barrio de los Artesanos" },
			{ "id": "hexpuertas", "texto": "Los Muelles de las Hexpuertas" },
			# Sitios donde alguien puede vivir.
			{ "id": "academia", "texto": "Academia de Piltover" },
			{ "id": "mansion_kiramman", "texto": "Mansión Kiramman" },
		],
		# Ocupaciones de Piltover.
		"ocupaciones": [
			{ "id": "estudiante", "texto": "Estudiante de la Academia", "stats": { "ingenio": 2 } },
			{ "id": "ejecutor", "texto": "Ejecut{g:or|ora} novat{g:o|a}", "stats": { "valor": 2 } },
			{ "id": "comerciante", "texto": "Comerciante de los muelles", "stats": { "carisma": 2 } },
			{ "id": "inventor", "texto": "Invent{g:or|ora} independiente", "stats": { "ingenio": 1, "valor": 1 } },
			{ "id": "periodista", "texto": "Periodista de sociedad", "stats": { "carisma": 1, "sigilo": 1 } },
			{ "id": "artista", "texto": "Artista de los salones", "stats": { "carisma": 2 } },
			{ "id": "detective", "texto": "Detective privad{g:o|a}", "stats": { "sigilo": 2 } },
		],
	},}

# Rasgos de personalidad (iguales en las dos ciudades).
const RASGOS := [
	{ "id": "leal", "texto": "Leal" },
	{ "id": "ambicioso", "texto": "Ambicios{g:o|a}" },
	{ "id": "curioso", "texto": "Curios{g:o|a}" },
	{ "id": "impulsivo", "texto": "Impulsiv{g:o|a}" },
	{ "id": "prudente", "texto": "Prudente" },
	{ "id": "compasivo", "texto": "Compasiv{g:o|a}" },
	{ "id": "desconfiado", "texto": "Desconfiad{g:o|a}" },
	{ "id": "orgulloso", "texto": "Orgullos{g:o|a}" },
	{ "id": "ingenioso", "texto": "Ingenios{g:o|a}" },
	{ "id": "rebelde", "texto": "Rebelde" },
	{ "id": "disciplinado", "texto": "Disciplinad{g:o|a}" },
	{ "id": "sonador", "texto": "Soñad{g:or|ora}" }]

# Aficiones (iguales en las dos ciudades).
const AFICIONES := [
	{ "id": "inventar", "texto": "Inventar cachivaches", "stats": { "ingenio": 1 } },
	{ "id": "pelear", "texto": "Peleas clandestinas", "stats": { "valor": 1 } },
	{ "id": "grafiti", "texto": "Grafiti y pintura", "stats": { "sigilo": 1 } },
	{ "id": "musica", "texto": "Música", "stats": { "carisma": 1 } },
	{ "id": "leer", "texto": "Leer en la biblioteca", "stats": { "ingenio": 1 } },
	{ "id": "tiro", "texto": "Tiro al blanco", "stats": { "valor": 1 } },
	{ "id": "cartas", "texto": "Jugar a las cartas", "stats": { "carisma": 1 } },
	{ "id": "tejados", "texto": "Correr por los tejados", "stats": { "sigilo": 1 } },
	{ "id": "cocina", "texto": "Cocinar", "stats": { "carisma": 1 } },
	{ "id": "aerotabla", "texto": "Aerotabla", "stats": { "valor": 1 } }]

# Devuelve las listas de la ciudad elegida.
static func de_ciudad(ciudad: String) -> Dictionary:
	return CIUDADES.get(ciudad, CIUDADES["Piltover"])
