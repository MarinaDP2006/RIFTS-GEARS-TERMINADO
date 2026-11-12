extends "res://escenas/juego/minijuegos/minijuego.gd"

# Baile de gala (diseño: minijuegos_capturas/mj_gala.jpg; Nina lo quiere tal cual).
# Sigue el compás de tu pareja: pulsa cada paso cuando la nota llegue al círculo dorado y
# mantén las notas largas para girar. Tres fallos seguidos y la pisas.
# Eliges pareja entre quien ya te aprecia, y la música cambia con ella.

const CARRILES := [602.0, 740.0, 878.0, 1016.0]
const LETRAS := ["A", "S", "D", "F"]
const TECLAS_C := [KEY_A, KEY_S, KEY_D, KEY_F]
const LINEA_Y := 688.0
const ARRIBA_Y := 130.0
const DURACION := 45.0
const VENTANA := 0.13

# Ritmo de cada pareja (segundos entre pasos) y la frase de Mel del diseño.
const PAREJAS := {
	"mel": {"ritmo": 0.62, "frase": "«Me pisas otra vez y lo convierto en un escándalo. Sonríe.»", "musica": "vals"},
	"jayce": {"ritmo": 0.45, "frase": "", "musica": "algo más rápido"},
}
const CANDIDATOS := ["mel", "jayce", "caitlyn", "viktor", "heimerdinger", "cassandra", "maddie"]

var pareja := "mel"
var notas: Array = []     # {t, carril, largo, estado}
var combo := 0
var aciertos := 0
var total := 0
var fallos_seguidos := 0
var pisadas := 0
var velocidad := 1.4      # segundos que tarda una nota en caer
var pulsado := [false, false, false, false]
var aviso := ""
var aviso_t := 0.0
var afecto_inicio := 0

func _configurar() -> void:
	nombre = "Baile de gala"
	subtitulo = "Gala del Día del Progreso · Carisma"
	ciudad = "Piltover"
	estadistica = "carisma"
	fondo_ruta = "res://assets/lugares/s2/piltover.webp"
	oscurecer = 0.6
	como_se_juega = "Sigue el compás de tu pareja: pulsa cada paso cuando la nota llegue al círculo dorado y mantén las notas largas para girar. Tres fallos seguidos y la pisas."
	teclas = [["A S D F", "pasos"], ["ESPACIO", "giro (notas largas)"]]
	instrucciones = como_se_juega + "\n\nAntes de empezar eliges pareja entre quien ya te aprecia. La música cambia con ella: vals para Mel, algo más rápido para Jayce. Si bailas con elegancia sube su afecto o su amistad."
	var posibles := _parejas_posibles()
	pareja = posibles[0] if not posibles.is_empty() else "mel"

func _parejas_posibles() -> Array:
	var lista := CANDIDATOS.filter(func(p): return Progreso.afinidad(p) > 0)
	return lista if not lista.is_empty() else ["mel", "jayce"]

func _opciones_mensaje(col: VBoxContainer) -> void:
	col.add_child(Estilo.etiqueta("Elige pareja (quien ya te aprecia):", 17, Estilo.MARFIL, true))
	var fila := HFlowContainer.new()
	fila.alignment = FlowContainer.ALIGNMENT_CENTER
	col.add_child(fila)
	for p in _parejas_posibles():
		var b := Estilo.boton(Historia.nombre(p), 140, p == pareja)
		b.toggle_mode = true
		b.button_pressed = p == pareja
		b.pressed.connect(func():
			pareja = p
			for h in fila.get_children():
				h.button_pressed = h == b)
		fila.add_child(b)

func _empezar() -> void:
	notas = []
	combo = 0
	aciertos = 0
	total = 0
	fallos_seguidos = 0
	pisadas = 0
	afecto_inicio = Progreso.afinidad(pareja)
	var ritmo: float = PAREJAS.get(pareja, {}).get("ritmo", 0.55)
	var t := 1.5
	while t < DURACION - 1.0:
		var largo := 0.0
		if randf() < 0.12:
			largo = ritmo * 2.0
		notas.append({"t": t, "carril": randi() % 4, "largo": largo, "estado": 0})
		t += ritmo * (2.0 if largo > 0.0 else (1.0 if randf() < 0.7 else 0.5))

func _actualizar(delta: float) -> void:
	aviso_t -= delta
	for n in notas:
		if n["estado"] == 0 and tiempo > n["t"] + VENTANA:
			_fallo()
			n["estado"] = 2
		elif n["estado"] == 3:
			# Nota larga en curso: hay que mantener la tecla y ESPACIO.
			var c: int = n["carril"]
			if not (Input.is_key_pressed(TECLAS_C[c]) or Input.is_key_pressed(KEY_SPACE)):
				n["estado"] = 2
				_fallo()
			elif tiempo >= n["t"] + n["largo"]:
				n["estado"] = 1
				_acierto(true)
	if tiempo >= DURACION:
		var elegancia := _elegancia()
		puntos = aciertos * 10 + combo
		acabar(elegancia >= 0.7 and pisadas < 3, "Elegancia: %d %%%s" % [int(elegancia * 100), "" if pisadas == 0 else " · la has pisado %d %s" % [pisadas, "vez" if pisadas == 1 else "veces"]])

func _entrada(e: InputEvent) -> void:
	if not (e is InputEventKey and e.pressed and not e.echo):
		return
	var c := TECLAS_C.find(e.keycode)
	if c < 0:
		return
	var mejor = null
	for n in notas:
		if n["estado"] == 0 and n["carril"] == c and absf(n["t"] - tiempo) <= VENTANA * 1.6:
			mejor = n
			break
	if mejor == null:
		combo = 0
		return
	if absf(mejor["t"] - tiempo) <= VENTANA:
		if mejor["largo"] > 0.0:
			mejor["estado"] = 3
		else:
			mejor["estado"] = 1
			_acierto(false)
	else:
		mejor["estado"] = 2
		_fallo()

func _acierto(giro: bool) -> void:
	aciertos += 1
	total += 1
	combo += 1
	fallos_seguidos = 0
	if giro:
		_avisar("¡Giro!")

func _fallo() -> void:
	total += 1
	combo = 0
	fallos_seguidos += 1
	if fallos_seguidos >= 3:
		pisadas += 1
		fallos_seguidos = 0
		_avisar("¡La has pisado!")

func _elegancia() -> float:
	return 1.0 if total == 0 else float(aciertos) / float(total)

func _premio_extra() -> void:
	Progreso.cambiar_afinidad(pareja, 1)

func _avisar(t: String) -> void:
	aviso = t
	aviso_t = 1.0

func _chips() -> Array:
	return [["COMBO X %d" % combo, true], ["ELEGANCIA %d %%" % int(_elegancia() * 100)]]

func _rombo(c: Vector2, r: float, color: Color) -> void:
	for k in 3:
		var g := r + 14 - k * 4
		draw_colored_polygon(PackedVector2Array([c + Vector2(0, -g), c + Vector2(g, 0), c + Vector2(0, g), c + Vector2(-g, 0)]), Color(1, 0.85, 0.5, 0.08))
	var p := PackedVector2Array([c + Vector2(0, -r), c + Vector2(r, 0), c + Vector2(0, r), c + Vector2(-r, 0)])
	draw_colored_polygon(p, color)
	draw_colored_polygon(PackedVector2Array([c + Vector2(0, -r * 0.8), c + Vector2(r * 0.8, 0), c + Vector2(0, -r * 0.1), c + Vector2(-r * 0.8, 0)]), Color(1, 0.97, 0.85, 0.35))
	p.append(p[0])
	draw_polyline(p, Color(1, 0.97, 0.85), 2)

func _dibujar() -> void:
	# Arcos art déco y carriles.
	_arco_deco(497.0, 104.0, 222.0, P_ORO, 3.0)
	_arco_deco(533.0, 140.0, 222.0, Color(P_ORO, 0.55), 1.5)
	for k in 11:
		draw_line(Vector2(800, 104), Vector2(800, 104) + Vector2.from_angle(0.6 + k * 0.19) * 230, Color(P_ORO, 0.25), 1)
	for x in CARRILES:
		draw_rect(Rect2(x - 59, 96, 118, 662), Color(0.03, 0.06, 0.12, 0.45))
		draw_line(Vector2(x - 59, 96), Vector2(x - 59, 758), Color(P_ORO, 0.35), 1)
		draw_line(Vector2(x + 59, 96), Vector2(x + 59, 758), Color(P_ORO, 0.35), 1)
	draw_line(Vector2(533, LINEA_Y), Vector2(1085, LINEA_Y), Color(1, 0.9, 0.6), 3)
	for i in 4:
		var c := Vector2(CARRILES[i], LINEA_Y)
		draw_circle(c, 34, Color(0.03, 0.06, 0.12, 0.85))
		draw_arc(c, 34, 0, TAU, 48, P_ORO, 3)
		texto(c + Vector2(0, 10), LETRAS[i], 26, MARFIL, "titulo", 1)
	# Notas que caen.
	var oro := Color(0.93, 0.78, 0.45)
	for n in notas:
		if n["estado"] == 1 or n["estado"] == 2:
			continue
		var y := LINEA_Y - (float(n["t"]) - tiempo) / velocidad * (LINEA_Y - ARRIBA_Y)
		var x: float = CARRILES[n["carril"]]
		if n["largo"] > 0.0:
			var y2 := LINEA_Y - (float(n["t"]) + float(n["largo"]) - tiempo) / velocidad * (LINEA_Y - ARRIBA_Y)
			var alto_barra := minf(y, LINEA_Y) - maxf(y2, ARRIBA_Y)
			if alto_barra > 0.0:
				draw_rect(Rect2(x - 10, maxf(y2, ARRIBA_Y), 20, alto_barra), Color(oro, 0.55))
		if y >= ARRIBA_Y + 40 and y <= LINEA_Y + 40:
			_rombo(Vector2(x, minf(y, LINEA_Y)), 36, oro)
	# Pareja.
	panel(Rect2(101, 137, 358, 318))
	retrato(pareja, Vector2(280, 226), 66, P_ORO)
	texto(Vector2(280, 326), "PAREJA: %s" % Historia.nombre(pareja).to_upper(), 22, MARFIL, "titulo", 1)
	var frase: String = PAREJAS.get(pareja, {}).get("frase", "")
	if frase != "":
		parrafo(Rect2(140, 336, 280, 50), frase, 16, MARFIL, "italica", 1)
	texto(Vector2(123, 410), "Afecto ♥", 15, Z_ROSA)
	var afecto := clampf(float(Progreso.afinidad(pareja)) / 10.0, 0, 1)
	draw_rect(Rect2(123, 419, 314, 16), Color(0, 0, 0, 0.5))
	draw_rect(Rect2(123, 419, 314 * afecto, 16), Z_ROSA)
	draw_rect(Rect2(123, 419, 314, 16), Color(Z_ROSA, 0.8), false, 1.2)
	panel_info(Rect2(1196, 137, 302, 250), "Para qué sirve", ["Sube **Carisma**.", "Eliges pareja de baile entre quien ya te aprecia: sube su **afecto** o su **amistad**.", "La música cambia según la pareja: vals para Mel, algo más rápido para Jayce."])
	if aviso_t > 0.0:
		texto(Vector2(809, 600), aviso, 30, Color(MARFIL, clampf(aviso_t, 0, 1)), "titulo", 1)

# Arco art déco: dos patas rectas y una cornisa ligeramente curva (como en el diseño).
func _arco_deco(izq: float, cima: float, pie: float, col: Color, grosor: float) -> void:
	var der := 1600.0 - izq
	var media := (der - izq) / 2.0
	var flecha := 46.0
	var radio := (media * media + flecha * flecha) / (2.0 * flecha)
	var centro := Vector2(800, cima + radio)
	var a0 := atan2(cima + flecha - centro.y, izq - 800.0)
	var a1 := atan2(cima + flecha - centro.y, der - 800.0)
	draw_arc(centro, radio, a0, a1, 64, col, grosor)
	draw_line(Vector2(izq, cima + flecha), Vector2(izq, pie), col, grosor)
	draw_line(Vector2(der, cima + flecha), Vector2(der, pie), col, grosor)
