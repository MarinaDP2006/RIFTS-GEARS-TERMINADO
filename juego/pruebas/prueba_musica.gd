extends SceneTree
# Comprueba que la música suena en el menú y en la partida de cada ciudad.
func _initialize() -> void:
	create_timer(60.0).timeout.connect(func(): print("TIMEOUT"); quit(1))
	_probar()

func _ver(que: String) -> void:
	var m = root.get_node("Musica")
	print("%s -> %s | sonando=%s | segundo=%.1f | bus=%s" % [que, m.tema_actual.get_file(), m.reproductor.playing, m.reproductor.get_playback_position(), m.reproductor.bus])

func _probar() -> void:
	await process_frame
	change_scene_to_file("res://escenas/inicio.scn")
	await create_timer(3.0).timeout
	_ver("MENU")
	for c in ["Piltover", "Zaun"]:
		root.get_node("DatosPartida").ciudad_elegida = c
		change_scene_to_file("res://escenas/juego/juego.tscn")
		await create_timer(3.0).timeout
		_ver("PARTIDA " + c)
	print("Driver de audio: ", AudioServer.get_driver_name() if AudioServer.has_method("get_driver_name") else "?")
	quit()
