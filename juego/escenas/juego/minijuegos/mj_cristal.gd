extends "res://escenas/juego/minijuegos/minijuego.gd"

# Calibrar el cristal (diseño: minijuegos_capturas/mj_cristal.jpg).
# Gira cada anillo de runas hasta que su muesca dorada quede en la línea de energía.
# Si giras de más, el cristal se calienta y la estabilidad baja.

const CENTRO := Vector2(772, 430)
const RADIOS := [146.0, 210.0, 276.0]
const COLORES := [P_ORO, P_HEX, P_ORO]
const RUNAS := ["F", "U", "Þ", "A", "R", "K", "X", "P", "H", "N", "I", "Y"]
const TOLERANCIA := 0.06
const LIMITE := 90.0

var angulos := [0.0, 0.0, 0.0]   # posición de la muesca de cada anillo (0 = arriba)
var fijado := [false, false, false]
var anillo := 0
var estabilidad := 1.0
var calor := 0.0
var girado := 0.0
var aviso := ""
var aviso_t := 0.0
var fallos := 0

func _configurar() -> void:
	nombre = "Calibrar el cristal"
	subtitulo = "Taller de Jayce · Ingenio"
	ciudad = "Piltover"
	estadistica = "ingenio"
	con_quien = ["jayce", "viktor"]
	fondo_ruta = "res://assets/lugares/s1/taller-jayce.webp"
	oscurecer = 0.75
	como_se_juega = "Gira cada anillo de runas hasta que su muesca dorada quede en la línea de energía. Si giras de más, el cristal se calienta y la estabilidad baja."
	teclas = [["Q / E", "girar anillo"], ["TAB", "cambiar de anillo"], ["ESPACIO", "fijar"]]
	instrucciones = como_se_juega + "\n\nEmpiezas por el anillo de dentro. Cuando la muesca pasa por la línea, la runa brilla: es el momento de fijar con ESPACIO. Fijar fuera de la línea o girar sin parar calienta el cristal. Tienes %d segundos y no puedes llegar a 0 %% de estabilidad." % int(LIMITE)

func _empezar() -> void:
	for i in 3:
		angulos[i] = randf_range(0.8, TAU - 0.8)
		fijado[i] = false
	anillo = 0
	estabilidad = 1.0
	calor = 0.0
	fallos = 0

func _actualizar(delta: float) -> void:
	aviso_t -= delta
	var giro := 0.0
	if Input.is_key_pressed(KEY_Q):
		giro -= 1.0
	if Input.is_key_pressed(KEY_E):
		giro += 1.0
	if giro != 0.0 and not fijado[anillo]:
		var v := 1.6 * delta * giro
		angulos[anillo] = fposmod(angulos[anillo] + v, TAU)
		calor += absf(v) * 0.05
	calor = maxf(calor - delta * 0.04, 0.0)
	if calor > 0.25:
		estabilidad -= (calor - 0.25) * delta * 0.8
	if estabilidad <= 0.0:
		estabilidad = 0.0
		acabar(false, "El cristal se ha recalentado.")
	elif tiempo >= LIMITE:
		acabar(false, "Se ha acabado el tiempo.")

func _distancia(i: int) -> float:
	var a: float = angulos[i]
	return minf(a, TAU - a)

func _entrada(e: InputEvent) -> void:
	if not (e is InputEventKey and e.pressed and not e.echo):
		return
	if e.keycode == KEY_TAB:
		for k in 3:
			anillo = (anillo + 1) % 3
			if not fijado[anillo]:
				break
	elif e.keycode == KEY_SPACE and not fijado[anillo]:
		if _distancia(anillo) <= TOLERANCIA:
			fijado[anillo] = true
			angulos[anillo] = 0.0
			puntos += 100
			_avisar("Anillo fijado")
			if not fijado.has(false):
				puntos += int(estabilidad * 300)
				acabar(true, "Estabilidad final: %d %%%s" % [int(estabilidad * 100), "" if fallos == 0 else " · fallos: %d" % fallos])
				return
			for k in 3:
				if not fijado[k]:
					anillo = k
					break
		else:
			fallos += 1
			estabilidad -= 0.12
			calor += 0.15
			_avisar("Fuera de la línea: el cristal se calienta")

func _premio_extra() -> void:
	Progreso.flags["piezas_hextech"] = int(Progreso.flags.get("piezas_hextech", 0)) + 1

func _avisar(t: String) -> void:
	aviso = t
	aviso_t = 1.2

func _chips() -> Array:
	return [["ESTABILIDAD %d %%" % int(estabilidad * 100), true], ["ANILLO %d / 3" % (anillo + 1)], [reloj(LIMITE - tiempo)]]

func _dibujar() -> void:
	# Línea de energía.
	draw_rect(Rect2(CENTRO.x - 9, 108, 18, CENTRO.y - 108 - 110), Color(P_HEX, 0.35))
	draw_rect(Rect2(CENTRO.x - 3, 108, 6, CENTRO.y - 108 - 110), Color("#9fe3fa"))
	for i in 3:
		var r: float = RADIOS[i]
		var col: Color = COLORES[i]
		if fijado[i]:
			col = Color("#9fe3fa")
		var grosor := 3.5 if i == anillo else 2.0
		draw_arc(CENTRO, r, 0, TAU, 128, col, grosor)
		draw_arc(CENTRO, r - 30, 0, TAU, 128, Color(col, 0.35), 1)
		# Runas que giran con el anillo.
		var a0: float = angulos[i]
		for k in 12:
			var ang := a0 + TAU * k / 12.0 - PI / 2.0
			var p := CENTRO + Vector2.from_angle(ang) * (r - 15)
			texto(p + Vector2(0, 7), RUNAS[(k + i * 3) % 12], 17, Color(col, 0.85), "texto", 1)
			var t1 := CENTRO + Vector2.from_angle(ang + 0.13) * (r - 4)
			var t2 := CENTRO + Vector2.from_angle(ang + 0.13) * (r - 11)
			draw_line(t1, t2, Color(col, 0.7), 1.5)
		# Muesca dorada (triángulo).
		var am := a0 - PI / 2.0
		var punta := CENTRO + Vector2.from_angle(am) * (r - 6)
		var base := CENTRO + Vector2.from_angle(am) * (r + 22)
		var lado := Vector2.from_angle(am + PI / 2.0) * 13
		var tri := PackedVector2Array([punta, base + lado, base - lado])
		var cerca: bool = _distancia(i) <= TOLERANCIA * 1.6 and not fijado[i]
		draw_colored_polygon(tri, Color("#0b1220"))
		tri.append(tri[0])
		draw_polyline(tri, Color.WHITE if cerca else P_ORO, 3)
	# Cristal.
	var calor_c := Color(1.0, 0.45, 0.3).lerp(Color.WHITE, 0.3)
	var brillo := P_HEX.lerp(calor_c, clampf(calor * 1.5, 0, 1))
	draw_circle(CENTRO, 95, Color(brillo, 0.15))
	var gema := PackedVector2Array([CENTRO + Vector2(0, -88), CENTRO + Vector2(60, -45), CENTRO + Vector2(55, 50), CENTRO + Vector2(0, 95), CENTRO + Vector2(-58, 50), CENTRO + Vector2(-60, -45)])
	draw_colored_polygon(gema, Color(brillo.darkened(0.2), 0.9))
	gema.append(gema[0])
	draw_polyline(gema, Color.WHITE, 3)
	draw_colored_polygon(PackedVector2Array([CENTRO + Vector2(0, -80), CENTRO + Vector2(12, 0), CENTRO + Vector2(0, 85), CENTRO + Vector2(-12, 0)]), Color(1, 1, 1, 0.6))
	draw_circle(CENTRO, 9, Color.WHITE)
	panel_info(Rect2(1196, 147, 302, 277), "Para qué sirve", ["Sube **Ingenio** al terminar sin fallos.", "Recompensa: **piezas hextech** para mejoras.", "En la historia: misión «El primer portal», con Jayce y Viktor."], "jayce", "«Despacio. La runa te dice cuándo, no tú.»")
	if aviso_t > 0.0:
		texto(Vector2(CENTRO.x, 760), aviso, 22, Color(MARFIL, clampf(aviso_t, 0, 1)), "titulo", 1)
