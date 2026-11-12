extends "res://escenas/juego/minijuegos/minijuego.gd"

# El foso (diseño: minijuegos_capturas/mj_foso.jpg).
# Sevika avisa con un gesto, el aro se cierra en menos de un segundo y, si pulsas la tecla
# correcta a tiempo, aciertas. Acertar seguido llena el furor; con el furor lleno, ESPACIO
# lanza un golpe que no se puede bloquear. Vi te respeta si ganas limpio; Sevika, si ganas como sea.

const GESTOS := [
	["Sevika baja la guardia un instante…", "J", "GOLPE"],
	["Sevika carga el brazo mecánico…", "K", "ESQUIVA"],
	["Sevika lanza un directo con la izquierda…", "L", "BLOQUEO"],
]
const TECLA := {KEY_J: "J", KEY_K: "K", KEY_L: "L"}
const RADIO_BLANCO := 58.0
const RADIO_INICIO := 110.0

var vida_tu := 1.0
var vida_sevika := 1.0
var furor := 0.0
var asalto := 1
var asaltos_ganados := 0
var asaltos_perdidos := 0
var gesto := 0
var aro := 0.0          # 1 = recién empezado, 0 = cerrado
var duracion_aro := 0.9
var espera := 1.0
var aviso := ""
var aviso_t := 0.0
var uso_furor := false
var recibio_golpes := false

func _configurar() -> void:
	nombre = "El foso"
	subtitulo = "Bajo La Última Gota · Valor"
	ciudad = "Zaun"
	estadistica = "valor"
	fondo_ruta = "res://assets/lugares/s1/zaun-ultima-gota-bar.jpg"
	oscurecer = 0.72
	como_se_juega = "Lee el gesto de Sevika. Cuando el aro rosa se cierre sobre el blanco, pulsa la acción que pide: golpe, esquiva o bloqueo. Acertar seguido llena el furor; con el furor lleno, ESPACIO lanza un golpe que no se puede bloquear."
	teclas = [["J", "golpe"], ["K", "esquiva"], ["L", "bloqueo"], ["ESPACIO", "furor"]]
	instrucciones = como_se_juega + "\n\nSe pelea a tres asaltos: gana quien se lleve dos. Si pulsas tarde, demasiado pronto o la tecla equivocada, Sevika te golpea.\n\nVi te respeta si ganas limpio (sin usar el furor y sin perder un asalto). Sevika te respeta si ganas como sea."

func _empezar() -> void:
	asalto = 1
	asaltos_ganados = 0
	asaltos_perdidos = 0
	uso_furor = false
	recibio_golpes = false
	_nuevo_asalto()

func _nuevo_asalto() -> void:
	vida_tu = 1.0
	vida_sevika = 1.0
	furor = 0.0
	aro = 0.0
	espera = 1.2

func _nuevo_gesto() -> void:
	gesto = randi() % GESTOS.size()
	duracion_aro = randf_range(0.65, 0.95)
	aro = 1.0

func _actualizar(delta: float) -> void:
	aviso_t -= delta
	if aro > 0.0:
		aro -= delta / duracion_aro
		if aro <= -0.18:
			_fallo("Demasiado tarde.")
	else:
		espera -= delta
		if espera <= 0.0:
			_nuevo_gesto()

func _radio() -> float:
	return RADIO_BLANCO + (RADIO_INICIO - RADIO_BLANCO) * maxf(aro, 0.0)

func _entrada(e: InputEvent) -> void:
	if not (e is InputEventKey and e.pressed and not e.echo):
		return
	if e.keycode == KEY_SPACE:
		if furor >= 1.0:
			furor = 0.0
			uso_furor = true
			_danio_sevika(0.3, "¡Golpe de furor!")
		return
	if not TECLA.has(e.keycode) or aro <= -0.5:
		return
	if aro > 0.25 or aro == 0.0:
		_fallo("Demasiado pronto.")
		return
	if TECLA[e.keycode] != GESTOS[gesto][1]:
		_fallo("No era eso.")
		return
	furor = minf(furor + 0.34, 1.0)
	puntos += 10
	_danio_sevika(0.14 if GESTOS[gesto][1] == "J" else 0.09, "¡Bien leído!")

func _danio_sevika(n: float, texto_aviso: String) -> void:
	vida_sevika -= n
	aro = 0.0
	espera = randf_range(0.5, 1.0)
	_avisar(texto_aviso)
	if vida_sevika <= 0.0:
		asaltos_ganados += 1
		_fin_asalto()

func _fallo(texto_aviso: String) -> void:
	vida_tu -= 0.2
	furor = 0.0
	recibio_golpes = true
	aro = 0.0
	espera = randf_range(0.6, 1.1)
	_avisar(texto_aviso)
	if vida_tu <= 0.0:
		asaltos_perdidos += 1
		_fin_asalto()

func _fin_asalto() -> void:
	if asaltos_ganados >= 2 or asaltos_perdidos >= 2:
		var gano := asaltos_ganados >= 2
		var limpio := gano and not uso_furor and asaltos_perdidos == 0
		acabar(gano, ("Has ganado limpio: Vi te respeta." if limpio else "Has ganado como sea: Sevika te respeta.") if gano else "Sevika te ha tumbado.")
		return
	asalto += 1
	_nuevo_asalto()

func _premio_extra() -> void:
	if not uso_furor and asaltos_perdidos == 0:
		Progreso.cambiar_afinidad("vi", 1)
	else:
		Progreso.cambiar_afinidad("sevika", 1)

func _avisar(t: String) -> void:
	aviso = t
	aviso_t = 1.0

func _chips() -> Array:
	return [["ASALTO %d / 3" % mini(asalto, 3)], ["APUESTAS 3 : 1", true]]

func _dibujar() -> void:
	# Foco cenital.
	draw_colored_polygon(PackedVector2Array([Vector2(745, 92), Vector2(855, 92), Vector2(1080, 780), Vector2(520, 780)]), Color(1, 0.92, 0.75, 0.10))
	draw_line(Vector2(0, 735), Vector2(1600, 735), Color(Z_SHIMMER, 0.25), 2)
	# Tú, de espaldas y en sombra.
	_silueta(Vector2(415, 780))
	# Sevika entera a la derecha.
	var sev := cargar("res://assets/personajes/s1/sevika.webp")
	if sev:
		var alto := 600.0
		var ancho := alto * sev.get_size().x / sev.get_size().y
		imagen_difuminada(sev, Rect2(Vector2(980 - ancho / 2, 185), Vector2(ancho, alto)))
	# Barras.
	retrato("tu", Vector2(98, 158), 36, Z_SHIMMER)
	texto(Vector2(152, 140), "TÚ", 22, MARFIL, "titulo")
	barra(Rect2(152, 149, 468, 18), vida_tu, Z_SHIMMER)
	barra(Rect2(152, 174, 468, 7), furor, P_ORO)
	texto(Vector2(152, 197), _espaciado("Furor"), 11, P_ORO, "titulo")
	retrato("sevika", Vector2(1500, 158), 36, Z_ROSA)
	texto(Vector2(1447, 156), "SEVIKA", 22, MARFIL, "titulo", 2)
	draw_rect(Rect2(980, 163, 468, 18), Color(0, 0, 0, 0.5))
	draw_rect(Rect2(980 + 468 * (1.0 - clampf(vida_sevika, 0, 1)), 163, 468 * clampf(vida_sevika, 0, 1), 18), Z_ROSA)
	draw_rect(Rect2(980, 163, 468, 18), Color(Z_ROSA, 0.8), false, 1.2)
	# Para qué sirve.
	panel_info(Rect2(40, 250, 290, 207), "Para qué sirve", ["Sube **Valor**.", "Ganas piezas apostando.", "Vi te respeta más si ganas limpio. Sevika, si ganas como sea."])
	draw_rect(Rect2(40, 250, 4, 207), Z_ROSA)
	# Aro.
	var c := Vector2(1000, 420)
	if aro > -0.18 and aro != 0.0:
		draw_arc(c, _radio() * 1.0 if aro > 0 else RADIO_BLANCO, 0, TAU, 64, Z_ROSA, 5)
		draw_circle(c, RADIO_BLANCO - 3, Color(0, 0, 0, 0.45))
		draw_arc(c, RADIO_BLANCO - 3, 0, TAU, 64, Color.WHITE, 4)
		texto(c + Vector2(0, 12), GESTOS[gesto][1], 38, Color.WHITE, "titulo", 1)
		texto(c + Vector2(0, 38), GESTOS[gesto][2], 17, Color.WHITE, "titulo", 1)
		texto(Vector2(1130, 375), GESTOS[gesto][0], 17, MARFIL, "italica")
	if aviso_t > 0.0:
		texto(Vector2(800, 260), aviso, 28, Color(MARFIL, clampf(aviso_t, 0, 1)), "titulo", 1)

# Silueta oscura con borde (el jugador de espaldas).
func _silueta(pie: Vector2) -> void:
	var cuerpo := PackedVector2Array([
		pie + Vector2(-70, 0), pie + Vector2(-55, -230), pie + Vector2(-80, -300), pie + Vector2(-70, -420),
		pie + Vector2(-35, -455), pie + Vector2(-20, -470), pie + Vector2(-30, -520), pie + Vector2(-5, -555),
		pie + Vector2(25, -545), pie + Vector2(30, -500), pie + Vector2(20, -470), pie + Vector2(55, -455),
		pie + Vector2(85, -410), pie + Vector2(80, -300), pie + Vector2(60, -230), pie + Vector2(70, 0),
		pie + Vector2(15, 0), pie + Vector2(0, -200), pie + Vector2(-15, 0),
	])
	draw_colored_polygon(cuerpo, Color(0.03, 0.02, 0.04, 0.95))
	cuerpo.append(cuerpo[0])
	draw_polyline(cuerpo, Color(Z_SHIMMER, 0.75), 1.5)
