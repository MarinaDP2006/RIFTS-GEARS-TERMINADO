extends "res://escenas/juego/minijuegos/minijuego.gd"

# El Archivo: llegan expedientes y hay que llevarlos al archivador correcto.

const TIPOS := [
	["PILTOVER", Color(0.83, 0.67, 0.34)],
	["ZAUN", Color("#C24DE0")],
]
const ASUNTOS := ["Contrabando", "Patente hextech", "Denuncia", "Permiso del Consejo", "Brillo", "Robo", "Herencia", "Puerto", "Fábrica"]

var expediente := {}
var y := 0.0
var velocidad := 160.0
var aviso := ""
var aviso_t := 0.0

func _configurar() -> void:
	nombre = "El Archivo"
	como_se_juega = "Cada expediente lleva el sello de una ciudad. Llévalo al archivador correcto antes de que llegue al suelo."
	teclas = "←  Piltover   ·   →  Zaun"
	duracion = 40.0
	objetivo = 16

func _empezar() -> void:
	velocidad = 160.0
	_nuevo()

func _nuevo() -> void:
	expediente = {"tipo": randi() % 2, "asunto": ASUNTOS[randi() % ASUNTOS.size()], "n": randi_range(100, 999)}
	y = 0.0

func _actualizar(delta: float) -> void:
	y += velocidad * delta
	aviso_t = maxf(0.0, aviso_t - delta)
	if y > tam().y - 150.0:
		aviso = "¡Se ha caído!"
		aviso_t = 0.8
		sumar(-1)
		_nuevo()

func _entrada(e: InputEvent) -> void:
	var lado := -1
	if e.is_action_pressed("ui_left"):
		lado = 0
	elif e.is_action_pressed("ui_right"):
		lado = 1
	if lado == -1:
		return
	if lado == expediente["tipo"]:
		sumar(1)
		velocidad += 8.0
		aviso = "Bien archivado"
	else:
		sumar(-1)
		aviso = "Archivador equivocado"
	aviso_t = 0.6
	_nuevo()

func _dibujar() -> void:
	var s := tam()
	area.draw_rect(Rect2(Vector2.ZERO, s), Color(0.08, 0.07, 0.06))
	for i in 2:
		var r := Rect2(30 + i * (s.x - 290), s.y - 130, 230, 120)
		area.draw_rect(r, Color(0.16, 0.12, 0.09))
		area.draw_rect(r, TIPOS[i][1], false, 3)
		texto(r.get_center(), ("← " if i == 0 else "") + TIPOS[i][0] + (" →" if i == 1 else ""), 24, TIPOS[i][1])
	if jugando:
		var r2 := Rect2(s.x / 2 - 150, y, 300, 130)
		area.draw_rect(r2, Color(0.92, 0.88, 0.78))
		area.draw_rect(Rect2(r2.position, Vector2(300, 30)), TIPOS[expediente["tipo"]][1])
		texto(r2.position + Vector2(150, 15), "SELLO DE " + TIPOS[expediente["tipo"]][0], 18, Color.BLACK)
		texto(r2.position + Vector2(150, 65), "Expediente nº %d" % expediente["n"], 20, Color(0.15, 0.12, 0.1))
		texto(r2.position + Vector2(150, 98), expediente["asunto"], 22, Color(0.15, 0.12, 0.1))
	if aviso_t > 0.0:
		texto(Vector2(s.x / 2, s.y - 70), aviso, 24, Estilo.MARFIL)
