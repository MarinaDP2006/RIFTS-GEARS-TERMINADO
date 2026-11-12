extends SceneTree
func _init() -> void:
	await process_frame
	var c = load("res://escenas/codice.tscn").instantiate()
	c.set_script(load("res://escenas/juego/codice.gd"))
	root.add_child(c)
	await process_frame
	var per = c.find_child("ContenidoPersonajes", true, false)
	print("tu historia visible: ", c.find_child("ContenidoTuHistoria", true, false).visible, " personajes visible: ", per.visible)
	c._mostrar("BotonPersonajes")
	print("personajes visible: ", per.visible, " items: ", per.find_child("ListaEntradas", true, false).item_count, " ficha: ", per.find_child("Nombre", true, false).text)
	c._mostrar("BotonZaun")
	var m = c.find_child("ContenidoMundo", true, false)
	print("zaun lugares: ", m.find_child("ListaEntradas", true, false).item_count, " ", m.find_child("Nombre", true, false).text)
	c._mostrar("BotonPiltover")
	print("piltover lugares: ", m.find_child("ListaEntradas", true, false).item_count)
	var t = c.find_child("ContenidoTecnologia", true, false)
	print("tecno: ", t.find_child("ListaEntradas", true, false).item_count)
	c.find_child("BotonVolver", true, false).pressed.emit()
	await process_frame
	print("cerrado: ", not is_instance_valid(c))
	quit()
