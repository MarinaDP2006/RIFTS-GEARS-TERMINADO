extends "res://escenas/juego/minijuegos/minijuego.gd"

# Tiro de precisión (diseño: minijuegos_capturas/mj_tiro.jpg; Nina lo quiere tal cual).
# La mira se mece con la respiración. Mantén el clic derecho para contener el aire: la mira
# se queda quieta unos segundos, pero si aguantas demasiado empieza a temblar.
# El viento desvía la bala: corrígelo. Cinco disparos.

const MIRA_R := 255.0
const DISPAROS := 5

# Dianas: posición y tamaño (las pequeñas y lejanas dan más puntos).
var dianas: Array = []
var disparos := 0
var aire := 1.0
var conteniendo := false
var viento := 0
var fase := 0.0
var marcas: Array = []
var aviso := ""
var aviso_t := 0.0
var fallos := 0

func _configurar() -> void:
	nombre = "Tiro de precisión"
	subtitulo = "Jardines Kiramman · Valor"
	ciudad = "Piltover"
	estadistica = "valor"
	con_quien = ["caitlyn"]
	fondo_ruta = "res://assets/lugares/s2/mansion-kiramman.webp"
	oscurecer = 0.5
	como_se_juega = "Apunta, mantén el clic derecho para contener el aire y estabilizar la mira, y dispara antes de quedarte sin aliento. El viento desvía la bala: corrígelo."
	teclas = [["RATÓN", "apuntar"], ["CLIC DCHO.", "contener el aire"], ["CLIC", "disparar"]]
	instrucciones = como_se_juega + "\n\nTienes cinco disparos. El centro de cada diana vale más y las dianas pequeñas y lejanas dan más puntos. El viento empuja la bala hacia donde marca la flecha: apunta un poco hacia el otro lado. Cada ronda sin fallos sube la confianza de Caitlyn."

func _empezar() -> void:
	dianas = [
		{"p": Vector2(422, 495), "r": 52.0}, {"p": Vector2(617, 432), "r": 36.0}, {"p": Vector2(993, 403), "r": 26.0},
		{"p": Vector2(1196, 468), "r": 44.0}, {"p": Vector2(1345, 497), "r": 28.0},
	]
	disparos = 0
	aire = 1.0
	marcas = []
	fallos = 0
	_nuevo_viento()

func _nuevo_viento() -> void:
	viento = randi_range(-3, 3)

func _actualizar(delta: float) -> void:
	aviso_t -= delta
	fase += delta
	conteniendo = Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and aire > 0.0
	if conteniendo:
		aire = maxf(aire - delta / 4.0, 0.0)
	else:
		aire = minf(aire + delta / 3.0, 1.0)

# Cuánto se mueve la mira ahora mismo.
func _vaiven() -> Vector2:
	if conteniendo and aire > 0.3:
		return Vector2.ZERO
	var fuerza := 22.0
	if conteniendo:
		fuerza = 6.0 + (0.3 - aire) * 60.0   # tiembla al quedarse sin aire
		return Vector2(randf_range(-1, 1), randf_range(-1, 1)) * fuerza
	return Vector2(sin(fase * 1.3) * fuerza, sin(fase * 2.1) * fuerza * 0.6)

func _centro_mira() -> Vector2:
	return raton() + _vaiven()

func _entrada_raton(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
		_disparar()

func _disparar() -> void:
	var impacto := _centro_mira() + Vector2(viento * 9.0, 0)
	disparos += 1
	marcas.append(impacto)
	var mejor := 0
	for d in dianas:
		var dist: float = impacto.distance_to(d["p"])
		if dist <= d["r"]:
			var anillo := 1.0 - dist / float(d["r"])
			var base := 200 if anillo > 0.75 else (120 if anillo > 0.4 else 60)
			mejor = maxi(mejor, int(base * 52.0 / float(d["r"])))
	if mejor > 0:
		puntos += mejor
		_avisar("+%d" % mejor)
	else:
		fallos += 1
		_avisar("Fallo")
	_nuevo_viento()
	if disparos >= DISPAROS:
		var gano := puntos >= 900
		acabar(gano, "Puntos: %d%s" % [puntos, " · ronda sin fallos" if fallos == 0 else ""])

func _premio_extra() -> void:
	if fallos == 0:
		Progreso.cambiar_afinidad("caitlyn", 1)

func _avisar(t: String) -> void:
	aviso = t
	aviso_t = 1.0

func _texto_viento() -> String:
	if viento == 0:
		return "VIENTO 0"
	return "VIENTO %s %d" % ["→" if viento > 0 else "←", absi(viento)]

func _chips() -> Array:
	return [["DISPAROS %d / %d" % [disparos, DISPAROS]], ["PUNTOS %d" % puntos], [_texto_viento(), true]]

func _diana(p: Vector2, r: float, alfa: float) -> void:
	draw_circle(p, r, Color(0.93, 0.89, 0.8, alfa))
	draw_circle(p, r * 0.78, Color(0.1, 0.17, 0.3, alfa))
	draw_circle(p, r * 0.5, Color(0.93, 0.89, 0.8, alfa))
	draw_circle(p, r * 0.26, Color(0.1, 0.17, 0.3, alfa))
	draw_circle(p, r * 0.1, Color(0.85, 0.65, 0.3, alfa))
	draw_line(p + Vector2(0, r), p + Vector2(0, r + 50), Color(0.35, 0.25, 0.15, alfa), 3)

func _dibujar() -> void:
	var c := _centro_mira()
	# Dianas fuera de la mira (apagadas).
	for d in dianas:
		_diana(d["p"], d["r"], 0.45)
	# Fuera de la mira todo queda en penumbra; lo de dentro se ve claro.
	draw_arc(c, MIRA_R + 1100, 0, TAU, 128, Color(0.01, 0.02, 0.05, 0.55), 2200)
	draw_circle(c, MIRA_R, Color(1, 1, 1, 0.07))
	for d in dianas:
		if d["p"].distance_to(c) < MIRA_R + d["r"]:
			_diana(d["p"], d["r"], 1.0)
	for m in marcas:
		draw_circle(m, 4, Color(0.8, 0.1, 0.1))
	draw_arc(c, MIRA_R, 0, TAU, 96, Color(0.15, 0.1, 0.05), 10)
	draw_arc(c, MIRA_R - 6, 0, TAU, 96, Color(P_ORO, 0.5), 1.5)
	var negro := Color(0.02, 0.02, 0.02)
	draw_line(c + Vector2(-MIRA_R, 0), c + Vector2(-45, 0), negro, 3)
	draw_line(c + Vector2(45, 0), c + Vector2(MIRA_R, 0), negro, 3)
	draw_line(c + Vector2(0, -MIRA_R), c + Vector2(0, -45), negro, 3)
	draw_line(c + Vector2(0, 20), c + Vector2(0, MIRA_R), negro, 3)
	for k in 3:
		draw_line(c + Vector2(-7, 25 + k * 12), c + Vector2(7, 25 + k * 12), negro, 2)
	draw_line(c + Vector2(-22, 0), c + Vector2(22, 0), Color(0.85, 0.15, 0.15, 0.8), 1.5)
	draw_line(c + Vector2(0, -22), c + Vector2(0, 22), Color(0.85, 0.15, 0.15, 0.8), 1.5)
	# Respira y dispara.
	panel(Rect2(101, 137, 302, 292))
	texto(Vector2(123, 178), "RESPIRA Y DISPARA", 22, MARFIL, "titulo")
	parrafo(Rect2(123, 190, 262, 130), "La mira se mece con tu respiración. Mantén pulsado para contener el aire: la mira se queda quieta unos segundos, pero si aguantas demasiado empieza a temblar.", 16, TEXTO)
	texto(Vector2(123, 342), "Aire", 15, TEXTO)
	draw_rect(Rect2(123, 352, 259, 15), Color(0, 0, 0, 0.5))
	draw_rect(Rect2(123, 352, 259 * aire, 15), Color("#bfe9f7"))
	draw_rect(Rect2(123, 352, 259, 15), Color("#bfe9f7"), false, 1.2)
	texto(Vector2(123, 404), "VIENTO", 17, MARFIL, "titulo")
	if viento != 0:
		var y := 397.0
		var largo := 30.0 + absi(viento) * 18.0
		var x0 := 205.0
		var x1 := x0 + largo
		if viento < 0:
			draw_line(Vector2(x0, y), Vector2(x1, y), P_HEX, 3)
			draw_polyline(PackedVector2Array([Vector2(x0 + 12, y - 10), Vector2(x0, y), Vector2(x0 + 12, y + 10)]), P_HEX, 3)
		else:
			draw_line(Vector2(x0, y), Vector2(x1, y), P_HEX, 3)
			draw_polyline(PackedVector2Array([Vector2(x1 - 12, y - 10), Vector2(x1, y), Vector2(x1 - 12, y + 10)]), P_HEX, 3)
	panel_info(Rect2(1196, 137, 302, 303), "Para qué sirve", ["Sube **Valor** y la puntería en combates de la historia.", "Con Caitlyn: cada ronda sin fallos sube su confianza.", "Las dianas pequeñas y lejanas dan más puntos."], "caitlyn", "«Ajusta medio punto a la izquierda. El viento sube.»")
	if aviso_t > 0.0:
		texto(c + Vector2(60, -60), aviso, 26, Color(MARFIL, clampf(aviso_t, 0, 1)), "titulo")
