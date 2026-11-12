extends Node

# Lleva por dónde va la partida: parte, capítulo, decisiones y récords.

const CAPITULOS_POR_PARTE := 15

var parte: int = 1
var capitulo: int = 1
# Lugar del mapa 3D donde está el jugador (clave de Mapa.PARADAS).
var lugar_actual: String = "Puente"
# Decisiones tomadas: { "c1": 0, "c2": 1, ... } (índice de la opción).
var decisiones: Dictionary = {}
# Mejor puntuación de cada minijuego.
var records: Dictionary = {}
# Segundos jugados.
var tiempo_jugado: float = 0.0
# Pantallas de ayuda que ya se han visto.
var tutoriales_vistos: Array = []
var prologo_visto: bool = false
var juego_terminado: bool = false
# Ranura de guardado en uso (1 a 3; 0 = ninguna todavía).
var ranura: int = 0

func _process(delta: float) -> void:
	if not get_tree().paused:
		tiempo_jugado += delta

# Número de capítulo contando las dos partes (1 a 30).
func capitulo_global() -> int:
	return (parte - 1) * CAPITULOS_POR_PARTE + capitulo

# Pasa al capítulo siguiente. Devuelve false si ya no quedan.
func avanzar_capitulo() -> bool:
	if capitulo < CAPITULOS_POR_PARTE:
		capitulo += 1
		return true
	if parte == 1:
		parte = 2
		capitulo = 1
		return true
	juego_terminado = true
	return false

# Cambia la afinidad con un personaje, entre -100 y 100.
func cambiar_afinidad(personaje: String, cantidad: int) -> void:
	var actual: int = int(DatosPartida.afinidades.get(personaje, 0))
	DatosPartida.afinidades[personaje] = clampi(actual + cantidad, -100, 100)

func afinidad(personaje: String) -> int:
	return int(DatosPartida.afinidades.get(personaje, 0))

func reiniciar() -> void:
	parte = 1
	capitulo = 1
	lugar_actual = "Puente"
	decisiones = {}
	records = {}
	tiempo_jugado = 0.0
	tutoriales_vistos = []
	prologo_visto = false
	juego_terminado = false
	ranura = 0

func a_diccionario() -> Dictionary:
	return {
		"parte": parte, "capitulo": capitulo, "lugar_actual": lugar_actual,
		"decisiones": decisiones, "records": records, "tiempo_jugado": tiempo_jugado,
		"tutoriales_vistos": tutoriales_vistos, "prologo_visto": prologo_visto,
		"juego_terminado": juego_terminado,
	}

func desde_diccionario(d: Dictionary) -> void:
	parte = int(d.get("parte", 1))
	capitulo = int(d.get("capitulo", 1))
	lugar_actual = str(d.get("lugar_actual", "Puente"))
	decisiones = d.get("decisiones", {})
	records = d.get("records", {})
	tiempo_jugado = float(d.get("tiempo_jugado", 0.0))
	tutoriales_vistos = d.get("tutoriales_vistos", [])
	prologo_visto = bool(d.get("prologo_visto", false))
	juego_terminado = bool(d.get("juego_terminado", false))

# Texto tipo «3 h 12 min».
func tiempo_texto(segundos: float = -1.0) -> String:
	var s := tiempo_jugado if segundos < 0.0 else segundos
	var minutos := int(s / 60.0)
	return "%d h %02d min" % [minutos / 60, minutos % 60]
