extends "res://escenas/juego/minijuegos/minijuego.gd"

# Tiro de precisión: dianas que aparecen y se encogen. Cuanto más cerca del centro, más puntos.

var dianas: Array = []   # [pos, radio, vida]
var espera := 0.0
var disparos: Array = []

func _configurar() -> void:
	nombre = "Tiro de precisión"
	como_se_juega = "Apunta con el ratón y dispara a las dianas antes de que desaparezcan. El centro vale 3 puntos, el anillo medio 2 y el exterior 1."
	teclas = "RATÓN  apuntar   ·   CLIC  disparar"
	duracion = 40.0
	objetivo = 40

func _empezar() -> void:
	dianas = []
	disparos = []
	espera = 0.3

func _actualizar(delta: float) -> void:
	espera -= delta
	if espera <= 0.0:
		var s := tam()
		dianas.append([Vector2(randf_range(60, s.x - 60), randf_range(60, s.y - 60)), 48.0, 2.2])
		espera = randf_range(0.5, 1.0)
	for d in dianas:
		d[2] -= delta
		d[1] = 48.0 * clampf(d[2] / 2.2, 0.35, 1.0)
	dianas = dianas.filter(func(d): return d[2] > 0.0)
	for p in disparos:
		p[1] -= delta
	disparos = disparos.filter(func(p): return p[1] > 0.0)

func _entrada_raton(e: InputEvent) -> void:
	if not (e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT):
		return
	disparos.append([e.position, 0.3])
	for d in dianas:
		var dist: float = d[0].distance_to(e.position)
		if dist < d[1]:
			sumar(3 if dist < d[1] / 3.0 else (2 if dist < d[1] * 2.0 / 3.0 else 1))
			dianas.erase(d)
			return

func _dibujar() -> void:
	var s := tam()
	area.draw_rect(Rect2(Vector2.ZERO, s), Color(0.09, 0.1, 0.12))
	for d in dianas:
		area.draw_circle(d[0], d[1], Color(0.9, 0.88, 0.8))
		area.draw_circle(d[0], d[1] * 2.0 / 3.0, Color(0.2, 0.3, 0.5))
		area.draw_circle(d[0], d[1] / 3.0, Estilo.acento())
	for p in disparos:
		area.draw_circle(p[0], 5, Color(1, 0.9, 0.5, p[1] / 0.3))
	var m := area.get_local_mouse_position()
	area.draw_arc(m, 16, 0, TAU, 24, Estilo.MARFIL, 2)
	area.draw_line(m - Vector2(24, 0), m + Vector2(24, 0), Estilo.MARFIL, 1)
	area.draw_line(m - Vector2(0, 24), m + Vector2(0, 24), Estilo.MARFIL, 1)
