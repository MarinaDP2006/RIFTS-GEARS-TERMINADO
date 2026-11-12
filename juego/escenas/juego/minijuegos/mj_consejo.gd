extends "res://escenas/juego/minijuegos/minijuego.gd"

# Debate del Consejo (diseño: minijuegos_capturas/mj_consejo.jpg).
# Elige un argumento y juégalo sobre un consejero. Cada uno cede ante algo distinto:
# Mel ante el progreso, Cassandra ante la tradición, Salo ante la presión.
# Consigue mayoría antes de la ronda 4. Usar PRESIÓN baja la confianza de quien la sufre.

const PROPUESTA := "«Abrir el puente por la noche para los trabajadores de Zaun.»"
const CARTAS := [
	{"id": "logica", "nombre": "LÓGICA", "pie": "Datos y planos", "color": Color("#3fb6e0"), "fondo": Color("#e8f4fb")},
	{"id": "progreso", "nombre": "PROGRESO", "pie": "El futuro de la ciudad", "color": Color("#d9a441"), "fondo": Color("#f8eed6")},
	{"id": "tradicion", "nombre": "TRADICIÓN", "pie": "Lo que dicen las familias", "color": Color("#8a6a2a"), "fondo": Color("#f3ead6")},
	{"id": "emocion", "nombre": "EMOCIÓN", "pie": "Una historia de Zaun", "color": Color("#ff4fa3"), "fondo": Color("#fde6f0")},
	{"id": "presion", "nombre": "PRESIÓN", "pie": "Lo que sabes de ellos", "color": Color("#c0303a"), "fondo": Color("#fbe3e3")},
]
# Consejeros en el arco del diseño: posición, voto inicial (1 a favor, 0 duda, -1 en contra) y su punto débil.
const CONSEJEROS := [
	{"id": "mel", "p": Vector2(338, 505), "voto": 1, "debil": "progreso"},
	{"id": "cassandra", "p": Vector2(434, 372), "voto": 0, "debil": "tradicion"},
	{"id": "salo", "p": Vector2(597, 279), "voto": -1, "debil": "presion"},
	{"id": "heimerdinger", "p": Vector2(800, 247), "voto": 0, "debil": "logica"},
	{"id": "jayce", "p": Vector2(1002, 279), "voto": 1, "debil": "progreso"},
	{"id": "shoola", "p": Vector2(1166, 372), "voto": 0, "debil": "emocion"},
	{"id": "ambessa", "p": Vector2(1262, 505), "voto": -1, "debil": "presion"},
]
const RONDAS := 4
const JUGADAS_POR_RONDA := 2

var votos: Array = []
var ronda := 1
var jugadas := 0
var carta := 0
var aviso := ""
var aviso_t := 0.0
var presionados: Array = []

func _configurar() -> void:
	nombre = "Debate del Consejo"
	subtitulo = "Sala del Consejo · Carisma"
	ciudad = "Piltover"
	estadistica = "carisma"
	fondo_ruta = "res://assets/lugares/s2/consejo.webp"
	oscurecer = 0.45
	como_se_juega = "Elige un argumento y juégalo sobre un consejero. Cada uno cede ante algo distinto: Mel ante el progreso, Cassandra ante la tradición, Salo ante la presión. Consigue mayoría antes de la ronda 4."
	teclas = [["1-5", "elegir argumento"], ["CLIC", "jugar sobre un consejero"], ["R", "releer la propuesta"]]
	instrucciones = como_se_juega + "\n\nEn cada ronda juegas dos argumentos. Si tocas el punto débil de alguien, se acerca a tu postura (en contra → duda → a favor). Si no, puede que dude o que no se mueva. Usar PRESIÓN funciona, pero baja la confianza de quien la sufre. Necesitas 4 votos a favor de 7."

func _empezar() -> void:
	votos = []
	for c in CONSEJEROS:
		votos.append(c["voto"])
	ronda = 1
	jugadas = 0
	carta = 0
	presionados = []

func _actualizar(delta: float) -> void:
	aviso_t -= delta

func _entrada(e: InputEvent) -> void:
	if not (e is InputEventKey and e.pressed and not e.echo):
		return
	if e.keycode >= KEY_1 and e.keycode <= KEY_5:
		carta = e.keycode - KEY_1
	elif e.keycode == KEY_R:
		var seguia := jugando
		jugando = false
		_mensaje("La propuesta", PROPUESTA + "\n\nJuega una carta de argumento por consejero. Cada uno tiene un punto débil: Mel escucha el progreso, Cassandra la tradición, Salo solo cede a la presión.", "Volver", func(): jugando = seguia)

func _entrada_raton(e: InputEvent) -> void:
	if not (e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT):
		return
	for i in 5:
		if _rect_carta(i).has_point(e.position):
			carta = i
			return
	for i in CONSEJEROS.size():
		if e.position.distance_to(CONSEJEROS[i]["p"]) < 56:
			_jugar(i)
			return

func _jugar(i: int) -> void:
	var c: Dictionary = CONSEJEROS[i]
	var arg: String = CARTAS[carta]["id"]
	if votos[i] == 1:
		_avisar("%s ya está a favor" % Historia.nombre(c["id"]))
		return
	if arg == c["debil"]:
		votos[i] += 1
		puntos += 100
		_avisar("%s cede" % Historia.nombre(c["id"]))
	elif randf() < 0.3:
		votos[i] = mini(votos[i] + 1, 0)
		_avisar("%s duda" % Historia.nombre(c["id"]))
	else:
		_avisar("A %s no le convence" % Historia.nombre(c["id"]))
	if arg == "presion":
		Progreso.cambiar_afinidad(c["id"], -1)
		if not c["id"] in presionados:
			presionados.append(c["id"])
	jugadas += 1
	if _a_favor() >= 4:
		acabar(true, "La propuesta sale adelante: %d votos a favor." % _a_favor())
		return
	if jugadas >= JUGADAS_POR_RONDA:
		jugadas = 0
		ronda += 1
		if ronda > RONDAS:
			ronda = RONDAS
			acabar(false, "No has conseguido mayoría: %d a favor." % _a_favor())

func _premio_extra() -> void:
	Progreso.flags["ley_puente_abierto"] = true

func _a_favor() -> int:
	return votos.count(1)

func _avisar(t: String) -> void:
	aviso = t
	aviso_t = 1.4

func _chips() -> Array:
	var rombos := ""
	for k in 4:
		rombos += "◆" if k < 4 - jugadas * 2 else "◇"
	return [["RONDA %d / %d" % [ronda, RONDAS]], ["INFLUENCIA " + rombos, true]]

func _rect_carta(i: int) -> Rect2:
	return Rect2(492 + i * 128, 548 - (36 if i == carta else 0) + absi(i - 2) * 14, 118, 160)

func _dibujar() -> void:
	# Hemiciclo.
	draw_circle(Vector2(800, 745), 350, Color(0.04, 0.08, 0.15, 0.85))
	draw_arc(Vector2(800, 745), 350, PI, TAU, 96, P_ORO, 2)
	texto(Vector2(800, 458), "VOTOS", 17, TEXTO, "titulo", 1)
	var contra := votos.count(-1)
	texto(Vector2(800, 512), "%d - %d" % [_a_favor(), contra], 54, MARFIL, "titulo", 1)
	texto(Vector2(800, 540), "%d DUDAN" % votos.count(0), 16, MARFIL, "titulo", 1)
	# Consejeros.
	for i in CONSEJEROS.size():
		var c: Dictionary = CONSEJEROS[i]
		var col := Color("#7ed957") if votos[i] == 1 else (Color("#ff5a5a") if votos[i] == -1 else P_ORO)
		retrato(c["id"], c["p"], 52, col)
		texto(c["p"] + Vector2(0, 76), Historia.nombre(c["id"]).to_upper(), 17, MARFIL, "titulo", 1)
		texto(c["p"] + Vector2(0, 94), ["EN CONTRA", "DUDA", "A FAVOR"][votos[i] + 1], 12, col, "titulo", 1)
	# Cartas de argumento.
	for i in 5:
		var r := _rect_carta(i)
		var cd: Dictionary = CARTAS[i]
		draw_rect(r, cd["fondo"])
		draw_rect(r.grow(-5), cd["color"], false, 2)
		if i == carta:
			draw_rect(r.grow(3), Color.WHITE, false, 2)
		texto(r.position + Vector2(r.size.x / 2, 34), cd["nombre"], 17, cd["color"], "cinzel", 1)
		var cc := r.position + Vector2(r.size.x / 2, 82)
		draw_colored_polygon(PackedVector2Array([cc + Vector2(0, -22), cc + Vector2(22, 0), cc + Vector2(0, 22), cc + Vector2(-22, 0)]), Color(cd["color"], 0.25))
		draw_circle(cc, 8, cd["color"])
		parrafo(Rect2(r.position.x + 8, r.position.y + 112, r.size.x - 16, 40), cd["pie"], 13, Color("#333333"), "texto", 1)
		texto(r.position + Vector2(10, 18), str(i + 1), 13, Color("#555555"))
	panel(Rect2(101, 128, 275, 212))
	texto(Vector2(123, 170), "LA PROPUESTA", 22, MARFIL, "titulo")
	parrafo(Rect2(123, 180, 238, 150), PROPUESTA + " Juega una carta de argumento por consejero. Cada uno tiene un punto débil: Mel escucha el progreso, Cassandra la tradición, Salo solo cede a la presión.", 15, TEXTO)
	panel_info(Rect2(1224, 128, 275, 216), "Para qué sirve", ["Sube **Carisma**.", "Ganar cambia leyes del mundo: puente abierto, menos ejecutores…", "Usar PRESIÓN baja la confianza de quien la sufre."])
	if aviso_t > 0.0:
		texto(Vector2(800, 420), aviso, 22, Color(MARFIL, clampf(aviso_t, 0, 1)), "titulo", 1)
