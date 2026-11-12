extends "res://escenas/juego/minijuegos/minijuego.gd"

# Mezclas de quimtec (diseño: minijuegos_capturas/mj_mezclas.jpg).
# Vierte gotas de cada vial en el matraz hasta igualar el color del encargo. Cada sustancia
# sube la presión de forma distinta, y el brillo la dispara. Puedes enfriar la mezcla una vez por ronda.
# Parte 1: encargos de Singed. Parte 2: curas en la comuna de Viktor.

const VIALES := [
	{"nombre": "Verde de\npozo", "color": Color("#c64fd6"), "presion": 0.025},
	{"nombre": "Brillo", "color": Color("#a855f7"), "presion": 0.09},
	{"nombre": "Ámbar", "color": Color("#e8b04a"), "presion": 0.02},
	{"nombre": "Agua de\nfisura", "color": Color("#3fb6e0"), "presion": 0.012},
	{"nombre": "Óxido rojo", "color": Color("#ff5a5a"), "presion": 0.035},
]
const ENCARGOS := 3
const PARECIDO_OK := 0.92
const DOSIS_BRILLO := 3

var vial := 0
var gotas: Array = [0, 0, 0, 0, 0]
var objetivo_c := Color.WHITE
var presion := 0.0
var enfriado := false
var encargo := 1
var aciertos := 0
var brillo_dosis := DOSIS_BRILLO
var goteo := 0.0
var aviso := ""
var aviso_t := 0.0

func _configurar() -> void:
	nombre = "Mezclas de quimtec"
	subtitulo = "Laboratorio del Sumidero · Ingenio"
	ciudad = "Zaun"
	estadistica = "ingenio"
	con_quien = ["singed"] if Progreso.parte == 1 else ["viktor"]
	fondo_ruta = "res://assets/lugares/s1/sumidero.webp" if Progreso.parte == 1 else "res://assets/lugares/s2/zaun-comuna-viktor.jpg"
	oscurecer = 0.55
	como_se_juega = "Vierte gotas de cada vial en el matraz hasta igualar el color del encargo. Cada sustancia sube la presión de forma distinta, y el brillo la dispara. Puedes enfriar la mezcla una vez por ronda."
	teclas = [["1-5", "elegir vial"], ["MANTENER", "verter"], ["F", "enfriar"]]
	instrucciones = como_se_juega + "\n\nMantén pulsado el ratón (o ESPACIO) para verter el vial elegido. Cuando el tono se parezca al encargo un 92 % o más, el encargo queda listo. Si la aguja llega al rojo, el matraz revienta y pierdes ese encargo. Hay tres encargos; necesitas dos."

func _empezar() -> void:
	encargo = 1
	aciertos = 0
	brillo_dosis = DOSIS_BRILLO
	_nuevo_encargo()

# El encargo es siempre una mezcla posible de dos o tres viales.
func _nuevo_encargo() -> void:
	gotas = [0, 0, 0, 0, 0]
	presion = 0.0
	enfriado = false
	var usar := [0, 2, 3, 4]
	usar.shuffle()
	var mezcla := [0, 0, 0, 0, 0]
	mezcla[usar[0]] = randi_range(3, 6)
	mezcla[usar[1]] = randi_range(1, 4)
	if randf() < 0.5:
		mezcla[1] = 1
	objetivo_c = _mezclar(mezcla)

func _mezclar(g: Array) -> Color:
	var total := 0.0
	var c := Vector3.ZERO
	for i in 5:
		var col: Color = VIALES[i]["color"]
		c += Vector3(col.r, col.g, col.b) * float(g[i])
		total += float(g[i])
	if total == 0.0:
		return Color(0.12, 0.1, 0.14)
	c /= total
	return Color(c.x, c.y, c.z)

func _parecido() -> float:
	if gotas.max() == 0:
		return 0.0
	var a := _mezclar(gotas)
	var d := Vector3(a.r - objetivo_c.r, a.g - objetivo_c.g, a.b - objetivo_c.b).length()
	return clampf(1.0 - d * 1.6, 0.0, 1.0)

func _actualizar(delta: float) -> void:
	aviso_t -= delta
	var vertiendo := Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_key_pressed(KEY_SPACE)
	if vertiendo:
		goteo -= delta
		if goteo <= 0.0:
			goteo = 0.28
			_gota()
	else:
		goteo = 0.0
		presion = maxf(presion - delta * 0.01, 0.0)
		if gotas.max() > 0 and _parecido() >= PARECIDO_OK:
			aciertos += 1
			puntos += int(_parecido() * 100)
			_avisar("¡Encargo listo!")
			_siguiente()

func _gota() -> void:
	if vial == 1:
		if brillo_dosis <= 0:
			_avisar("No queda brillo")
			return
		brillo_dosis -= 1
	gotas[vial] += 1
	presion += VIALES[vial]["presion"] * (1.0 + gotas.reduce(func(a, b): return a + b, 0) * 0.04)
	if presion >= 1.0:
		_avisar("¡El matraz revienta!")
		_siguiente()

func _siguiente() -> void:
	encargo += 1
	if encargo > ENCARGOS:
		encargo = ENCARGOS
		acabar(aciertos >= 2, "Encargos perfectos: %d de %d." % [aciertos, ENCARGOS])
		return
	_nuevo_encargo()

func _entrada(e: InputEvent) -> void:
	if not (e is InputEventKey and e.pressed and not e.echo):
		return
	if e.keycode >= KEY_1 and e.keycode <= KEY_5:
		vial = e.keycode - KEY_1
	elif e.keycode == KEY_F:
		if enfriado:
			_avisar("Ya has enfriado en esta ronda")
		else:
			enfriado = true
			presion *= 0.5
			_avisar("Mezcla enfriada")

func _entrada_raton(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
		for i in 5:
			if Rect2(185 + i * 110, 520, 52, 200).has_point(e.position):
				vial = i

func _avisar(t: String) -> void:
	aviso = t
	aviso_t = 1.3

func _chips() -> Array:
	return [["ENCARGO %d / %d" % [encargo, ENCARGOS]], ["BRILLO: %d DOSIS" % brillo_dosis, true]]

func _dibujar() -> void:
	# Encargo de Singed (o de Viktor en la Parte 2).
	panel(Rect2(101, 118, 568, 182))
	if Progreso.parte == 1:
		texto(Vector2(123, 158), "ENCARGO DE SINGED", 22, MARFIL, "titulo")
		retrato("singed", Vector2(157, 206), 30, Z_SHIMMER)
		texto(Vector2(205, 212), "«Exacto. Ni una gota más. La química no perdona la prisa.»", 16, MARFIL, "italica")
		parrafo(Rect2(123, 245, 530, 50), "Sube Ingenio · Con Singed, cada encargo perfecto le interesa más «el sujeto». Con Viktor (Parte 2) sirve para curar en la comuna.", 14, TEXTO)
	else:
		texto(Vector2(123, 158), "CURAS EN LA COMUNA", 22, MARFIL, "titulo")
		retrato("viktor", Vector2(157, 206), 30, Z_SHIMMER)
		parrafo(Rect2(205, 190, 450, 50), "Encargo de Viktor para la comuna.", 16, MARFIL, "italica")
		parrafo(Rect2(123, 245, 530, 50), "Sube Ingenio · Con Viktor (Parte 2) sirve para curar en la comuna.", 14, TEXTO)
	# Viales.
	draw_rect(Rect2(148, 716, 588, 20), Color("#4a3418"))
	draw_rect(Rect2(148, 716, 588, 20), Color("#a07a3a"), false, 2)
	for i in 5:
		var x := 211.0 + i * 110.0
		var col: Color = VIALES[i]["color"]
		var nivel := 1.0 if i != 1 else float(brillo_dosis) / DOSIS_BRILLO
		var lleno := 120.0 * nivel
		draw_rect(Rect2(x - 24, 524, 48, 160), Color(0, 0, 0, 0.45))
		draw_rect(Rect2(x - 24, 684 - lleno, 48, lleno), col)
		draw_circle(Vector2(x, 684), 24, col if nivel > 0 else Color(0, 0, 0, 0.45))
		draw_line(Vector2(x - 26, 522), Vector2(x - 26, 684), Color(1, 1, 1, 0.75), 2)
		draw_line(Vector2(x + 26, 522), Vector2(x + 26, 684), Color(1, 1, 1, 0.75), 2)
		draw_arc(Vector2(x, 684), 26, 0, PI, 24, Color(1, 1, 1, 0.75), 2)
		if i == vial:
			draw_rect(Rect2(x - 34, 512, 68, 198), Color(1, 1, 1, 0.85), false, 2)
		parrafo(Rect2(x - 50, 712, 100, 40), VIALES[i]["nombre"], 14, MARFIL, "texto", 1)
	# Matraz.
	var mezcla := _mezclar(gotas)
	var total: float = gotas.reduce(func(a, b): return a + b, 0)
	var alto := clampf(total * 9.0, 0, 220)
	var cuerpo := PackedVector2Array([Vector2(975, 170), Vector2(1085, 170), Vector2(1085, 330), Vector2(1205, 690), Vector2(1190, 725), Vector2(870, 725), Vector2(855, 690), Vector2(975, 330)])
	draw_colored_polygon(cuerpo, Color(1, 1, 1, 0.05))
	if alto > 0:
		var y := 725.0 - alto
		var ancho_y := lerpf(1205 - 855, 110, clampf((690 - y) / 360.0, 0, 1)) / 2.0
		draw_colored_polygon(PackedVector2Array([Vector2(1030 - ancho_y, y), Vector2(1030 + ancho_y, y), Vector2(1200, 700), Vector2(1190, 722), Vector2(870, 722), Vector2(860, 700)]), mezcla)
		for k in 6:
			draw_circle(Vector2(900 + k * 50, 700 - fmod(tiempo * 30 + k * 37, alto)), 5 + k % 3 * 2, Color(1, 1, 1, 0.5))
	cuerpo.append(cuerpo[0])
	draw_polyline(cuerpo, Color(1, 1, 1, 0.85), 4)
	draw_rect(Rect2(957, 155, 146, 24), Color("#7a5a32"))
	# Encargo.
	panel(Rect2(1251, 118, 247, 234))
	texto(Vector2(1375, 158), "ENCARGO", 22, MARFIL, "titulo", 1)
	draw_circle(Vector2(1376, 242), 66, Color(Z_SHIMMER, 0.3))
	draw_circle(Vector2(1376, 242), 64, objetivo_c)
	draw_arc(Vector2(1376, 242), 66, 0, TAU, 48, Color.WHITE, 3)
	texto(Vector2(1376, 332), "Tono pedido · lo tuyo: %d %%" % int(_parecido() * 100), 15, TEXTO, "texto", 1)
	# Presión.
	panel(Rect2(1251, 394, 247, 232), Color("#ff5a5a"))
	texto(Vector2(1273, 434), "PRESIÓN", 22, MARFIL, "titulo")
	var c := Vector2(1380, 560)
	draw_arc(c, 85, PI, PI * 1.62, 32, Color("#e8b04a"), 18)
	draw_arc(c, 85, PI * 1.62, PI * 1.78, 16, Color("#3a3a3a"), 18)
	draw_arc(c, 85, PI * 1.78, TAU, 16, Color("#ff5a5a"), 18)
	var a := PI + PI * clampf(presion, 0, 1)
	draw_line(c, c + Vector2.from_angle(a) * 80, Color.WHITE, 3)
	parrafo(Rect2(1273, 572, 210, 50), "Si la aguja llega al rojo, el matraz revienta.", 14, TEXTO)
	if aviso_t > 0.0:
		texto(Vector2(1030, 140), aviso, 24, Color(MARFIL, clampf(aviso_t, 0, 1)), "titulo", 1)
