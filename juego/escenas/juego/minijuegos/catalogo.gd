extends RefCounted

# Los 10 minijuegos, 5 por ciudad, con los datos de la guía de Nina
# (RiftsAndGears_Guia_Mundo_y_Mapas.pdf, capítulo 15: «Minijuegos: 5 por ciudad»).

const ORDEN := ["cristal", "tiro", "consejo", "archivo", "gala", "foso", "aerotabla", "grafiti", "mezclas", "cartas"]

const DATOS := {
	"cristal": {"nombre": "Calibrar el cristal", "ciudad": "Piltover", "lugar": "Taller de Jayce", "sube": "Ingenio",
		"con": "Jayce, Viktor", "aficion": "inventar cachivaches",
		"texto": "Girar anillos de runas hasta alinear la muesca con la línea de energía sin que el cristal se caliente. En la historia: el primer portal con Jayce y Viktor. Premio: piezas hextech."},
	"tiro": {"nombre": "Tiro de precisión", "ciudad": "Piltover", "lugar": "Jardines Kiramman", "sube": "Valor",
		"con": "Caitlyn", "aficion": "tiro al blanco",
		"texto": "Mira que se mece con la respiración; contener el aire la fija unos segundos. Viento y dianas lejanas. Relación: rondas limpias suben la confianza de Caitlyn."},
	"consejo": {"nombre": "Debate del Consejo", "ciudad": "Piltover", "lugar": "Sala del Consejo", "sube": "Carisma",
		"con": "Mel, Cassandra, Salo, Shoola, Heimerdinger, Jayce, Ambessa", "aficion": "debatir",
		"texto": "Juegas cartas de argumento (lógica, progreso, tradición, emoción, presión) para ganar votos. En la historia: cambia leyes del mundo. Usar la presión baja la confianza de quien la sufre."},
	"archivo": {"nombre": "El archivo", "ciudad": "Piltover", "lugar": "Academia y comisaría", "sube": "Ingenio",
		"con": "Caitlyn, Heimerdinger", "aficion": "leer en la biblioteca",
		"texto": "Tablón de pistas: unir con hilo rojo las que cuentan la misma historia y acusar al final. En la historia: los casos de Caitlyn y el rastro del brillo."},
	"gala": {"nombre": "Baile de gala", "ciudad": "Piltover", "lugar": "Gala del Día del Progreso", "sube": "Carisma",
		"con": "Tu pareja de baile", "aficion": "música y baile",
		"texto": "Juego de ritmo bajo arcos art déco. Eliges pareja entre quien ya te aprecia, y la música cambia con ella. Relación: sube el afecto o la amistad de tu pareja de baile."},
	"foso": {"nombre": "El foso", "ciudad": "Zaun", "lugar": "Bajo La Última Gota", "sube": "Valor",
		"con": "Vi, Sevika", "aficion": "peleas clandestinas",
		"texto": "Peleas por turnos de reflejos: leer el gesto del rival y golpear, esquivar o bloquear cuando el aro se cierra. Relación: Vi te respeta si ganas limpio y Sevika, si ganas como sea."},
	"aerotabla": {"nombre": "Carrera de aerotabla", "ciudad": "Zaun", "lugar": "Tejados de los Callejones", "sube": "Sigilo",
		"con": "Ekko y las Luciérnagas", "aficion": "aerotabla",
		"texto": "Corres de lado por tuberías y tejados saltando el gas, contra el tiempo fantasma de Ekko. Premio: atajos entre niveles en el mapa 3D. Ganarle sube su amistad."},
	"grafiti": {"nombre": "Grafiti", "ciudad": "Zaun", "lugar": "Muro del puesto de ejecutores", "sube": "Sigilo",
		"con": "Jinx", "aficion": "grafiti y pintura",
		"texto": "Rellenar la plantilla con aerosol y esconderse cuando pasa el foco de la patrulla. Mundo: tus murales quedan pintados en Zaun. A Jinx le encantan; los ejecutores desconfían de ti."},
	"mezclas": {"nombre": "Mezclas de quimtec", "ciudad": "Zaun", "lugar": "Laboratorio del Sumidero", "sube": "Ingenio",
		"con": "Singed (Parte 1), Viktor (Parte 2)", "aficion": "cocinar / química",
		"texto": "Verter gotas de cada vial hasta igualar el color del encargo sin que la presión llegue al rojo. En la historia: encargos de Singed (Parte 1) o curas en la comuna de Viktor (Parte 2)."},
	"cartas": {"nombre": "Cartas en La Última Gota", "ciudad": "Zaun", "lugar": "La mesa del fondo", "sube": "Carisma",
		"con": "Vander, Sevika, Benzo", "aficion": "jugar a las cartas",
		"texto": "Baraja de Zaun (engranaje, gota, llama y calavera). Apuestas con chapas y faroleas; cada rival tiene un tic que lo delata. Mundo: los rumores de la mesa abren pistas de misión."},
}

static func de_ciudad(ciudad: String) -> Array:
	return ORDEN.filter(func(i): return DATOS[i]["ciudad"] == ciudad)

static func captura(id: String) -> String:
	return "res://assets/minijuegos/capturas/mj_%s.jpg" % id

static func crear(id: String) -> Control:
	var ruta := "res://escenas/juego/minijuegos/mj_%s.gd" % id
	if not ResourceLoader.exists(ruta):
		push_warning("No existe el minijuego " + id)
		return null
	var juego: Control = (load(ruta) as GDScript).new()
	juego.id = id
	return juego
