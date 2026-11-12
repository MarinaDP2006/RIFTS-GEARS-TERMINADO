extends SceneTree
# Saca una captura de cada minijuego a 1600x900 en user://capturas_mj/ (para comparar con el diseño).
func _initialize() -> void:
	_correr.call_deferred()

func _correr() -> void:
	root.size = Vector2i(1600, 900)
	var dp = root.get_node("DatosPartida")
	dp.ciudad_elegida = "Zaun"
	dp.nombre_personaje = "Prueba"
	dp.estadisticas = {"ingenio": 2, "carisma": 2, "valor": 2, "sigilo": 2}
	dp.afinidades = {"mel": 3, "jayce": 2}
	DirAccess.make_dir_recursive_absolute("user://capturas_mj")
	var Cat = load("res://escenas/juego/minijuegos/catalogo.gd")
	for id in Cat.ORDEN:
		var m = Cat.crear(id)
		root.add_child(m)
		await process_frame
		m.panel_mensaje.queue_free()
		m.panel_mensaje = null
		m._arrancar()
		for k in 50:
			await process_frame
		await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png("user://capturas_mj/%s.png" % id)
		print("captura ", id)
		m.queue_free()
		await process_frame
	print(ProjectSettings.globalize_path("user://capturas_mj"))
	quit()
