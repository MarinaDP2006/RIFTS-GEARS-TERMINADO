extends SceneTree

# Carga todos los scripts del juego y dice cuáles no compilan.
func _initialize() -> void:
	var malos := 0
	var total := 0
	for ruta in _buscar("res://escenas"):
		total += 1
		var s = load(ruta)
		if s == null or not (s as GDScript).can_instantiate():
			malos += 1
			print("NO COMPILA: ", ruta)
	print("SCRIPTS: %d revisados, %d con errores" % [total, malos])
	quit(1 if malos > 0 else 0)

func _buscar(dir: String) -> Array:
	var out := []
	for f in DirAccess.get_files_at(dir):
		if f.ends_with(".gd"):
			out.append(dir.path_join(f))
	for d in DirAccess.get_directories_at(dir):
		out.append_array(_buscar(dir.path_join(d)))
	return out
