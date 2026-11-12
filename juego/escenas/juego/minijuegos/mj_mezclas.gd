extends "res://escenas/juego/minijuegos/minijuego.gd"

# Mezclas: memoriza la receta que se ilumina y repítela con los cuatro frascos.

const FRASCOS := [
	["Ácido", Color(0.55, 0.85, 0.3)], ["Sal de Zaun", Color(0.9, 0.85, 0.7)],
	["Brillo", Color("#C24DE0")], ["Aceite", Color(0.85, 0.55, 0.2)],
]

var receta: Array = []
var paso := 0
var mostrando := true
var t := 0.0
var iluminado := -1
var mensaje := ""

func _configurar() -> void:
	nombre = "Mezclas"
	como_se_juega = "Fíjate en el orden en que se iluminan los frascos y repítelo. Cada receta completa suma su longitud; un fallo vuelve a empezar la receta."
	teclas = "1  2  3  4  añadir frasco"
	duracion = 60.0
	objetivo = 20

func _empezar() -> void:
	receta = []
	for i in 3:
		receta.append(randi() % 4)
	_mostrar()

func _mostrar() -> void:
	mostrando = true
	paso = 0
	t = 0.6

func _actualizar(delta: float) -> void:
	if not mostrando:
		iluminado = -1 if t <= 0.0 else iluminado
		t -= delta
		return
	t -= delta
	if t <= 0.0:
		if paso < receta.size():
			iluminado = receta[paso]
			paso += 1
			t = 0.65
		else:
			iluminado = -1
			mostrando = false
			paso = 0
			mensaje = "Tu turno"
	elif t < 0.2:
		iluminado = -1

func _entrada(e: InputEvent) -> void:
	if mostrando or not (e is InputEventKey and e.pressed and not e.echo):
		return
	var i: int = e.keycode - KEY_1
	if i < 0 or i > 3:
		return
	iluminado = i
	t = 0.2
	if receta[paso] == i:
		paso += 1
		if paso == receta.size():
			sumar(receta.size())
			mensaje = "¡Mezcla perfecta!"
			receta.append(randi() % 4)
			_mostrar()
	else:
		mensaje = "La mezcla ha echado humo..."
		_mostrar()

func _dibujar() -> void:
	var s := tam()
	area.draw_rect(Rect2(Vector2.ZERO, s), Color(0.05, 0.07, 0.06))
	for i in 4:
		var x := s.x / 2 - 330 + i * 220 + 50
		var r := Rect2(x - 50, s.y * 0.35, 100, 160)
		var c: Color = FRASCOS[i][1]
		area.draw_rect(r, c if iluminado == i else c.darkened(0.65))
		area.draw_rect(Rect2(x - 20, s.y * 0.35 - 40, 40, 40), Color(0.4, 0.4, 0.42))
		texto(Vector2(x, r.end.y + 28), "%d · %s" % [i + 1, FRASCOS[i][0]], 20)
	texto(Vector2(s.x / 2, s.y * 0.15), "Mira la receta..." if mostrando else mensaje, 28, Estilo.MARFIL)
	texto(Vector2(s.x / 2, s.y * 0.92), "Receta de %d ingredientes" % receta.size(), 18, Estilo.acento())
