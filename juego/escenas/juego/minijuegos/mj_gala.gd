extends "res://escenas/juego/minijuegos/minijuego.gd"

# Baile de gala: las flechas suben al compás; pulsa la flecha cuando pase por la línea dorada.

const DIRECCIONES := ["ui_left", "ui_down", "ui_up", "ui_right"]
const SIMBOLOS := ["←", "↓", "↑", "→"]

var notas: Array = []   # [columna, y, resuelta]
var espera := 0.0
var velocidad := 260.0
var mensaje := ""
var mensaje_t := 0.0

func _configurar() -> void:
	nombre = "Baile de gala"
	como_se_juega = "Las flechas suben por la pista. Cuando una pase por la línea dorada, pulsa la misma flecha. Si fallas o llegas tarde, pierdes el paso."
	teclas = "← ↓ ↑ →  dar el paso"
	duracion = 45.0
	objetivo = 30

func _empezar() -> void:
	notas = []
	espera = 0.5

func _linea() -> float:
	return 90.0

func _columna_x(c: int) -> float:
	return tam().x / 2 - 225 + c * 150 + 75

func _actualizar(delta: float) -> void:
	espera -= delta
	mensaje_t = maxf(0.0, mensaje_t - delta)
	if espera <= 0.0:
		notas.append([randi() % 4, tam().y + 40, false])
		espera = randf_range(0.35, 0.75)
	for n in notas:
		n[1] -= velocidad * delta
		if not n[2] and n[1] < _linea() - 50:
			n[2] = true
			sumar(-1)
			mensaje = "Tarde"
			mensaje_t = 0.4
	notas = notas.filter(func(n): return n[1] > -60)

func _entrada(e: InputEvent) -> void:
	for c in 4:
		if e.is_action_pressed(DIRECCIONES[c]):
			var mejor = null
			for n in notas:
				if n[0] == c and not n[2] and absf(n[1] - _linea()) < 45:
					mejor = n
					break
			if mejor:
				mejor[2] = true
				var perfecto: bool = absf(mejor[1] - _linea()) < 15
				sumar(2 if perfecto else 1)
				mensaje = "¡Perfecto!" if perfecto else "Bien"
			else:
				sumar(-1)
				mensaje = "Fuera de compás"
			mensaje_t = 0.4

func _dibujar() -> void:
	var s := tam()
	area.draw_rect(Rect2(Vector2.ZERO, s), Color(0.06, 0.05, 0.1))
	for c in 4:
		var x := _columna_x(c)
		area.draw_rect(Rect2(x - 60, 0, 120, s.y), Color(1, 1, 1, 0.03))
		texto(Vector2(x, _linea()), SIMBOLOS[c], 40, Color(1, 1, 1, 0.25))
	area.draw_line(Vector2(_columna_x(0) - 70, _linea()), Vector2(_columna_x(3) + 70, _linea()), Estilo.DORADO, 3)
	for n in notas:
		if not n[2]:
			var p := Vector2(_columna_x(n[0]), n[1])
			area.draw_circle(p, 38, Estilo.acento().darkened(0.3))
			texto(p, SIMBOLOS[n[0]], 40, Estilo.MARFIL)
	if mensaje_t > 0.0:
		texto(Vector2(s.x / 2, s.y * 0.55), mensaje, 34, Estilo.MARFIL)
