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
		["CONTINUAR", _cerrar], ["GUARDAR PARTIDA", _guardar], ["CÓDICE", _abrir_codice],
		["MAPA", _menu_mapa], ["MINIJUEGOS", _menu_minijuegos], ["AJUSTES", _abrir_ajustes], ["SALIR AL MENÚ", _salir],
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

# SALIR AL MENÚ pregunta si quieres guardar antes.
func _salir() -> void:
	var d := ConfirmationDialog.new()
	d.process_mode = Node.PROCESS_MODE_ALWAYS
	d.title = "Salir al menú"
	d.dialog_text = "¿Quieres guardar la partida antes de salir?"
	d.ok_button_text = "Guardar y salir"
	d.cancel_button_text = "Cancelar"
	var sin := d.add_button("Salir sin guardar", true, "sin")
	add_child(d)
	d.confirmed.connect(func():
		Guardado.guardar()
		_ir_al_menu())
	d.custom_action.connect(func(_a): _ir_al_menu())
	d.popup_centered()

func _ir_al_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://escenas/inicio.scn")

# Abre los Ajustes de Nina encima del juego; su VOLVER cierra y vuelve a la pausa.
func _abrir_ajustes() -> void:
	var ajustes: Control = (load("res://escenas/ajustes.tscn") as PackedScene).instantiate()
	ajustes.process_mode = Node.PROCESS_MODE_ALWAYS
	panel_central.visible = false
	raiz.add_child(ajustes)
	var volver := ajustes.find_child("BotonVolver", true, false) as Button
	if volver:
		for c in volver.pressed.get_connections():
			volver.pressed.disconnect(c.callable)
		volver.pressed.connect(func():
			ajustes.queue_free()
			panel_central.visible = true)

# Lista de minijuegos (guía Paso a paso): pestañas Piltover y Zaun, la lista a un lado
# y, al otro, la imagen, qué sube, con quién y JUGAR.
var pestana_mj := ""
var elegido_mj := ""

func _menu_minijuegos() -> void:
	_limpiar()
	if pestana_mj == "":
		pestana_mj = "Zaun" if DatosPartida.ciudad_elegida == "Zaun" else "Piltover"
	var lista_ids := Minijuegos.de_ciudad(pestana_mj)
	if not elegido_mj in lista_ids:
		elegido_mj = lista_ids[0]
	contenido.add_child(Estilo.titulo("MINIJUEGOS", 40))
	var pestanas := TabBar.new()
	pestanas.add_tab("Piltover")
	pestanas.add_tab("Zaun")
	pestanas.current_tab = 1 if pestana_mj == "Zaun" else 0
	pestanas.tab_alignment = TabBar.ALIGNMENT_CENTER
	pestanas.tab_changed.connect(func(t):
		pestana_mj = "Zaun" if t == 1 else "Piltover"
		_menu_minijuegos.call_deferred())
	contenido.add_child(pestanas)
	var fila := HBoxContainer.new()
	fila.add_theme_constant_override("separation", 24)
	contenido.add_child(fila)
	var lista := VBoxContainer.new()
	lista.add_theme_constant_override("separation", 8)
	fila.add_child(lista)
	for id in lista_ids:
		var b := Estilo.boton(Minijuegos.DATOS[id]["nombre"], 280, id == elegido_mj)
		b.pressed.connect(func():
			elegido_mj = id
			_menu_minijuegos())
		lista.add_child(b)
		if id == elegido_mj:
			b.grab_focus.call_deferred()
	var d: Dictionary = Minijuegos.DATOS[elegido_mj]
	var detalle := VBoxContainer.new()
	detalle.custom_minimum_size.x = 520
	detalle.add_theme_constant_override("separation", 8)
	fila.add_child(detalle)
	var img := TextureRect.new()
	img.custom_minimum_size = Vector2(520, 292)
	img.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	if ResourceLoader.exists(Minijuegos.captura(elegido_mj)):
		img.texture = load(Minijuegos.captura(elegido_mj))
	detalle.add_child(img)
	detalle.add_child(Estilo.etiqueta(d["nombre"].to_upper(), 24, Estilo.MARFIL, true))
	detalle.add_child(Estilo.etiqueta("%s · sube %s · con %s" % [d["lugar"], d["sube"], d["con"]], 16, Estilo.acento(), false, true))
	detalle.add_child(Estilo.etiqueta(d["texto"], 16, Estilo.TEXTO, false, true))
	var record := int(Progreso.records.get(elegido_mj, 0))
	if record > 0:
		detalle.add_child(Estilo.etiqueta("Récord: %d" % record, 15, Estilo.TEXTO))
	var jugar := Estilo.boton("JUGAR", 220, true)
	jugar.pressed.connect(_jugar.bind(elegido_mj))
	detalle.add_child(jugar)
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
	# La escena es de Nina y no lleva script: se le pone aquí el que la hace funcionar.
	codice.set_script(preload("res://escenas/juego/codice.gd"))
	codice.process_mode = Node.PROCESS_MODE_ALWAYS
	panel_central.visible = false
	raiz.add_child(codice)
	codice.cerrado.connect(func(): panel_central.visible = true)
	codice.mapa_pedido.connect(func():
		codice.queue_free()
		panel_central.visible = true
		_menu_mapa())
