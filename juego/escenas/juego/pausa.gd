extends CanvasLayer

# Menú de pausa: continuar, guardar, minijuegos, Códice, estado del personaje y salir.

const Minijuegos := preload("res://escenas/juego/minijuegos/catalogo.gd")

var raiz: Control
var panel_central: PanelContainer
var contenido: VBoxContainer
var aviso: Label

func _ready() -> void:
	layer = 20
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	raiz = Control.new()
	raiz.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(raiz)
	raiz.add_child(Estilo.velo(0.7))
	panel_central = Estilo.panel(30)
	panel_central.custom_minimum_size = Vector2(560, 0)
	panel_central.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	panel_central.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel_central.grow_vertical = Control.GROW_DIRECTION_BOTH
	raiz.add_child(panel_central)
	contenido = VBoxContainer.new()
	contenido.add_theme_constant_override("separation", 12)
	panel_central.add_child(contenido)
	_menu_principal()

func _limpiar() -> void:
	for h in contenido.get_children():
		h.queue_free()

func _menu_principal() -> void:
	_limpiar()
	contenido.add_child(Estilo.titulo("PAUSA", 46))
	contenido.add_child(Estilo.titulo("Parte %d · Capítulo %d" % [Progreso.parte, Progreso.capitulo], 20))
	var botones := [
		["Continuar", _cerrar], ["Guardar partida", _guardar], ["Mapa", _menu_mapa], ["Minijuegos", _menu_minijuegos],
		["Mi personaje", _menu_personaje], ["Códice", _abrir_codice], ["Salir al menú", _salir],
	]
	for i in botones.size():
		var b := Estilo.boton(botones[i][0], 320, i == 0)
		b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		b.pressed.connect(botones[i][1])
		contenido.add_child(b)
		if i == 0:
			b.grab_focus.call_deferred()
	aviso = Estilo.etiqueta("", 16, Estilo.acento())
	aviso.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	contenido.add_child(aviso)

func _unhandled_input(evento: InputEvent) -> void:
	if evento.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		if raiz.get_child_count() > 2:
			# Hay una ventana encima (Códice o minijuego): la cierra el propio juego.
			return
		_cerrar()

func _cerrar() -> void:
	get_tree().paused = false
	queue_free()

func _guardar() -> void:
	var ok := Guardado.guardar()
	if is_instance_valid(aviso):
		aviso.text = ("Partida guardada en la ranura %d." % Progreso.ranura) if ok else "No se pudo guardar la partida."

# Mapa 2D de guía: siempre completo, marca dónde estás y adónde ir.
func _menu_mapa() -> void:
	_limpiar()
	contenido.add_child(Estilo.titulo("MAPA DE LA CIUDAD", 36))
	var guia := preload("res://escenas/juego/mapa_guia.gd").new()
	guia.custom_minimum_size = Vector2(880, 460)
	contenido.add_child(guia)
	var v := Estilo.boton("Volver", 200, true)
	v.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	v.pressed.connect(_menu_principal)
	contenido.add_child(v)
	v.grab_focus.call_deferred()

func _salir() -> void:
	Guardado.guardar()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://escenas/inicio.scn")

func _menu_minijuegos() -> void:
	_limpiar()
	contenido.add_child(Estilo.titulo("MINIJUEGOS", 40))
	var rejilla := GridContainer.new()
	rejilla.columns = 2
	rejilla.add_theme_constant_override("h_separation", 10)
	rejilla.add_theme_constant_override("v_separation", 10)
	contenido.add_child(rejilla)
	var primero := true
	for id in Minijuegos.ORDEN:
		var record := int(Progreso.records.get(id, 0))
		var b := Estilo.boton("%s   ·   récord %d" % [Minijuegos.NOMBRES[id], record], 250)
		b.pressed.connect(_jugar.bind(id))
		rejilla.add_child(b)
		if primero:
			b.grab_focus.call_deferred()
			primero = false
	var v := Estilo.boton("Volver", 200)
	v.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	v.pressed.connect(_menu_principal)
	contenido.add_child(v)

func _jugar(id: String) -> void:
	var juego: Control = Minijuegos.crear(id)
	if juego == null:
		return
	juego.process_mode = Node.PROCESS_MODE_ALWAYS
	panel_central.visible = false
	raiz.add_child(juego)
	juego.terminado.connect(func(_p: int, _g: bool):
		juego.queue_free()
		panel_central.visible = true
		_menu_minijuegos())

func _menu_personaje() -> void:
	_limpiar()
	contenido.add_child(Estilo.titulo(DatosPartida.nombre_personaje if DatosPartida.nombre_personaje != "" else "Tu personaje", 38))
	contenido.add_child(Estilo.etiqueta("%s · %d años · Tiempo jugado: %s" % [DatosPartida.ciudad_elegida, DatosPartida.edad, Progreso.tiempo_texto()], 17, Estilo.MARFIL, false, true))
	contenido.add_child(Estilo.etiqueta("ESTADÍSTICAS", 18, Estilo.acento(), true))
	var stats := ""
	for s in DatosPartida.estadisticas:
		stats += "%s: %d    " % [str(s).capitalize(), int(DatosPartida.estadisticas[s])]
	contenido.add_child(Estilo.etiqueta(stats if stats != "" else "—", 17, Estilo.TEXTO, false, true))
	contenido.add_child(Estilo.etiqueta("AFINIDADES", 18, Estilo.acento(), true))
	var claves := DatosPartida.afinidades.keys()
	claves.sort_custom(func(a, b): return int(DatosPartida.afinidades[a]) > int(DatosPartida.afinidades[b]))
	var texto := ""
	for k in claves:
		texto += "%s %d   " % [Historia.nombre(str(k)), int(DatosPartida.afinidades[k])]
	contenido.add_child(Estilo.etiqueta(texto if texto != "" else "Todavía nadie te conoce.", 17, Estilo.TEXTO, false, true))
	var v := Estilo.boton("Volver", 200, true)
	v.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	v.pressed.connect(_menu_principal)
	contenido.add_child(v)
	v.grab_focus.call_deferred()

func _abrir_codice() -> void:
	var escena := load("res://escenas/codice.tscn") as PackedScene
	if escena == null:
		aviso.text = "No se encontró el Códice."
		return
	var codice: Control = escena.instantiate()
	codice.process_mode = Node.PROCESS_MODE_ALWAYS
	panel_central.visible = false
	raiz.add_child(codice)
	var cerrar := Estilo.boton("Cerrar Códice", 220, true)
	cerrar.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	cerrar.offset_left = -250
	cerrar.offset_top = 20
	cerrar.offset_right = -30
	codice.add_child(cerrar)
	cerrar.pressed.connect(func():
		codice.queue_free()
		panel_central.visible = true)
