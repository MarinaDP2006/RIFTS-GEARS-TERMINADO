extends "res://escenas/juego/minijuegos/minijuego.gd"

# El Foso: pelea a puñetazos. El rival anuncia por dónde ataca: esquiva hacia el otro lado
# y contraataca cuando baja la guardia.

enum Fase { ESPERA, AVISO, GOLPE, HUECO }

var fase := Fase.ESPERA
var t := 1.0
var lado := 0          # -1 ataca por la izquierda, 1 por la derecha
var esquiva := 0
var vida := 5
var mensaje := ""

func _configurar() -> void:
	nombre = "El Foso"
	como_se_juega = "Cuando el rival levante un brazo, esquiva hacia el lado contrario. Si baja la guardia (se pone en dorado), golpea. Cada golpe tuyo suma un punto; cada golpe recibido te quita vida."
	teclas = "← →  esquivar   ·   ESPACIO  golpear"
	duracion = 45.0
	objetivo = 8

func _empezar() -> void:
	vida = 5
	fase = Fase.ESPERA
	t = 1.0

func _actualizar(delta: float) -> void:
	t -= delta
	if t > 0.0:
		return
	match fase:
		Fase.ESPERA:
			fase = Fase.AVISO
			lado = -1 if randf() < 0.5 else 1
			esquiva = 0
			t = maxf(0.35, 0.8 - puntos * 0.04)
		Fase.AVISO:
			fase = Fase.GOLPE
			t = 0.25
			if esquiva != -lado:
				vida -= 1
				mensaje = "¡Te ha dado!"
				if vida <= 0:
					_acabar()
			else:
				mensaje = "Esquivado"
		Fase.GOLPE:
			fase = Fase.HUECO
			t = 0.7
		Fase.HUECO:
			fase = Fase.ESPERA
			t = randf_range(0.5, 1.2)
			esquiva = 0

func _entrada(e: InputEvent) -> void:
	if e.is_action_pressed("ui_left"):
		esquiva = -1
	elif e.is_action_pressed("ui_right"):
		esquiva = 1
	elif e.is_action_pressed("ui_accept") or (e is InputEventKey and e.pressed and e.keycode == KEY_SPACE and not e.echo):
		if fase == Fase.HUECO:
			sumar(1)
			mensaje = "¡Golpe!"
			fase = Fase.ESPERA
			t = randf_range(0.5, 1.0)
		else:
			mensaje = "Tiene la guardia alta"

func _dibujar() -> void:
	var s := tam()
	area.draw_rect(Rect2(Vector2.ZERO, s), Color(0.07, 0.05, 0.05))
	area.draw_circle(Vector2(s.x / 2, s.y * 0.9), s.x * 0.45, Color(0.12, 0.09, 0.08))
	# Rival: silueta geométrica.
	var c := Vector2(s.x / 2, s.y * 0.45)
	var color := Estilo.DORADO if fase == Fase.HUECO else Color(0.15, 0.13, 0.13)
	area.draw_rect(Rect2(c.x - 60, c.y - 40, 120, 170), color)
	area.draw_circle(c + Vector2(0, -80), 40, color)
	var brazo_izq := c + Vector2(-110, -120 if fase == Fase.AVISO and lado == -1 else 20)
	var brazo_der := c + Vector2(110, -120 if fase == Fase.AVISO and lado == 1 else 20)
	area.draw_line(c + Vector2(-60, -20), brazo_izq, color, 22)
	area.draw_line(c + Vector2(60, -20), brazo_der, color, 22)
	if fase == Fase.AVISO:
		texto(Vector2(s.x / 2 + lado * 260, s.y * 0.25), "¡ATACA!", 30, Color(0.95, 0.35, 0.3))
	# Tus puños.
	var x := s.x / 2 + esquiva * 180
	area.draw_circle(Vector2(x - 80, s.y - 40), 34, Estilo.acento().darkened(0.2))
	area.draw_circle(Vector2(x + 80, s.y - 40), 34, Estilo.acento().darkened(0.2))
	texto(Vector2(120, 30), "Vida " + "♥".repeat(max(vida, 0)), 24, Color(0.9, 0.3, 0.35), false)
	texto(Vector2(s.x / 2, s.y * 0.12), mensaje, 24, Estilo.MARFIL)
