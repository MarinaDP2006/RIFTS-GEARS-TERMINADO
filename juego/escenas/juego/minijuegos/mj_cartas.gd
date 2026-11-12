extends "res://escenas/juego/minijuegos/minijuego.gd"

# Cartas en La Última Gota (diseño: minijuegos_capturas/mj_cartas.jpg; Nina lo quiere tal cual).
# Baraja de Zaun con cuatro palos: engranaje, gota, llama y calavera. Apuestas, subes o te
# retiras. El farol depende de tu Carisma, y cada rival tiene un «tic» que lo delata.
# En la mesa del diseño: Vander, Sevika y Benzo.

const PALOS := ["engranaje", "gota", "llama", "calavera"]
const VALORES := ["2", "3", "4", "5", "6", "7", "8", "9", "10", "R"]
const MANOS := 7
const APUESTA := 4
const SUBIDA := 8

# Rivales: posición, y la frase con la que se delatan cuando van de farol o tienen mala mano.
const RIVALES := [
	{"id": "vander", "p": Vector2(395, 205), "tic": "«Ese farol se te nota en las orejas, chaval.»", "farol": "(Se rasca la barba sin mirarte.)", "fuera": "«Me retiro. Hoy no es mi noche.»"},
	{"id": "sevika", "p": Vector2(809, 168), "tic": "«Subo. Y no parpadees.»", "farol": "(Tamborilea con el brazo de metal.)", "fuera": "«Tsk. Me retiro.»"},
	{"id": "benzo", "p": Vector2(1222, 205), "tic": "«Yo me retiro… esta vez.»", "farol": "(Se ajusta el sombrero dos veces.)", "fuera": "«Yo me retiro… esta vez.»"},
]

var mano := 1
var chapas := 30
var bote := 0
var mesa: Array = []
var tuyas: Array = []
var rivales_cartas: Array = []
var fuerza_rival: Array = []
var frases: Array = ["", "", ""]
var retirados: Array = [false, false, false]
var mostrar := false
var aviso := ""
var aviso_t := 0.0
var ganadas_sevika := 0

func _configurar() -> void:
	nombre = "Cartas en La Última Gota"
	subtitulo = "La mesa del fondo · Carisma"
	ciudad = "Zaun"
	estadistica = "carisma"
	fondo_ruta = "res://assets/lugares/s1/zaun-ultima-gota-bar.jpg"
	oscurecer = 0.7
	como_se_juega = "Baraja de Zaun con cuatro palos: engranaje, gota, llama y calavera. Apuestas, subes o te retiras. El farol depende de tu Carisma, y cada rival tiene un «tic» que lo delata."
	teclas = [["A", "apostar"], ["S", "subir"], ["D", "retirarse"], ["F", "farol"]]
	instrucciones = como_se_juega + "\n\nCada mano tienes tres cartas y hay tres en la mesa. Gana la mejor combinación: trío, color (tres del mismo palo), pareja o la carta más alta. Si un rival hace su gesto, es que su mano es floja. El farol hace que se retiren: cuanto más Carisma, más fácil. Se juegan siete manos; acabas ganando si tienes más chapas que al empezar."

func _empezar() -> void:
	mano = 1
	chapas = 30
	ganadas_sevika = 0
	_repartir()

func _carta() -> Array:
	return [randi() % VALORES.size(), randi() % PALOS.size()]

func _repartir() -> void:
	mesa = [_carta(), _carta(), _carta()]
	tuyas = [_carta(), _carta(), _carta()]
	rivales_cartas = []
	fuerza_rival = []
	for i in 3:
		var c := [_carta(), _carta(), _carta()]
		rivales_cartas.append(c)
		fuerza_rival.append(_fuerza(c + mesa))
	retirados = [false, false, false]
	mostrar = false
	bote = 0
	for i in 3:
		frases[i] = RIVALES[i]["farol"] if fuerza_rival[i] < 200 else ""

# Puntuación de una mano: trío > color > pareja > carta alta.
func _fuerza(cartas: Array) -> int:
	var cuenta := {}
	var palos := {}
	var alta := 0
	for c in cartas:
		cuenta[c[0]] = int(cuenta.get(c[0], 0)) + 1
		palos[c[1]] = int(palos.get(c[1], 0)) + 1
		alta = maxi(alta, c[0])
	var mejor := alta
	for v in cuenta:
		if cuenta[v] >= 3:
			mejor = maxi(mejor, 600 + v)
		elif cuenta[v] == 2:
			mejor = maxi(mejor, 200 + v)
	for p in palos:
		if palos[p] >= 3:
			mejor = maxi(mejor, 400 + alta)
	return mejor

func _actualizar(delta: float) -> void:
	aviso_t -= delta

func _entrada(e: InputEvent) -> void:
	if not (e is InputEventKey and e.pressed and not e.echo):
		return
	if mostrar:
		_siguiente_mano()
		return
	match e.keycode:
		KEY_A: _apostar(APUESTA)
		KEY_S: _apostar(SUBIDA)
		KEY_D:
			_avisar("Te retiras. Pierdes lo apostado.")
			_mostrar_mano(false)
		KEY_F: _farol()

func _apostar(n: int) -> void:
	n = mini(n, chapas)
	chapas -= n
	bote += n
	for i in 3:
		# Con mala mano, el rival se retira si subes.
		if fuerza_rival[i] < 200 and n >= SUBIDA and randf() < 0.6:
			retirados[i] = true
			frases[i] = RIVALES[i]["fuera"]
		else:
			bote += n
	_resolver()

func _farol() -> void:
	var carisma := int(DatosPartida.estadisticas.get("carisma", 0))
	var prob := clampf(0.3 + carisma * 0.08, 0.3, 0.85)
	var n := mini(SUBIDA, chapas)
	chapas -= n
	bote += n
	var todos := true
	for i in 3:
		if randf() < prob or fuerza_rival[i] < 200:
			retirados[i] = true
			frases[i] = RIVALES[i]["fuera"]
		else:
			todos = false
			frases[i] = RIVALES[i]["tic"]
			bote += n
	if todos:
		chapas += bote
		puntos += bote
		_avisar("¡Farol! Todos se retiran: +%d chapas" % bote)
		_mostrar_mano(true)
	else:
		_resolver()

func _resolver() -> void:
	var mia := _fuerza(tuyas + mesa)
	var gano := true
	for i in 3:
		if not retirados[i] and fuerza_rival[i] > mia:
			gano = false
	if gano:
		chapas += bote
		puntos += bote
		if not retirados[1]:
			ganadas_sevika += 1
		_avisar("Ganas la mano: +%d chapas" % bote)
	else:
		_avisar("Pierdes la mano.")
	_mostrar_mano(gano)

func _mostrar_mano(_gano: bool) -> void:
	mostrar = true

func _siguiente_mano() -> void:
	mano += 1
	if mano > MANOS or chapas <= 0:
		mano = mini(mano, MANOS)
		acabar(chapas > 30, "Terminas con %d chapas (empezaste con 30)." % chapas)
		return
	_repartir()

func _premio_extra() -> void:
	if ganadas_sevika > 0:
		Progreso.cambiar_afinidad("sevika", 1)
	Progreso.flags["rumores_ultima_gota"] = true

func _avisar(t: String) -> void:
	aviso = t
	aviso_t = 2.5

func _chips() -> Array:
	return [["MANO %d / %d" % [mano, MANOS]], ["TUS CHAPAS %d" % chapas, true]]

func _dibujar_carta(r: Rect2, c: Array, giro: float = 0.0, oculta: bool = false) -> void:
	draw_set_transform(_desplazamiento + r.get_center() * _escala, giro, Vector2(_escala, _escala))
	var l := Rect2(-r.size / 2.0, r.size)
	draw_rect(Rect2(l.position + Vector2(4, 6), l.size), Color(0, 0, 0, 0.35))
	draw_rect(l, Color("#f1e8d2"))
	if oculta:
		draw_rect(l.grow(-8), Color("#b07a3a"), false, 2)
		draw_circle(Vector2.ZERO, 22, Color("#b07a3a", 0.5))
	else:
		var palo: String = PALOS[c[1]]
		var rojo := palo == "gota" or palo == "llama"
		var col := Color("#c0303a") if rojo else Color("#222222")
		if palo == "llama":
			col = Color("#8a5a10")
		texto(l.position + Vector2(12, 32), VALORES[c[0]], 24, col, "titulo")
		_palo(Vector2(0, 10), palo, col)
	draw_set_transform(_desplazamiento, 0.0, Vector2(_escala, _escala))

func _palo(c: Vector2, palo: String, col: Color) -> void:
	match palo:
		"engranaje":
			draw_arc(c, 16, 0, TAU, 24, col, 3)
			draw_circle(c, 4, col)
			for k in 4:
				var d := Vector2.from_angle(k * PI / 2.0)
				draw_line(c + d * 14, c + d * 22, col, 3)
		"gota":
			draw_colored_polygon(PackedVector2Array([c + Vector2(0, -20), c + Vector2(14, 0), c + Vector2(0, 20), c + Vector2(-14, 0)]), col)
		"llama":
			for k in 12:
				draw_line(c, c + Vector2.from_angle(k * TAU / 12.0) * (20 if k % 2 == 0 else 11), col, 3)
		"calavera":
			draw_circle(c + Vector2(0, -4), 15, col)
			draw_rect(Rect2(c + Vector2(-8, 6), Vector2(16, 10)), col)
			draw_circle(c + Vector2(-6, -5), 4, Color("#f1e8d2"))
			draw_circle(c + Vector2(6, -5), 4, Color("#f1e8d2"))

func _dibujar() -> void:
	# Mesa.
	draw_set_transform(_desplazamiento + Vector2(800, 580) * _escala, 0.0, Vector2(_escala * 1.0, _escala * 0.58))
	draw_circle(Vector2.ZERO, 590, Color("#5a3a1e"))
	draw_circle(Vector2.ZERO, 572, Color("#3d2512"))
	draw_set_transform(_desplazamiento, 0.0, Vector2(_escala, _escala))
	# Rivales.
	for i in 3:
		var r: Dictionary = RIVALES[i]
		var col := Color(0.4, 0.4, 0.4) if retirados[i] else Z_SHIMMER
		retrato(r["id"], r["p"], 47, col)
		var frase: String = frases[i]
		if frase != "":
			var ancho := 200.0
			var caja := Rect2(r["p"].x - ancho / 2.0, r["p"].y + 58, ancho, 50)
			draw_rect(caja, Color(0.06, 0.03, 0.08, 0.92))
			draw_rect(caja, Color(Z_SHIMMER, 0.6), false, 1)
			parrafo(Rect2(caja.position + Vector2(8, 6), caja.size - Vector2(16, 6)), frase, 14, MARFIL, "italica", 1)
		if mostrar and not retirados[i]:
			for k in 3:
				_dibujar_carta(Rect2(r["p"] + Vector2(-60 + k * 40, -20), Vector2(36, 52)), rivales_cartas[i][k])
	# Cartas de la mesa.
	draw_rect(Rect2(608, 353, 375, 192), Color(0, 0, 0, 0.0))
	var x := 608.0
	while x < 983:
		draw_line(Vector2(x, 353), Vector2(minf(x + 8, 983), 353), Color(P_ORO, 0.6), 1.5)
		draw_line(Vector2(x, 545), Vector2(minf(x + 8, 983), 545), Color(P_ORO, 0.6), 1.5)
		x += 14
	for k in 3:
		_dibujar_carta(Rect2(637 + k * 110, 378, 96, 142), mesa[k])
	# Bote.
	for k in 5:
		var cc := Vector2(1018, 410) + Vector2.from_angle(k * 1.3) * 20
		draw_circle(cc, 14, [P_ORO, Z_SHIMMER, Color("#c0303a"), P_ORO, P_HEX][k])
	texto(Vector2(1057, 504), "BOTE · %d CHAPAS" % bote, 18, P_ORO, "titulo")
	# Tus cartas.
	for k in 3:
		_dibujar_carta(Rect2(652 + k * 92, 612, 96, 142), tuyas[k], -0.08 + k * 0.08)
	panel_info(Rect2(1197, 523, 301, 183), "Para qué sirve", ["Sube **Carisma** y ganas chapas.", "Ganar a Sevika le gana respeto. Hacer trampas a Vander, su desconfianza.", "Los rumores que se oyen en la mesa abren pistas de misión."])
	draw_rect(Rect2(1197, 523, 4, 183), Z_ROSA)
	if mostrar:
		texto(Vector2(800, 780 - 10), "Pulsa cualquier tecla para la siguiente mano", 15, Color(MARFIL, 0.8), "texto", 1)
	if aviso_t > 0.0:
		texto(Vector2(400, 470), aviso, 22, Color(MARFIL, clampf(aviso_t, 0, 1)), "titulo", 1)
