extends "res://escenas/juego/minijuegos/minijuego.gd"

# Grafiti: repasa con el spray el boceto de tiza de la pared.

var trazos: Array = []      # lista de puntos [pos, pintado]
var pintura: Array = []     # manchas de spray
var pintando := false
var dibujo := 0

func _configurar() -> void:
	nombre = "Grafiti"
	como_se_juega = "Mantén pulsado el ratón y repasa el boceto de tiza de la pared. Cada punto que cubras suma. Cuando termines un dibujo aparece otro."
	teclas = "CLIC SOSTENIDO  pintar"
	duracion = 45.0
	objetivo = 60

func _empezar() -> void:
	dibujo = 0
	_nuevo_dibujo()

func _nuevo_dibujo() -> void:
	trazos = []
	pintura = []
	var s := tam()
	var c := s / 2.0
	var r := minf(s.x, s.y) * 0.32
	match dibujo % 3:
		0: # Estrella de cinco puntas.
			for i in 50:
				var a := i / 50.0 * TAU * 2.0
				var rad := r * (1.0 if i % 10 < 5 else 0.45)
				trazos.append([c + Vector2.from_angle(a / 2.0 - PI / 2) * rad, false])
		1: # Cara sonriente.
			for i in 36:
				trazos.append([c + Vector2.from_angle(i / 36.0 * TAU) * r, false])
			for i in 14:
				trazos.append([c + Vector2.from_angle(0.3 + i / 14.0 * (PI - 0.6)) * r * 0.55, false])
			trazos.append([c + Vector2(-r * 0.35, -r * 0.3), false])
			trazos.append([c + Vector2(r * 0.35, -r * 0.3), false])
		2: # Engranaje.
			for i in 48:
				var a2 := i / 48.0 * TAU
				var dientes := 1.0 if int(i / 3) % 2 == 0 else 0.82
				trazos.append([c + Vector2.from_angle(a2) * r * dientes, false])
			for i in 18:
				trazos.append([c + Vector2.from_angle(i / 18.0 * TAU) * r * 0.3, false])

func _entrada_raton(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT:
		pintando = e.pressed
	if (e is InputEventMouseMotion or e is InputEventMouseButton) and pintando:
		_pintar(e.position)

func _pintar(p: Vector2) -> void:
	pintura.append(p)
	if pintura.size() > 1500:
		pintura.pop_front()
	var quedan := false
	for t in trazos:
		if not t[1] and t[0].distance_to(p) < 22:
			t[1] = true
			sumar(1)
		if not t[1]:
			quedan = true
	if not quedan:
		dibujo += 1
		sumar(5)
		_nuevo_dibujo()

func _dibujar() -> void:
	var s := tam()
	area.draw_rect(Rect2(Vector2.ZERO, s), Color(0.18, 0.16, 0.17))
	# Ladrillos.
	for fila in int(s.y / 40) + 1:
		for col in int(s.x / 90) + 2:
			var x := col * 90 - (45 if fila % 2 else 0)
			area.draw_rect(Rect2(x, fila * 40, 88, 38), Color(0.22, 0.19, 0.2))
	for t in trazos:
		area.draw_circle(t[0], 6, Color(1, 1, 1, 0.45) if not t[1] else Color(1, 1, 1, 0.0))
	for p in pintura:
		area.draw_circle(p, 13, Color("#C24DE0", 0.55) if Estilo.es_zaun() else Color(0.95, 0.4, 0.75, 0.55))
