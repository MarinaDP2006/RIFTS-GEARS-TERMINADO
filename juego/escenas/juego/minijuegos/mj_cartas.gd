extends "res://escenas/juego/minijuegos/minijuego.gd"

# Cartas: memoria de parejas en una mesa de La Última Gota.

const SIMBOLOS := ["⚙", "✦", "♠", "♥", "♦", "♣", "☾", "✚"]
const COLUMNAS := 4
const FILAS := 4

var cartas: Array = []      # [simbolo, descubierta, resuelta]
var abiertas: Array = []
var espera := 0.0
var parejas := 0

func _configurar() -> void:
	nombre = "Cartas"
	como_se_juega = "Da la vuelta a dos cartas. Si son iguales, se quedan boca arriba. Encuentra todas las parejas antes de que se acabe el tiempo."
	teclas = "CLIC  dar la vuelta a una carta"
	duracion = 60.0
	objetivo = 8

func _empezar() -> void:
	cartas = []
	for s in SIMBOLOS:
		cartas.append([s, false, false])
		cartas.append([s, false, false])
	cartas.shuffle()
	abiertas = []
	parejas = 0

func _rect(i: int) -> Rect2:
	var s := tam()
	var ancho := minf(150.0, (s.x - 100) / COLUMNAS)
	var alto := minf(110.0, (s.y - 40) / FILAS - 14)
	var total := Vector2(COLUMNAS * (ancho + 14), FILAS * (alto + 14))
	var origen := (s - total) / 2.0
	return Rect2(origen + Vector2((i % COLUMNAS) * (ancho + 14), (i / COLUMNAS) * (alto + 14)), Vector2(ancho, alto))

func _actualizar(delta: float) -> void:
	if espera > 0.0:
		espera -= delta
		if espera <= 0.0:
			for i in abiertas:
				cartas[i][1] = false
			abiertas = []

func _entrada_raton(e: InputEvent) -> void:
	if not (e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT) or espera > 0.0:
		return
	for i in cartas.size():
		if _rect(i).has_point(e.position) and not cartas[i][1] and not cartas[i][2]:
			cartas[i][1] = true
			abiertas.append(i)
			if abiertas.size() == 2:
				if cartas[abiertas[0]][0] == cartas[abiertas[1]][0]:
					cartas[abiertas[0]][2] = true
					cartas[abiertas[1]][2] = true
					abiertas = []
					sumar(1)
					parejas += 1
					if parejas == SIMBOLOS.size():
						_acabar()
				else:
					espera = 0.8
			area.queue_redraw()
			return

func _dibujar() -> void:
	var s := tam()
	area.draw_rect(Rect2(Vector2.ZERO, s), Color(0.06, 0.14, 0.1))
	for i in cartas.size():
		var r := _rect(i)
		var c: Array = cartas[i]
		if c[1] or c[2]:
			area.draw_rect(r, Color(0.94, 0.9, 0.8))
			area.draw_rect(r, Estilo.acento() if c[2] else Color(0.4, 0.35, 0.3), false, 3)
			texto(r.get_center(), c[0], 42, Color(0.6, 0.1, 0.15) if c[0] in ["♥", "♦"] else Color(0.1, 0.1, 0.12))
		else:
			area.draw_rect(r, Estilo.fondo_panel_claro())
			area.draw_rect(r, Estilo.acento(), false, 2)
			texto(r.get_center(), "R&G", 22, Estilo.acento())
