extends "res://escenas/juego/minijuegos/minijuego.gd"

# El archivo (diseño: minijuegos_capturas/mj_archivo.jpg; Nina lo quiere tal cual).
# Une con hilo rojo las pistas que cuentan la misma historia. Una conexión falsa resta tiempo.
# Al cerrar el caso, eliges a quién acusar.

const LIMITE := 180.0

# Fotos y notas del tablón, en las posiciones del diseño.
const PISTAS := [
	{"id": "lab3", "tipo": "foto", "texto": "Laboratorio 3", "p": Vector2(399, 260), "img": "res://assets/lugares/s1/piltover.webp", "giro": -0.06},
	{"id": "puesto", "tipo": "foto", "texto": "Puesto del puente", "p": Vector2(740, 230), "img": "res://assets/lugares/s1/puente.webp", "giro": 0.04},
	{"id": "fabrica", "tipo": "foto", "texto": "Fábrica de Silco", "p": Vector2(1070, 285), "img": "res://assets/lugares/s1/fabrica.webp", "giro": -0.03},
	{"id": "stillwater", "tipo": "foto", "texto": "Stillwater", "p": Vector2(473, 535), "img": "res://assets/lugares/s1/stillwater.webp", "giro": 0.03},
	{"id": "mercado", "tipo": "foto", "texto": "Mercado de Zaun", "p": Vector2(1145, 563), "img": "res://assets/lugares/s1/mercado.webp", "giro": -0.04},
	{"id": "brillo", "tipo": "nota", "texto": "Brillo: restos en\nel laboratorio 3", "p": Vector2(588, 358), "color": Color("#e3efff"), "giro": 0.02},
	{"id": "pago", "tipo": "nota", "texto": "Pago semanal\n«S.» — 400 piezas", "p": Vector2(798, 438), "color": Color("#fff6c0"), "giro": -0.03},
	{"id": "pase", "tipo": "nota", "texto": "¿Quién firmó el\npase del puente?", "p": Vector2(818, 630), "color": Color("#ffe1e4"), "giro": 0.0},
]
# Conexiones que cuentan la misma historia (los hilos del diseño).
const BUENAS := [["lab3", "brillo"], ["puesto", "pago"], ["fabrica", "pago"], ["stillwater", "pase"], ["mercado", "pase"], ["fabrica", "mercado"]]
const SOSPECHOSOS := ["Silco", "Singed", "Sevika"]
const CULPABLE := "Silco"

var hilos: Array = []
var vistas: Array = []
var arrastre := ""
var penalizacion := 0.0
var aviso := ""
var aviso_t := 0.0
var acusando := false

func _configurar() -> void:
	nombre = "El archivo"
	subtitulo = "Academia y comisaría · Ingenio"
	ciudad = "Piltover"
	estadistica = "ingenio"
	con_quien = ["caitlyn", "heimerdinger"]
	oscurecer = 1.0
	como_se_juega = "Une con hilo rojo las pistas que cuentan la misma historia. Una conexión falsa resta tiempo. Al cerrar el caso, eliges a quién acusar."
	teclas = [["CLIC", "coger pista"], ["ARRASTRAR", "tender el hilo"], ["LUPA", "examinar"]]
	instrucciones = como_se_juega + "\n\nHaz clic en una pista para examinarla con la lupa. Arrastra de una pista a otra para tender el hilo: si no cuentan la misma historia, pierdes 15 segundos. Con las seis conexiones hechas, cierras el caso y acusas."

func _empezar() -> void:
	hilos = []
	vistas = []
	penalizacion = 0.0
	acusando = false

func _restante() -> float:
	return LIMITE - tiempo - penalizacion

func _actualizar(delta: float) -> void:
	aviso_t -= delta
	if _restante() <= 0.0 and not acusando:
		acabar(false, "Se ha acabado el tiempo y el caso sigue abierto.")

func _rect(p: Dictionary) -> Rect2:
	if p["tipo"] == "foto":
		return Rect2(p["p"] - Vector2(105, 95), Vector2(210, 195))
	return Rect2(p["p"] - Vector2(92, 36), Vector2(184, 72))

func _pista_en(pos: Vector2) -> String:
	for i in range(PISTAS.size() - 1, -1, -1):
		if _rect(PISTAS[i]).has_point(pos):
			return PISTAS[i]["id"]
	return ""

func _pista(id_p: String) -> Dictionary:
	for p in PISTAS:
		if p["id"] == id_p:
			return p
	return {}

func _entrada_raton(e: InputEvent) -> void:
	if acusando or not e is InputEventMouseButton or e.button_index != MOUSE_BUTTON_LEFT:
		return
	var sobre := _pista_en(e.position)
	if e.pressed:
		arrastre = sobre
		if sobre != "" and not sobre in vistas:
			vistas.append(sobre)
	else:
		if arrastre != "" and sobre != "" and sobre != arrastre:
			_unir(arrastre, sobre)
		arrastre = ""

func _unir(a: String, b: String) -> void:
	for h in hilos:
		if (h[0] == a and h[1] == b) or (h[0] == b and h[1] == a):
			return
	var buena := false
	for par in BUENAS:
		if (par[0] == a and par[1] == b) or (par[0] == b and par[1] == a):
			buena = true
	if buena:
		hilos.append([a, b])
		puntos += 50
		_avisar("Estas pistas cuentan la misma historia")
		if hilos.size() == BUENAS.size():
			_acusar()
	else:
		penalizacion += 15.0
		_avisar("Conexión falsa: −15 s")

func _acusar() -> void:
	acusando = true
	jugando = false
	_mensaje("Cerrar el caso", "Todas las pistas están unidas. ¿A quién acusas?", "Volver al tablón", func():
		acusando = false
		jugando = true)

func _opciones_mensaje(col: VBoxContainer) -> void:
	if not acusando:
		return
	var fila := HBoxContainer.new()
	fila.alignment = BoxContainer.ALIGNMENT_CENTER
	fila.add_theme_constant_override("separation", 12)
	col.add_child(fila)
	for s in SOSPECHOSOS:
		var b := Estilo.boton(s, 160)
		b.pressed.connect(func():
			if panel_mensaje:
				panel_mensaje.queue_free()
				panel_mensaje = null
			acusando = false
			jugando = true
			var acierto: bool = s == CULPABLE
			if acierto:
				puntos += int(_restante())
			acabar(acierto, "Has acusado a %s. %s" % [s, "Las pistas le señalan." if acierto else "Las pistas no le señalan."]))
		fila.add_child(b)

func _avisar(t: String) -> void:
	aviso = t
	aviso_t = 1.4

func _chips() -> Array:
	return [["PISTAS %d / 6" % mini(vistas.size(), 6)], ["CONEXIONES %d" % hilos.size(), true], [reloj(_restante())]]

func _dibujar() -> void:
	# Pared y tablón de corcho.
	draw_rect(Rect2(0, 92, 1600, 690), Color("#6b4524"))
	draw_rect(Rect2(202, 109, 1196, 672), Color("#3a2614"))
	draw_rect(Rect2(216, 123, 1168, 644), Color("#8a5a30"))
	for k in 60:
		var y := 130 + k * 10.7
		draw_line(Vector2(216, y), Vector2(1384, y + 4), Color(0, 0, 0, 0.04), 1)
	# Hilos.
	for h in hilos:
		draw_line(_pista(h[0])["p"], _pista(h[1])["p"], Color("#c0303a"), 2.5)
	if arrastre != "":
		draw_line(_pista(arrastre)["p"], raton(), Color("#c0303a", 0.7), 2)
	# Pistas.
	for p in PISTAS:
		var r := _rect(p)
		draw_set_transform(_desplazamiento + p["p"] * _escala, p["giro"], Vector2(_escala, _escala))
		var local := Rect2(r.position - p["p"], r.size)
		draw_rect(Rect2(local.position + Vector2(4, 6), local.size), Color(0, 0, 0, 0.3))
		if p["tipo"] == "foto":
			draw_rect(local, Color("#f2ead8"))
			imagen(cargar(p["img"]), Rect2(local.position + Vector2(10, 10), Vector2(190, 135)), Color(0.85, 0.85, 0.85))
			texto(Vector2(0, local.end.y - 18), p["texto"], 15, Color("#3a2a1a"), "cinzel", 1)
			draw_circle(Vector2(0, local.position.y + 4), 9, Color("#c0303a"))
		else:
			draw_rect(local, p["color"])
			parrafo(Rect2(local.position + Vector2(14, 12), local.size - Vector2(20, 10)), p["texto"], 16, Color("#1a1a1a"))
			draw_circle(Vector2(0, local.position.y + 2), 8, Color("#1f3550"))
		draw_set_transform(_desplazamiento, 0.0, Vector2(_escala, _escala))
	# Lupa.
	var m := raton()
	if Rect2(216, 123, 1168, 644).has_point(m):
		draw_circle(m, 56, Color(1, 1, 1, 0.08))
		draw_arc(m, 56, 0, TAU, 48, Color("#d9b25f"), 9)
		draw_line(m + Vector2(40, 40), m + Vector2(108, 108), Color("#3a2614"), 14)
	if aviso_t > 0.0:
		texto(Vector2(800, 760), aviso, 22, Color(MARFIL, clampf(aviso_t, 0, 1)), "titulo", 1)
