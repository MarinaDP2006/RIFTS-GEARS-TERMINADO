extends Control

# Ventana final: resumen de la partida al terminar la Parte 2.

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(Estilo.fondo_imagen("res://assets/lugares/s2/puente-zaun.webp"))
	add_child(Estilo.velo(0.75))
	var p := Estilo.panel(34)
	p.custom_minimum_size = Vector2(680, 0)
	p.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	p.grow_horizontal = Control.GROW_DIRECTION_BOTH
	p.grow_vertical = Control.GROW_DIRECTION_BOTH
	add_child(p)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 14)
	p.add_child(col)
	col.add_child(Estilo.titulo("FIN", 64))
	col.add_child(Estilo.titulo("Rifts & Gears", 28))
	var nombre := DatosPartida.nombre_personaje if DatosPartida.nombre_personaje != "" else "vecino"
	var texto := Estilo.etiqueta("%s ha vivido las dos partes de la historia de Piltover y Zaun.\nTiempo jugado: %s." % [nombre, Progreso.tiempo_texto()], 18, Estilo.MARFIL, false, true)
	texto.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(texto)
	# Las tres personas que más te aprecian.
	var claves := DatosPartida.afinidades.keys()
	claves.sort_custom(func(a, b): return int(DatosPartida.afinidades[a]) > int(DatosPartida.afinidades[b]))
	var mejores: Array[String] = []
	for k in claves.slice(0, 3):
		mejores.append("%s (%d)" % [Historia.nombre(str(k)), int(DatosPartida.afinidades[k])])
	if not mejores.is_empty():
		var l := Estilo.etiqueta("Quienes más te aprecian: " + ", ".join(mejores), 18, Estilo.acento(), false, true)
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		col.add_child(l)
	var fila := HBoxContainer.new()
	fila.alignment = BoxContainer.ALIGNMENT_CENTER
	fila.add_theme_constant_override("separation", 16)
	col.add_child(fila)
	var menu := Estilo.boton("Volver al menú", 240, true)
	menu.pressed.connect(func():
		Guardado.guardar()
		get_tree().change_scene_to_file("res://escenas/inicio.scn"))
	fila.add_child(menu)
	var otra := Estilo.boton("Jugar otra vez", 240)
	otra.pressed.connect(func():
		Progreso.reiniciar()
		DatosPartida.reiniciar_creacion()
		get_tree().change_scene_to_file("res://escenas/nueva_partida.tscn"))
	fila.add_child(otra)
	menu.grab_focus.call_deferred()
