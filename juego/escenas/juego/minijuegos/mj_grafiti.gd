extends "res://escenas/juego/minijuegos/minijuego.gd"

# Grafiti (diseño: minijuegos_capturas/mj_grafiti.jpg).
# Rellena la plantilla con el aerosol sin salirte. Cuando el foco de la patrulla barre el muro,
# deja de pintar y escóndete. Si te ve, la alerta sube.

const MARCO := Rect2(577, 143, 410, 484)
const LIMITE := 60.0
const OBJETIVO := 0.85
const BOTES := [Color("#ff4fa3"), Color("#3fb6e0"), Color("#e8d34a"), Color("#f2f2f2")]

# La plantilla es el emblema de Zaun (assets/simbolos/zaun.png). La pintura se guarda en una imagen del mismo tamaño.
var emblema: Texture2D
var mascara: Image
var pintura: Image
var pintura_tex: ImageTexture
var pintado: PackedByteArray
var total_dentro := 0
var n_pintado := 0
var bote := 0
var escondido := false
var alerta := 0.0
var foco_x := -400.0
var foco_activo := false
var espera_foco := 6.0
var chorretones: Array = []
var aviso := ""
var aviso_t := 0.0

func _configurar() -> void:
	nombre = "Grafiti"
	subtitulo = "Muro del puesto de ejecutores · Sigilo"
	ciudad = "Zaun"
	estadistica = "sigilo"
	con_quien = ["jinx"]
	fondo_ruta = "res://assets/lugares/s1/zaun-punto-seguridad.jpg"
	oscurecer = 0.8
	como_se_juega = "Rellena la plantilla con el aerosol sin salirte. Cuando el foco de la patrulla barre el muro, deja de pintar y escóndete. Si te ve, la alerta sube."
	teclas = [["CLIC", "pintar"], ["1-4", "cambiar de bote"], ["ESPACIO", "esconderse"]]
	instrucciones = como_se_juega + "\n\nMantén el clic para pintar. Tienes %d segundos para llegar al %d %% de relleno. Pintar fuera de la plantilla deja chorretones. Si el foco te pilla pintando sin esconderte (mantén ESPACIO), la alerta sube; si llega al máximo, la patrulla te descubre." % [int(LIMITE), int(OBJETIVO * 100)]

func _empezar() -> void:
	chorretones = []
	alerta = 0.0
	foco_activo = false
	espera_foco = 5.0
	emblema = cargar("res://assets/simbolos/zaun.png")
	mascara = emblema.get_image()
	if mascara.is_compressed():
		mascara.decompress()
	pintura = Image.create(mascara.get_width(), mascara.get_height(), false, Image.FORMAT_RGBA8)
	pintura_tex = ImageTexture.create_from_image(pintura)
	pintado = PackedByteArray()
	pintado.resize(mascara.get_width() * mascara.get_height())
	n_pintado = 0
	total_dentro = 0
	for j in mascara.get_height():
		for i in mascara.get_width():
			if mascara.get_pixel(i, j).a > 0.5:
				total_dentro += 1

# Del diseño (1600x900) a un píxel de la plantilla.
func _a_plantilla(p: Vector2) -> Vector2:
	return (p - MARCO.position) / MARCO.size * Vector2(mascara.get_width(), mascara.get_height())

func _actualizar(delta: float) -> void:
	aviso_t -= delta
	escondido = Input.is_key_pressed(KEY_SPACE)
	# Foco de la patrulla.
	if foco_activo:
		foco_x += 520.0 * delta
		if foco_x > 1700:
			foco_activo = false
			espera_foco = randf_range(4.0, 7.0)
	else:
		espera_foco -= delta
		if espera_foco <= 0.0:
			foco_activo = true
			foco_x = -300.0
	var pintando := Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not escondido
	var m := raton()
	if pintando:
		_pintar(m)
	if foco_activo and absf(foco_x - m.x) < 230 and not escondido:
		alerta = minf(alerta + delta * (0.9 if pintando else 0.35), 1.0)
	else:
		alerta = maxf(alerta - delta * 0.05, 0.0)
	if alerta >= 1.0:
		acabar(false, "La patrulla te ha visto.")
	elif _relleno() >= OBJETIVO:
		puntos = int(_relleno() * 100) + int(LIMITE - tiempo)
		acabar(true, "Mural terminado: %d %%" % int(_relleno() * 100))
	elif tiempo >= LIMITE:
		acabar(false, "Se ha acabado el tiempo: %d %%" % int(_relleno() * 100))

func _pintar(m: Vector2) -> void:
	var r := 22.0
	var c := _a_plantilla(m)
	var rp := r / MARCO.size.x * mascara.get_width()
	var col: Color = BOTES[bote]
	var cambio := false
	for j in range(int(c.y - rp), int(c.y + rp) + 1):
		for i in range(int(c.x - rp), int(c.x + rp) + 1):
			if i < 0 or j < 0 or i >= mascara.get_width() or j >= mascara.get_height():
				continue
			if Vector2(i, j).distance_to(c) > rp:
				continue
			var a := mascara.get_pixel(i, j).a
			if a <= 0.05:
				continue
			pintura.set_pixel(i, j, Color(col, a))
			cambio = true
			var k := j * mascara.get_width() + i
			if a > 0.5 and pintado[k] == 0:
				pintado[k] = 1
				n_pintado += 1
	if cambio:
		pintura_tex.update(pintura)
	# Si te sales de la plantilla, chorretones.
	if MARCO.has_point(m) and (c.x < 0 or c.y < 0 or c.x >= mascara.get_width() or c.y >= mascara.get_height() or mascara.get_pixel(int(c.x), int(c.y)).a < 0.1):
		if randf() < 0.08 and chorretones.size() < 12:
			chorretones.append([m, randf_range(30, 90), col])

func _relleno() -> float:
	if total_dentro == 0:
		return 0.0
	return float(n_pintado) / total_dentro

func _entrada(e: InputEvent) -> void:
	if e is InputEventKey and e.pressed and not e.echo and e.keycode >= KEY_1 and e.keycode <= KEY_4:
		bote = e.keycode - KEY_1

func _entrada_raton(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.pressed:
		for i in 4:
			if Rect2(123 + i * 65, 487, 50, 86).has_point(e.position):
				bote = i

func _premio_extra() -> void:
	Progreso.flags["murales_zaun"] = int(Progreso.flags.get("murales_zaun", 0)) + 1

func _avisar(t: String) -> void:
	aviso = t
	aviso_t = 1.2

func _chips() -> Array:
	return [["RELLENO %d %%" % int(_relleno() * 100), true], [reloj(LIMITE - tiempo)]]

func _dibujar() -> void:
	# Muro de ladrillo.
	draw_rect(Rect2(64, 92, 1472, 650), Color("#2a1f18"))
	for fila in 16:
		for col in 15:
			var x := 64 + col * 110 - (55 if fila % 2 else 0)
			draw_rect(Rect2(x + 3, 98 + fila * 41, 104, 36), Color("#3a2a20"))
	draw_rect(Rect2(0, 92, 64, 690), Color(0.02, 0.04, 0.05, 0.9))
	draw_rect(Rect2(1536, 92, 64, 690), Color(0.02, 0.04, 0.05, 0.9))
	# Plantilla (fantasma) y pintura.
	draw_texture_rect(emblema, MARCO, false, Color(1, 1, 1, 0.16))
	draw_texture_rect(pintura_tex, MARCO, false)
	for c in chorretones:
		draw_line(c[0], c[0] + Vector2(0, c[1]), c[2], 3)
		draw_circle(c[0] + Vector2(0, c[1]), 4, c[2])
	# Marco discontinuo.
	var x := MARCO.position.x
	while x < MARCO.end.x:
		draw_line(Vector2(x, MARCO.position.y), Vector2(x + 6, MARCO.position.y), Color(1, 1, 1, 0.5), 1)
		draw_line(Vector2(x, MARCO.end.y), Vector2(x + 6, MARCO.end.y), Color(1, 1, 1, 0.5), 1)
		x += 12
	var y := MARCO.position.y
	while y < MARCO.end.y:
		draw_line(Vector2(MARCO.position.x, y), Vector2(MARCO.position.x, y + 6), Color(1, 1, 1, 0.5), 1)
		draw_line(Vector2(MARCO.end.x, y), Vector2(MARCO.end.x, y + 6), Color(1, 1, 1, 0.5), 1)
		y += 12
	# Foco de la patrulla.
	if foco_activo:
		draw_colored_polygon(PackedVector2Array([Vector2(foco_x - 160, 92), Vector2(foco_x + 160, 92), Vector2(foco_x + 260, 782), Vector2(foco_x - 230, 782)]), Color(1, 0.88, 0.35, 0.22))
	# Bote de spray en el ratón.
	var m := raton()
	if not escondido:
		draw_set_transform(_desplazamiento + (m + Vector2(55, 60)) * _escala, -0.45, Vector2(_escala, _escala))
		draw_rect(Rect2(-24, -10, 48, 170), Color("#4a4a52"))
		draw_rect(Rect2(-24, 30, 48, 80), BOTES[bote])
		draw_rect(Rect2(-6, -26, 12, 16), Color("#dddddd"))
		draw_set_transform(_desplazamiento, 0.0, Vector2(_escala, _escala))
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			draw_circle(m, 26, Color(BOTES[bote], 0.25))
	else:
		texto(Vector2(800, 720), "Escondid%s…" % ("a" if DatosPartida.genero == "mujer" else "o"), 24, MARFIL, "titulo", 1)
	# Botes.
	panel(Rect2(102, 441, 284, 148))
	texto(Vector2(122, 474), "BOTES", 17, MARFIL, "titulo")
	for i in 4:
		var r := Rect2(123 + i * 65, 487, 50, 86)
		draw_rect(r.grow(4), Color(BOTES[i], 0.25))
		draw_rect(r, BOTES[i])
		if i == bote:
			draw_rect(r.grow(2), Color.WHITE, false, 3)
	# Alerta.
	texto(Vector2(122, 625), "ALERTA", 15, Z_ROSA, "titulo")
	barra(Rect2(190, 612, 196, 14), alerta, Z_ROSA)
	panel_info(Rect2(1215, 119, 283, 280), "Para qué sirve", ["Sube **Sigilo**.", "Cada mural queda pintado en el mapa 3D de Zaun.", "Jinx copia tus dibujos si te tiene aprecio. Los ejecutores te desconfían."], "jinx", "«Más rosa. MÁS. ¡Perfecto~!»")
