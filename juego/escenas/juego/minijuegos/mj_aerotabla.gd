extends "res://escenas/juego/minijuegos/minijuego.gd"

# Aerotabla: carrera por los tejados con siluetas negras sobre un cielo de humo.
# Salta los obstáculos bajos y agáchate bajo las tuberías.

var y := 0.0
var vy := 0.0
var agachado := false
var obstaculos: Array = []   # [x, tipo] tipo 0 = bajo (saltar), 1 = alto (agacharse)
var velocidad := 420.0
var espera := 1.0
var golpe := 0.0
var distancia := 0.0

func _configurar() -> void:
	nombre = "Aerotabla"
	como_se_juega = "Corre por los tejados de Zaun. Salta las cajas y agáchate bajo las tuberías. Cada obstáculo superado suma un punto."
	teclas = "↑ / ESPACIO  saltar   ·   ↓  agacharse"
	duracion = 45.0
	objetivo = 15

func _empezar() -> void:
	y = 0.0
	vy = 0.0
	obstaculos = []
	velocidad = 420.0
	espera = 1.0
	distancia = 0.0

func _suelo() -> float:
	return tam().y * 0.78

func _actualizar(delta: float) -> void:
	velocidad += delta * 8.0
	distancia += velocidad * delta
	vy += 2200.0 * delta
	y = minf(0.0, y + vy * delta)
	if y == 0.0:
		vy = 0.0
	agachado = Input.is_action_pressed("ui_down") and y == 0.0
	golpe = maxf(0.0, golpe - delta)
	espera -= delta
	if espera <= 0.0:
		obstaculos.append([tam().x + 40.0, randi() % 2, false])
		espera = randf_range(0.8, 1.5) * 420.0 / velocidad
	var jx := tam().x * 0.2
	for o in obstaculos:
		o[0] -= velocidad * delta
		if not o[2] and absf(o[0] - jx) < 30.0:
			var choca: bool = (o[1] == 0 and y > -60.0) or (o[1] == 1 and not agachado)
			if choca:
				o[2] = true
				golpe = 0.4
				sumar(-1)
		if not o[2] and o[0] < jx - 30.0:
			o[2] = true
			sumar(1)
	obstaculos = obstaculos.filter(func(o): return o[0] > -80.0)

func _entrada(e: InputEvent) -> void:
	if (e.is_action_pressed("ui_up") or e.is_action_pressed("ui_accept") or (e is InputEventKey and e.pressed and e.keycode == KEY_SPACE)) and y == 0.0:
		vy = -900.0

func _dibujar() -> void:
	var s := tam()
	var cielo_arriba := Color(0.55, 0.32, 0.5) if Estilo.es_zaun() else Color(0.85, 0.6, 0.35)
	area.draw_rect(Rect2(Vector2.ZERO, s), cielo_arriba.darkened(0.55))
	area.draw_rect(Rect2(0, s.y * 0.45, s.x, s.y * 0.55), cielo_arriba.darkened(0.35))
	# Edificios lejanos con paralaje.
	for i in 12:
		var ancho := 140.0
		var x := fposmod(i * 170.0 - distancia * 0.25, s.x + 200.0) - 100.0
		var alto := 120.0 + (i * 53 % 180)
		area.draw_rect(Rect2(x, s.y * 0.7 - alto, ancho, alto), Color(0.05, 0.04, 0.06, 0.6))
	# Tejados donde se corre.
	area.draw_rect(Rect2(0, _suelo(), s.x, s.y - _suelo()), Color.BLACK)
	for o in obstaculos:
		if o[1] == 0:
			area.draw_rect(Rect2(o[0] - 22, _suelo() - 44, 44, 44), Color.BLACK)
		else:
			area.draw_rect(Rect2(o[0] - 40, _suelo() - 150, 80, 22), Color.BLACK)
			area.draw_line(Vector2(o[0], 0), Vector2(o[0], _suelo() - 150), Color.BLACK, 6)
	# Silueta del corredor (figura original de palos).
	var jx := s.x * 0.2
	var base := Vector2(jx, _suelo() + y)
	var c := Color(0.9, 0.2, 0.2) if golpe > 0.0 else Color.BLACK
	var altura := 46.0 if agachado else 86.0
	area.draw_line(base + Vector2(-30, 0), base + Vector2(30, 0), c, 6)  # tabla
	area.draw_line(base + Vector2(0, -6), base + Vector2(0, -altura * 0.55), c, 8)
	area.draw_circle(base + Vector2(4, -altura), 12, c)
	area.draw_line(base + Vector2(0, -altura * 0.75), base + Vector2(20, -altura * 0.6), c, 6)
	area.draw_line(base + Vector2(0, -altura * 0.75), base + Vector2(-18, -altura * 0.5), c, 6)
	area.draw_line(base + Vector2(0, -altura * 0.55), base + Vector2(0, -altura * 0.8), c, 8)
