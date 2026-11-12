extends "res://escenas/juego/minijuegos/minijuego.gd"

# Carrera de aerotabla, al estilo «Vector» (diseño: minijuegos_capturas/mj_aerotabla.jpg).
# Corre por los tejados sin parar. Salta antes del borde para cruzar el gas, encadena trucos
# sobre tuberías y antenas para ganar impulso y no dejes que el fantasma de Ekko te saque ventaja.

const VUELTAS := 3
const LARGO_VUELTA := 5200.0
const SUELO_BASE := 660.0
const GRAVEDAD := 2300.0
const SALTO := 900.0
const VEL_BASE := 430.0
const JUGADOR_X := 560.0
const FANTASMA_VUELTA := 12.8   # segundos por vuelta de Ekko
const NEGRO_SIL := Color("#050307")

# Tramos del recorrido: [inicio, fin, altura del tejado]. Entre tramos hay gas.
var tramos: Array = []
var obstaculos: Array = []    # {x, tipo: "tuberia"|"antena", hecho}
var piezas: Array = []        # {x, y, cogida}
var x := 0.0                  # distancia recorrida (total)
var y := SUELO_BASE
var vy := 0.0
var en_suelo := true
var deslizando := false
var impulso := 0.0
var combo := 1
var piezas_n := 0
var truco_t := 0.0
var aviso := ""
var aviso_t := 0.0
var caidas := 0

func _configurar() -> void:
	nombre = "Carrera de aerotabla"
	subtitulo = "Tejados de los Callejones · Sigilo"
	ciudad = "Zaun"
	estadistica = "sigilo"
	con_quien = ["ekko"]
	fondo_ruta = "res://assets/lugares/s1/tejados.webp"
	oscurecer = 0.35
	como_se_juega = "Corre por los tejados sin parar. Salta antes del borde para cruzar el gas, encadena trucos sobre tuberías y antenas para ganar impulso y no dejes que el fantasma de Ekko te saque ventaja."
	teclas = [["ESPACIO", "saltar"], ["↑", "truco"], ["↓", "deslizarse"], ["SHIFT", "impulso"]]
	instrucciones = como_se_juega + "\n\nSon tres vueltas. Si caes al gas vuelves al último tejado y pierdes tiempo. Sobre las tuberías y antenas aparece «TRUCO · ¡AHORA!»: pulsa ↑ para sumar combo. Deslízate (↓) por debajo de las tuberías altas. SHIFT gasta el combo en un impulso. Si le ganas a Ekko, sube su amistad y se abren atajos por los tejados en el mapa 3D."

func _empezar() -> void:
	x = 0.0
	y = SUELO_BASE
	vy = 0.0
	impulso = 0.0
	combo = 1
	piezas_n = 0
	caidas = 0
	_generar()
	y = _suelo_en(x)
	en_suelo = true

func _generar() -> void:
	tramos = []
	obstaculos = []
	piezas = []
	seed(7)
	var pos := -600.0
	var total := LARGO_VUELTA * VUELTAS + 1200
	while pos < total:
		var largo := randf_range(520, 900)
		var alto := SUELO_BASE + randf_range(-60, 40)
		tramos.append([pos, pos + largo, alto])
		if pos > 400:
			var tipo := "tuberia" if randf() < 0.5 else "antena"
			obstaculos.append({"x": pos + largo * 0.55, "tipo": tipo, "hecho": false, "y": alto})
			piezas.append({"x": pos + largo * 0.3, "y": alto - 130, "cogida": false})
		pos += largo + randf_range(150, 230)
	randomize()

func _suelo_en(px: float) -> float:
	for t in tramos:
		if px >= t[0] and px <= t[1]:
			return t[2]
	return INF

func _velocidad() -> float:
	return VEL_BASE + impulso

func _actualizar(delta: float) -> void:
	aviso_t -= delta
	truco_t -= delta
	impulso = maxf(impulso - delta * 120.0, 0.0)
	deslizando = Input.is_key_pressed(KEY_DOWN) and en_suelo
	x += _velocidad() * delta
	vy += GRAVEDAD * delta
	y += vy * delta
	var suelo := _suelo_en(x)
	if suelo != INF and y >= suelo and y - vy * delta <= suelo + 4:
		y = suelo
		vy = 0.0
		en_suelo = true
	else:
		en_suelo = false
	if y > 900:
		_caer()
	for o in obstaculos:
		if not o["hecho"] and absf(o["x"] - x) < 70:
			truco_t = 0.2
		if not o["hecho"] and o["x"] < x - 70:
			o["hecho"] = true
	for p in piezas:
		if not p["cogida"] and absf(p["x"] - x) < 40 and absf(p["y"] - (y - 60)) < 70:
			p["cogida"] = true
			piezas_n += 1
	if x >= LARGO_VUELTA * VUELTAS:
		var fantasma := FANTASMA_VUELTA * VUELTAS
		puntos = piezas_n * 10 + combo * 5 + int(maxf(fantasma - tiempo, 0) * 20)
		acabar(tiempo <= fantasma, "Tu tiempo: %s · Ekko: %s" % [reloj(tiempo, true), reloj(fantasma, true)])

func _caer() -> void:
	caidas += 1
	combo = 1
	impulso = 0.0
	# Vuelve al principio del último tejado.
	var vuelta_a := x
	for t in tramos:
		if t[0] <= x:
			vuelta_a = t[0] + 40
	x = vuelta_a
	y = _suelo_en(x)
	vy = 0.0
	tiempo += 1.5
	_avisar("¡Al gas! +1,5 s")

func _entrada(e: InputEvent) -> void:
	if not (e is InputEventKey and e.pressed and not e.echo):
		return
	match e.keycode:
		KEY_SPACE:
			if en_suelo:
				vy = -SALTO
				en_suelo = false
		KEY_UP:
			var hecho := false
			for o in obstaculos:
				if not o["hecho"] and absf(o["x"] - x) < 70:
					o["hecho"] = true
					hecho = true
			if hecho:
				combo += 1
				impulso += 60.0
				_avisar("Truco · combo x%d" % combo)
			else:
				combo = 1
		KEY_SHIFT:
			if combo > 1:
				impulso += 90.0 * combo
				combo = 1
				_avisar("¡Impulso!")

func _premio_extra() -> void:
	Progreso.flags["atajos_tejados"] = true

func _avisar(t: String) -> void:
	aviso = t
	aviso_t = 1.1

func _vuelta() -> int:
	return mini(int(x / LARGO_VUELTA) + 1, VUELTAS)

func _chips() -> Array:
	return [["VUELTA %d / %d" % [_vuelta(), VUELTAS]], [reloj(tiempo, true), true], ["COMBO X%d" % combo], ["PIEZAS %d" % piezas_n]]

# Pantalla: el jugador va fijo en JUGADOR_X; el mundo se mueve.
func _px(mundo_x: float) -> float:
	return JUGADOR_X + (mundo_x - x)

func _dibujar() -> void:
	# Ciudad lejana: siluetas lavanda envueltas en niebla, que se mueven más despacio.
	for capa in [[0.12, Color(0.55, 0.5, 0.62, 0.12), 400.0, 190.0], [0.35, Color(0.18, 0.15, 0.22, 0.35), 500.0, 150.0]]:
		var k: float = capa[0]
		var paso: float = capa[3]
		for i in 14:
			var bx := fposmod(i * paso - x * k, paso * 14) - paso
			var alto: float = capa[2] + float((i * 53) % 110)
			var ancho := paso * 0.72
			draw_rect(Rect2(bx, alto, ancho, 782 - alto), capa[1])
			if i % 3 == 0:
				draw_rect(Rect2(bx + ancho * 0.3, alto - 60, ancho * 0.25, 60), capa[1])
	# Niebla baja.
	for j in 8:
		draw_rect(Rect2(0, 520 + j * 33, 1600, 33), Color(0.45, 0.4, 0.5, 0.04 * j))
	# Tejados negros y, en los huecos, el gas violeta que sube.
	for n in tramos.size():
		var t: Array = tramos[n]
		var a := _px(t[0])
		var b := _px(t[1])
		if n + 1 < tramos.size():
			var sig := _px(tramos[n + 1][0])
			if sig > -50 and b < 1650:
				for j in 10:
					draw_rect(Rect2(b, 782 - j * 14, sig - b, 14), Color(Z_SHIMMER, 0.42 - j * 0.04))
		if b < -50 or a > 1650:
			continue
		draw_rect(Rect2(a, t[2], b - a, 782 - t[2]), NEGRO_SIL)
		# Chimeneas y cajas del tejado.
		draw_rect(Rect2(a + 40, t[2] - 50, 90, 50), NEGRO_SIL)
		draw_rect(Rect2(a + 70, t[2] - 80, 24, 30), NEGRO_SIL)
		draw_rect(Rect2(b - 140, t[2] - 120, 18, 120), NEGRO_SIL)
		draw_rect(Rect2(b - 150, t[2] - 124, 38, 8), NEGRO_SIL)
	for o in obstaculos:
		var ox := _px(o["x"])
		if ox < -100 or ox > 1700:
			continue
		var oy: float = o["y"]
		if o["tipo"] == "tuberia":
			draw_line(Vector2(ox - 90, oy - 8), Vector2(ox + 90, oy - 8), NEGRO_SIL, 8)
			draw_colored_polygon(PackedVector2Array([Vector2(ox + 50, oy - 4), Vector2(ox + 80, oy - 70), Vector2(ox + 110, oy - 4)]), NEGRO_SIL)
		else:
			draw_line(Vector2(ox, oy), Vector2(ox, oy - 140), NEGRO_SIL, 5)
			draw_line(Vector2(ox, oy - 140), Vector2(ox - 30, oy - 170), NEGRO_SIL, 4)
			draw_line(Vector2(ox, oy - 140), Vector2(ox + 30, oy - 170), NEGRO_SIL, 4)
	for p in piezas:
		if not p["cogida"]:
			var pp := Vector2(_px(p["x"]), p["y"])
			draw_arc(pp, 11, 0, TAU, 16, P_ORO, 4)
	# Fantasma de Ekko.
	var fantasma_x := tiempo / FANTASMA_VUELTA * LARGO_VUELTA
	var fx := _px(fantasma_x)
	if fx > -100 and fx < 1700:
		_corredor(Vector2(fx, _suelo_en(fantasma_x) if _suelo_en(fantasma_x) != INF else SUELO_BASE), Color(0.85, 0.92, 1.0, 0.45), false)
		var dif := (x - fantasma_x) / _velocidad()
		texto(Vector2(fx, 228), "EKKO · %s%.1f S" % ["+" if dif < 0 else "−", absf(dif)], 18, Color(0.75, 0.9, 1.0, 0.9), "titulo", 1)
	# Jugador (con la estela del salto).
	if not en_suelo:
		for j in 8:
			draw_circle(Vector2(JUGADOR_X - 30 - j * 22, y + 10 + j * j * 1.6 * signf(vy + 1)), 2.5, Color(1, 1, 1, 0.7 - j * 0.07))
	_corredor(Vector2(JUGADOR_X, y), NEGRO_SIL, true)
	if truco_t > 0.0:
		var c := Vector2(JUGADOR_X + 170, y - 200)
		draw_circle(c, 30, Color(0.05, 0.03, 0.06, 0.85))
		draw_arc(c, 30, 0, TAU, 32, Color.WHITE, 3)
		texto(c + Vector2(0, 10), "↑", 30, Color.WHITE, "texto", 1)
		texto(c + Vector2(45, 10), "TRUCO · ¡AHORA!", 24, MARFIL, "titulo")
	# Barra de progreso.
	var avance := clampf(x / (LARGO_VUELTA * VUELTAS), 0, 1)
	var av_e := clampf(fantasma_x / (LARGO_VUELTA * VUELTAS), 0, 1)
	draw_rect(Rect2(40, 113, 700, 10), Color(0, 0, 0, 0.45))
	draw_rect(Rect2(40, 113, 700 * avance, 10), Z_SHIMMER)
	draw_circle(Vector2(40 + 700 * av_e, 118), 12, P_HEX)
	draw_circle(Vector2(40 + 700 * avance, 118), 12, Color("#050307"))
	draw_arc(Vector2(40 + 700 * avance, 118), 12, 0, TAU, 24, Color.WHITE, 2)
	panel_info(Rect2(1231, 121, 328, 280), "Para qué sirve", ["Sube **Sigilo**.", "Corres contra el tiempo de Ekko: si le ganas, sube su **amistad**.", "Abre atajos por los tejados en el mapa 3D de Zaun."], "ekko", "«Por arriba nadie te para. Salta el gas, no lo cruces.»")
	draw_rect(Rect2(1231, 121, 4, 280), P_HEX)
	if aviso_t > 0.0:
		texto(Vector2(JUGADOR_X, y - 260), aviso, 24, Color(MARFIL, clampf(aviso_t, 0, 1)), "titulo", 1)

# Silueta en aerotabla (pies en «pie»): tabla curva con propulsores y figura de un corredor.
func _corredor(pie: Vector2, col: Color, jugador: bool) -> void:
	var fantasma := col.a < 0.9
	var agachado := 34.0 if (jugador and deslizando) else 0.0
	var aire := jugador and not en_suelo
	var t := tiempo * 9.0
	# Tabla.
	var tabla := PackedVector2Array()
	for i in 13:
		var u := -1.0 + i / 6.0
		tabla.append(pie + Vector2(u * 95, -6 + u * u * 10 - (8 if u > 0.6 else 0)))
	for i in 13:
		var u := 1.0 - i / 6.0
		tabla.append(pie + Vector2(u * 95, 4 + u * u * 8))
	draw_colored_polygon(tabla, col)
	var luz := Color(Z_SHIMMER, 0.45 if fantasma else 0.95)
	for dx in [-48.0, 42.0]:
		_ovalo(pie + Vector2(dx, 14), Vector2(26, 7), luz)
		_ovalo(pie + Vector2(dx, 14), Vector2(15, 4), Color(1, 0.85, 1, 0.6 if fantasma else 0.9))
	# Cuerpo.
	var cadera := pie + Vector2(-4, -78 + agachado)
	var pecho := cadera + Vector2(18, -66 + agachado * 0.4)
	var rodilla_a := pie + Vector2(-34, -40 + agachado * 0.5) if not aire else pie + Vector2(-46, -58)
	var rodilla_b := pie + Vector2(34, -44 + agachado * 0.5) if not aire else pie + Vector2(26, -70)
	_miembro(pie + Vector2(-30, -6), rodilla_a, 16, 20, col)
	_miembro(rodilla_a, cadera + Vector2(-8, 0), 20, 26, col)
	_miembro(pie + Vector2(30, -6), rodilla_b, 16, 20, col)
	_miembro(rodilla_b, cadera + Vector2(8, 0), 20, 26, col)
	_miembro(cadera, pecho, 34, 44, col)
	# Cabeza con mechones.
	var cabeza := pecho + Vector2(10, -28)
	draw_circle(cabeza, 21, col)
	draw_colored_polygon(PackedVector2Array([cabeza + Vector2(-14, -8), cabeza + Vector2(-44, -2 + sin(t) * 3), cabeza + Vector2(-12, 4)]), col)
	draw_colored_polygon(PackedVector2Array([cabeza + Vector2(-10, -14), cabeza + Vector2(-38, -20 + cos(t) * 3), cabeza + Vector2(-4, -12)]), col)
	# Brazos: uno arriba, el otro atrás con el bate.
	var codo_a := pecho + (Vector2(26, -40) if aire else Vector2(36, -18 + sin(t) * 6))
	var mano_a := codo_a + (Vector2(10, -46) if aire else Vector2(30, -26))
	_miembro(pecho, codo_a, 15, 16, col)
	_miembro(codo_a, mano_a, 13, 12, col)
	draw_circle(mano_a, 9, col)
	var codo_b := pecho + Vector2(-30, 22 + cos(t) * 5)
	var mano_b := codo_b + Vector2(-28, 20)
	_miembro(pecho, codo_b, 15, 16, col)
	_miembro(codo_b, mano_b, 13, 12, col)
	draw_line(mano_b, mano_b + Vector2(-70, -100), col, 9)
	draw_line(mano_b + Vector2(-50, -72), mano_b + Vector2(-78, -112), col, 13)

func _miembro(a: Vector2, b: Vector2, ancho_a: float, ancho_b: float, col: Color) -> void:
	var n := (b - a).orthogonal().normalized()
	draw_colored_polygon(PackedVector2Array([a + n * ancho_a / 2, b + n * ancho_b / 2, b - n * ancho_b / 2, a - n * ancho_a / 2]), col)
	draw_circle(b, ancho_b / 2, col)

func _ovalo(c: Vector2, r: Vector2, col: Color) -> void:
	var pts := PackedVector2Array()
	for i in 20:
		var ang := TAU * i / 20.0
		pts.append(c + Vector2(cos(ang) * r.x, sin(ang) * r.y))
	draw_colored_polygon(pts, col)
