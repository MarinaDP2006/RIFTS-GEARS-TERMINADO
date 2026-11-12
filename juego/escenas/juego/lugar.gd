extends Control

# Pantalla de un lugar: recorre un capítulo de la historia de Nina (datos/historia.json).
# Cada nodo tiene fondo, líneas (con condiciones) y, al final, respuestas, un salto o el fin.

signal terminado

var capitulo: Dictionary = {}
var nodo: Dictionary = {}
var cola: Array = []
var esperando_decision := false
var final_grupo := ""
var acabado := false

var fondo: TextureRect
var lista_chat: VBoxContainer
var scroll_chat: ScrollContainer
var boton_seguir: Button
var caja_opciones: VBoxContainer
var imagen_personaje: TextureRect

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	_montar()
	if str(capitulo.get("intro", "")) != "":
		_burbuja("narrador", Historia.formatear(capitulo["intro"]))
	_ir(str(capitulo.get("inicio", "a")))
	if not "lugar" in Progreso.tutoriales_vistos:
		Progreso.tutoriales_vistos.append("lugar")
		_tutorial()

func _montar() -> void:
	fondo = Estilo.fondo_imagen(Historia.fondo(capitulo.get("lugar", "Puente"), Progreso.parte))
	add_child(fondo)
	var sombra := ColorRect.new()
	sombra.color = Color(0, 0.01, 0.03, 0.45)
	sombra.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	sombra.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(sombra)

	var margen := MarginContainer.new()
	margen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for lado in ["left", "right", "top"]:
		margen.add_theme_constant_override("margin_" + lado, 40)
	margen.add_theme_constant_override("margin_bottom", 70)
	add_child(margen)
	var fila := HBoxContainer.new()
	fila.add_theme_constant_override("separation", 32)
	margen.add_child(fila)

	# Columna izquierda: nombre del lugar y personaje.
	var izq := VBoxContainer.new()
	izq.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	izq.size_flags_stretch_ratio = 0.9
	fila.add_child(izq)
	izq.add_child(Estilo.titulo(Mapa.nombre(capitulo.get("lugar", "")), 40))
	imagen_personaje = TextureRect.new()
	imagen_personaje.size_flags_vertical = Control.SIZE_EXPAND_FILL
	imagen_personaje.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	imagen_personaje.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	izq.add_child(imagen_personaje)
	_poner_personaje(capitulo.get("personaje", ""))

	# Columna derecha: chat.
	var der := Estilo.panel(18)
	der.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	fila.add_child(der)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 12)
	der.add_child(col)
	col.add_child(Estilo.etiqueta("CONVERSACIÓN", 18, Estilo.acento(), true))
	scroll_chat = ScrollContainer.new()
	scroll_chat.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll_chat.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	col.add_child(scroll_chat)
	lista_chat = VBoxContainer.new()
	lista_chat.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lista_chat.add_theme_constant_override("separation", 10)
	scroll_chat.add_child(lista_chat)
	caja_opciones = VBoxContainer.new()
	caja_opciones.add_theme_constant_override("separation", 8)
	col.add_child(caja_opciones)
	boton_seguir = Estilo.boton("Continuar  ▸", 240, true)
	boton_seguir.size_flags_horizontal = Control.SIZE_SHRINK_END
	boton_seguir.pressed.connect(_siguiente)
	col.add_child(boton_seguir)

	add_child(Estilo.barra_instrucciones(
		"Lee la conversación y elige qué responder. Tus decisiones cambian cómo te tratan.",
		"INTRO / ESPACIO  continuar   ·   RATÓN  elegir respuesta"))

func _poner_personaje(id: String) -> void:
	var ruta := ""
	var id_imagen := "jinx" if id == "powder" else id
	var carpeta := "s1" if Progreso.parte == 1 else "s2"
	for c in [carpeta, "s1", "s2"]:
		var r := "res://assets/personajes/%s/%s.webp" % [c, id_imagen]
		if ResourceLoader.exists(r):
			ruta = r
			break
	if ruta == "":
		ruta = Estilo.retrato(id_imagen)
	imagen_personaje.texture = load(ruta) if ruta != "" else null

func _unhandled_input(evento: InputEvent) -> void:
	if evento.is_action_pressed("ui_accept") and not esperando_decision:
		_siguiente()
		get_viewport().set_input_as_handled()
	elif evento.is_action_pressed("ui_cancel"):
		# No se puede salir a mitad de capítulo, pero ESC no debe abrir la pausa del mapa.
		get_viewport().set_input_as_handled()

# Entra en un nodo del capítulo.
func _ir(id: String) -> void:
	nodo = capitulo.get("nodos", {}).get(id, {})
	if nodo.is_empty():
		_terminar()
		return
	_cambiar_fondo(str(nodo.get("bg", "")))
	cola = (nodo.get("lines", []) as Array).duplicate()
	_siguiente()

func _cambiar_fondo(bg: String) -> void:
	if bg == "" or fondo == null:
		return
	var ruta := Historia.imagen(bg, Progreso.parte)
	if ResourceLoader.exists(ruta):
		fondo.texture = load(ruta)

# Muestra la siguiente línea que se cumpla; al acabar, respuestas, salto o fin.
func _siguiente() -> void:
	if esperando_decision or acabado:
		return
	while not cola.is_empty():
		var l: Dictionary = cola.pop_front()
		if Historia.cumple(l.get("cond", {})):
			_burbuja(str(l["s"]), Historia.formatear(str(l["t"])))
			return
	if final_grupo != "":
		_terminar()
	elif nodo.has("choices"):
		_mostrar_decision()
	elif nodo.has("next"):
		_ir(str(nodo["next"]))
	elif nodo.get("ending", false):
		_final(str(nodo.get("endingSet", "endings")))
	else:
		_terminar()

func _mostrar_decision() -> void:
	esperando_decision = true
	boton_seguir.visible = false
	var opciones: Array = (nodo["choices"] as Array).filter(func(o): return Historia.cumple(o.get("req", {})))
	if opciones.is_empty():
		opciones = nodo["choices"]
	for i in opciones.size():
		var o: Dictionary = opciones[i]
		var b := Estilo.boton(Historia.formatear(str(o["t"])), 0)
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.pressed.connect(_elegir.bind(o))
		caja_opciones.add_child(b)
		if i == 0:
			b.grab_focus.call_deferred()

func _elegir(o: Dictionary) -> void:
	for hijo in caja_opciones.get_children():
		hijo.queue_free()
	esperando_decision = false
	boton_seguir.visible = true
	Progreso.decisiones["%s/%s" % [capitulo.get("id", ""), o.get("next", "")]] = str(o["t"])
	var fx: Dictionary = o.get("fx", {})
	Historia.aplicar(fx)
	_burbuja("tu", Historia.formatear(str(o["t"])))
	var cambios := _texto_cambios(fx)
	if cambios != "":
		_burbuja("narrador", cambios)
	_ir(str(o.get("next", "")))

func _texto_cambios(fx: Dictionary) -> String:
	var partes: Array[String] = []
	for p in fx.get("aff", {}):
		var n := int(fx["aff"][p])
		partes.append("%s %s%d" % [Historia.nombre(p), "+" if n > 0 else "", n])
	for s in fx.get("stats", {}):
		partes.append("%s +%d" % [str(s).capitalize(), int(fx["stats"][s])])
	return "" if partes.is_empty() else "Afinidad: " + ", ".join(partes)

# Final de la Parte 1 (endings) o del juego (endings2).
func _final(grupo: String) -> void:
	final_grupo = "finales2" if grupo == "endings2" else "finales"
	var f := Historia.elegir_final(final_grupo)
	Progreso.flags["final_" + str(f.get("id", ""))] = true
	_cambiar_fondo(str(f.get("fondo", "")))
	_burbuja("narrador", str(f.get("titulo", "")).to_upper())
	cola = (f.get("lineas", []) as Array).duplicate()
	_siguiente()

func _terminar() -> void:
	if acabado:
		return
	acabado = true
	for p in capitulo.get("conoce", []):
		if not p in Progreso.conocidos:
			Progreso.conocidos.append(p)
	boton_seguir.visible = false
	var fin := Estilo.boton("Terminar capítulo  ▸", 280, true)
	fin.size_flags_horizontal = Control.SIZE_SHRINK_END
	fin.pressed.connect(func(): terminado.emit())
	caja_opciones.add_child(fin)
	fin.grab_focus.call_deferred()

func _burbuja(quien: String, texto: String) -> void:
	var es_narrador := quien == "narrador"
	var es_jugador := quien == "tu" or quien == "yo"
	var p := PanelContainer.new()
	var estilo := StyleBoxFlat.new()
	estilo.set_corner_radius_all(12)
	estilo.set_content_margin_all(12)
	if es_narrador:
		estilo.bg_color = Color(0, 0, 0, 0.35)
	elif es_jugador:
		estilo.bg_color = Estilo.acento().darkened(0.55)
	else:
		estilo.bg_color = Estilo.fondo_panel_claro()
		estilo.border_color = Estilo.acento().darkened(0.2)
		estilo.border_width_left = 3
	p.add_theme_stylebox_override("panel", estilo)
	if es_jugador:
		p.size_flags_horizontal = Control.SIZE_SHRINK_END
		p.custom_minimum_size.x = 360
	var col := VBoxContainer.new()
	p.add_child(col)
	if not es_narrador:
		var fila := HBoxContainer.new()
		fila.add_theme_constant_override("separation", 10)
		col.add_child(fila)
		var ruta := Estilo.avatar_jugador() if es_jugador else Estilo.retrato("jinx" if quien == "powder" else quien)
		if ruta != "" and ResourceLoader.exists(ruta):
			var cara := TextureRect.new()
			cara.texture = load(ruta)
			cara.custom_minimum_size = Vector2(34, 34)
			cara.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			cara.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
			fila.add_child(cara)
		var nombre := DatosPartida.nombre_personaje if es_jugador and DatosPartida.nombre_personaje != "" else Historia.nombre(quien)
		fila.add_child(Estilo.etiqueta(nombre, 17, Estilo.acento(), true))
		if not es_jugador:
			_poner_personaje(quien)
	var l := Estilo.etiqueta(texto, 17, Estilo.MARFIL if es_narrador else Estilo.TEXTO, false, true)
	if es_narrador:
		l.add_theme_font_override("font", load("res://assets/fonts/RobotoCondensed-Italic-VariableFont_wght.ttf"))
	col.add_child(l)
	lista_chat.add_child(p)
	p.modulate.a = 0.0
	create_tween().tween_property(p, "modulate:a", 1.0, 0.25)
	await get_tree().process_frame
	scroll_chat.scroll_vertical = int(scroll_chat.get_v_scroll_bar().max_value)

func _tutorial() -> void:
	var capa := Control.new()
	capa.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(capa)
	capa.add_child(Estilo.velo(0.6))
	var p := Estilo.panel(28)
	p.custom_minimum_size = Vector2(600, 0)
	p.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	p.grow_horizontal = Control.GROW_DIRECTION_BOTH
	p.grow_vertical = Control.GROW_DIRECTION_BOTH
	capa.add_child(p)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 14)
	p.add_child(col)
	col.add_child(Estilo.titulo("Los lugares", 30))
	col.add_child(Estilo.etiqueta("Cada capítulo pasa en un lugar. Los personajes te hablan según tu ciudad y tu familia.\n\nPulsa INTRO o «Continuar» para avanzar. Al final elegirás qué responder: cada respuesta sube o baja tu afinidad con ellos y tus estadísticas.\n\nAlgunos capítulos tienen un minijuego. También puedes jugarlos cuando quieras desde el menú de pausa (ESC en el mapa).", 18, Estilo.TEXTO, false, true))
	var b := Estilo.boton("Entendido", 220, true)
	b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	col.add_child(b)
	esperando_decision = true
	b.grab_focus.call_deferred()
	b.pressed.connect(func():
		capa.queue_free()
		esperando_decision = false)
