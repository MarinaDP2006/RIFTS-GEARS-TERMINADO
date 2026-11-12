extends "res://escenas/juego/minijuegos/minijuego.gd"

# El Consejo: cada consejero se convence con un tipo de argumento. Elige el bueno.

const ARGUMENTOS := ["Dinero", "Seguridad", "Prestigio", "Justicia"]
const CONSEJEROS := [
	["Consejera del puerto", 0, "Solo piensa en el comercio."],
	["Consejero de la guardia", 1, "Teme a Zaun desde hace años."],
	["Consejera de la Academia", 2, "Quiere que Piltover sea admirada."],
	["Consejero de los barrios", 3, "Se acuerda de la gente de abajo."],
	["Consejera de las familias", 2, "Su apellido vale más que su voto."],
	["Consejero de la industria", 0, "Mide todo en monedas."],
	["Consejera de los ejecutores", 1, "Duerme con un ojo abierto."],
	["Consejero del Entresuelo", 3, "Fue el primero de Zaun en el Consejo."],
]

var actual := []
var limite := 0.0
var restante := 0.0
var aviso := ""
var aviso_color := Color.WHITE

func _configurar() -> void:
	nombre = "El Consejo"
	como_se_juega = "Un consejero se levanta para hablar. Lee su descripción y convéncelo con el argumento que le importa antes de que se siente."
	teclas = "1 Dinero   ·   2 Seguridad   ·   3 Prestigio   ·   4 Justicia"
	duracion = 45.0
	objetivo = 12

func _empezar() -> void:
	_nuevo()

func _nuevo() -> void:
	actual = CONSEJEROS[randi() % CONSEJEROS.size()]
	limite = maxf(1.6, 3.5 - puntos * 0.12)
	restante = limite

func _actualizar(delta: float) -> void:
	restante -= delta
	if restante <= 0.0:
		aviso = "Se ha sentado sin escucharte."
		aviso_color = Color(0.9, 0.4, 0.4)
		sumar(-1)
		_nuevo()

func _entrada(e: InputEvent) -> void:
	if not (e is InputEventKey and e.pressed and not e.echo):
		return
	var i: int = e.keycode - KEY_1
	if i < 0 or i > 3:
		return
	if i == actual[1]:
		sumar(1)
		aviso = "«%s»: voto a favor." % actual[0]
		aviso_color = Estilo.acento()
	else:
		sumar(-1)
		aviso = "«%s» frunce el ceño." % actual[0]
		aviso_color = Color(0.9, 0.4, 0.4)
	_nuevo()

func _dibujar() -> void:
	var s := tam()
	area.draw_rect(Rect2(Vector2.ZERO, s), Color(0.1, 0.08, 0.06))
	# Mesa semicircular.
	area.draw_arc(Vector2(s.x / 2, s.y * 1.1), s.y * 0.7, PI, TAU, 48, Estilo.DORADO_SUAVE, 18)
	if jugando:
		texto(Vector2(s.x / 2, s.y * 0.2), actual[0], 34, Estilo.MARFIL)
		texto(Vector2(s.x / 2, s.y * 0.3), actual[2], 22)
		var ancho := 400.0 * restante / limite
		area.draw_rect(Rect2(s.x / 2 - 200, s.y * 0.38, 400, 10), Color(0.2, 0.2, 0.2))
		area.draw_rect(Rect2(s.x / 2 - 200, s.y * 0.38, ancho, 10), Estilo.acento())
	for i in 4:
		var r := Rect2(s.x / 2 - 380 + i * 195, s.y * 0.55, 175, 70)
		area.draw_rect(r, Estilo.fondo_panel_claro())
		area.draw_rect(r, Estilo.acento(), false, 2)
		texto(r.get_center(), "%d  %s" % [i + 1, ARGUMENTOS[i]], 22, Estilo.MARFIL)
	texto(Vector2(s.x / 2, s.y * 0.8), aviso, 22, aviso_color)
