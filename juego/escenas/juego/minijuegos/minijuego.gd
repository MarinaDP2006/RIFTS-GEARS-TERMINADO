extends Control

# Base de todos los minijuegos: cabecera, zona de juego, marcador, tiempo
# y la barra de instrucciones al pie («Cómo se juega» + teclas).
# Cada minijuego hereda de aquí y rellena _configurar, _empezar, _actualizar,
# _entrada y _dibujar.

signal terminado(puntos: int, ganado: bool)

var id := ""
var nombre := "Minijuego"
var como_se_juega := ""
var teclas := ""
var duracion := 45.0
var objetivo := 10

var area: Control
var etiqueta_puntos: Label
var etiqueta_tiempo: Label
var puntos := 0
var tiempo := 0.0
var jugando := false
var acabado := false
var panel_mensaje: PanelContainer

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	_configurar()
	tiempo = duracion
	var fondo := ColorRect.new()
	fondo.color = Color(0.02, 0.025, 0.035, 0.97) if not Estilo.es_zaun() else Color(0.035, 0.015, 0.045, 0.97)
	fondo.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(fondo)
	var cabecera := HBoxContainer.new()
	cabecera.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	cabecera.offset_left = 40
	cabecera.offset_right = -40
	cabecera.offset_top = 20
	cabecera.offset_bottom = 80
	add_child(cabecera)
	var t := Estilo.titulo(nombre.to_upper(), 36)
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cabecera.add_child(t)
	etiqueta_puntos = Estilo.etiqueta("", 22, Estilo.MARFIL, true)
	etiqueta_puntos.custom_minimum_size.x = 220
	cabecera.add_child(etiqueta_puntos)
	etiqueta_tiempo = Estilo.etiqueta("", 22, Estilo.acento(), true)
	etiqueta_tiempo.custom_minimum_size.x = 160
	cabecera.add_child(etiqueta_tiempo)
	area = Control.new()
	area.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	area.offset_left = 40
	area.offset_right = -40
	area.offset_top = 90
	area.offset_bottom = -64
	area.clip_contents = true
	area.mouse_filter = Control.MOUSE_FILTER_PASS
	area.draw.connect(_dibujar)
	area.gui_input.connect(_entrada_area)
	add_child(area)
	add_child(Estilo.barra_instrucciones(como_se_juega, teclas + "   ·   ESC  salir"))
	_actualizar_marcador()
	_mensaje(nombre, como_se_juega + "\n\nObjetivo: %d puntos en %d segundos." % [objetivo, int(duracion)], "Empezar", _arrancar)

func _arrancar() -> void:
	puntos = 0
	tiempo = duracion
	jugando = true
	acabado = false
	_empezar()
	_actualizar_marcador()

func _process(delta: float) -> void:
	if not jugando:
		return
	tiempo -= delta
	_actualizar(delta)
	if tiempo <= 0.0:
		tiempo = 0.0
		_acabar()
	_actualizar_marcador()
	area.queue_redraw()

func _unhandled_input(evento: InputEvent) -> void:
	if evento.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		if jugando:
			_acabar()
		else:
			terminado.emit(puntos, puntos >= objetivo)
		return
	if jugando:
		_entrada(evento)

func _entrada_area(evento: InputEvent) -> void:
	if jugando:
		_entrada_raton(evento)

func sumar(n: int = 1) -> void:
	puntos = max(0, puntos + n)
	_actualizar_marcador()

func _actualizar_marcador() -> void:
	etiqueta_puntos.text = "Puntos  %d / %d" % [puntos, objetivo]
	etiqueta_tiempo.text = "%d s" % int(ceil(tiempo))

func _acabar() -> void:
	if acabado:
		return
	acabado = true
	jugando = false
	var ganado := puntos >= objetivo
	if puntos > int(Progreso.records.get(id, 0)):
		Progreso.records[id] = puntos
	area.queue_redraw()
	_mensaje("¡Superado!" if ganado else "Se acabó", "Puntuación: %d\nRécord: %d" % [puntos, int(Progreso.records.get(id, 0))], "Continuar",
		func(): terminado.emit(puntos, ganado))

func _mensaje(titulo: String, texto: String, boton: String, accion: Callable) -> void:
	if panel_mensaje:
		panel_mensaje.queue_free()
	panel_mensaje = Estilo.panel(28)
	panel_mensaje.custom_minimum_size = Vector2(560, 0)
	panel_mensaje.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	panel_mensaje.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel_mensaje.grow_vertical = Control.GROW_DIRECTION_BOTH
	add_child(panel_mensaje)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 14)
	panel_mensaje.add_child(col)
	col.add_child(Estilo.titulo(titulo, 34))
	var l := Estilo.etiqueta(texto, 18, Estilo.TEXTO, false, true)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(l)
	var b := Estilo.boton(boton, 220, true)
	b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	col.add_child(b)
	b.grab_focus.call_deferred()
	var p := panel_mensaje
	b.pressed.connect(func():
		p.queue_free()
		if panel_mensaje == p:
			panel_mensaje = null
		accion.call())

# --- Para sobrescribir ---
func _configurar() -> void: pass
func _empezar() -> void: pass
func _actualizar(_delta: float) -> void: pass
func _entrada(_evento: InputEvent) -> void: pass
func _entrada_raton(_evento: InputEvent) -> void: pass
func _dibujar() -> void: pass

# Ayudas de dibujo.
func tam() -> Vector2:
	return area.size

func texto(pos: Vector2, cadena: String, tamano: int = 20, color: Color = Estilo.TEXTO, centrado: bool = true) -> void:
	var f := Estilo.fuente_texto()
	var ancho := f.get_string_size(cadena, HORIZONTAL_ALIGNMENT_LEFT, -1, tamano).x
	area.draw_string(f, pos - Vector2(ancho / 2.0 if centrado else 0.0, -tamano / 3.0), cadena, HORIZONTAL_ALIGNMENT_LEFT, -1, tamano, color)
