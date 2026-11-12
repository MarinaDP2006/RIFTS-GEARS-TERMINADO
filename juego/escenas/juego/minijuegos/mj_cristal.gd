extends "res://escenas/juego/minijuegos/minijuego.gd"

# Cristal hextech: mantén la energía del cristal dentro de la franja estable.
# La energía se desvía sola; compénsala con ← →.

var energia := 0.5
var deriva := 0.0
var cambio := 0.0
var en_zona := 0.0
var centro := 0.5
var ancho_zona := 0.18

func _configurar() -> void:
	nombre = "Cristal hextech"
	como_se_juega = "La aguja marca la energía del cristal. Mantenla dentro de la franja azul: cada segundo seguido dentro suma un punto. Si se sale, el cristal se recalienta."
	teclas = "←  bajar energía   ·   →  subir energía"
	duracion = 40.0
	objetivo = 20

func _empezar() -> void:
	energia = 0.5
	deriva = 0.0
	centro = 0.5
	en_zona = 0.0

func _actualizar(delta: float) -> void:
	cambio -= delta
	if cambio <= 0.0:
		deriva = randf_range(-0.35, 0.35)
		cambio = randf_range(0.6, 1.6)
	centro = 0.5 + sin((duracion - tiempo) * 0.6) * 0.25
	var control := Input.get_axis("ui_left", "ui_right")
	energia = clampf(energia + (deriva + control * 0.75) * delta, 0.0, 1.0)
	if absf(energia - centro) < ancho_zona / 2.0:
		en_zona += delta
		if en_zona >= 1.0:
			en_zona -= 1.0
			sumar(1)
	else:
		en_zona = 0.0

func _dibujar() -> void:
	var s := tam()
	area.draw_rect(Rect2(Vector2.ZERO, s), Color(0.03, 0.05, 0.09))
	var c := Vector2(s.x / 2, s.y * 0.42)
	# Cristal hexagonal.
	var puntos_hex := PackedVector2Array()
	for i in 6:
		puntos_hex.append(c + Vector2.from_angle(i * TAU / 6.0 + PI / 6.0) * 110.0)
	var dentro := absf(energia - centro) < ancho_zona / 2.0
	var color_cristal := Color(0.3, 0.8, 1.0) if dentro else Color(1.0, 0.45, 0.25)
	area.draw_colored_polygon(puntos_hex, color_cristal.darkened(0.4))
	puntos_hex.append(puntos_hex[0])
	area.draw_polyline(puntos_hex, color_cristal, 4)
	area.draw_circle(c, 30 + 10 * sin(Time.get_ticks_msec() / 150.0), color_cristal)
	# Medidor.
	var barra := Rect2(80, s.y * 0.8, s.x - 160, 30)
	area.draw_rect(barra, Color(0.12, 0.12, 0.15))
	area.draw_rect(Rect2(barra.position.x + barra.size.x * (centro - ancho_zona / 2.0), barra.position.y, barra.size.x * ancho_zona, 30), Color(0.25, 0.6, 0.95, 0.7))
	var x := barra.position.x + barra.size.x * energia
	area.draw_line(Vector2(x, barra.position.y - 14), Vector2(x, barra.end.y + 14), Estilo.MARFIL, 5)
	texto(Vector2(s.x / 2, s.y * 0.72), "ESTABLE" if dentro else "INESTABLE", 24, color_cristal)
