extends SceneTree

func _initialize() -> void:
	_correr.call_deferred()

func _frames(n: int) -> void:
	for i in n:
		await process_frame

func _correr() -> void:
	var dp = root.get_node("DatosPartida")
	var pr = root.get_node("Progreso")
	dp.ciudad_elegida = "Zaun"
	dp.nombre_personaje = "Prueba"
	dp.estadisticas = {"ingenio": 2, "carisma": 1, "valor": 1, "sigilo": 1}
	dp.afinidades = {"vi": 10}
	pr.reiniciar()
	pr.tutoriales_vistos = ["mapa", "lugar"]
	var juego = load("res://escenas/juego/juego.tscn").instantiate()
	root.add_child(juego)
	await _frames(10)
	print("JUEGO OK, lugar=", pr.lugar_actual)
	# Recorre los 30 capítulos abriendo el lugar y eligiendo la primera opción.
	var Lugar = load("res://escenas/juego/lugar.gd")
	var Hist = load("res://escenas/juego/historia.gd")
	for c in range(1, 31):
		var l = Lugar.new()
		var cap = Hist.capitulo(c).duplicate(true)
		cap.erase("minijuego")
		l.capitulo = cap
		root.add_child(l)
		await _frames(2)
		for k in 12:
			l._siguiente()
		await _frames(2)
		l._elegir(0)
		await _frames(2)
		l.queue_free()
	print("CAPITULOS OK, afinidades=", dp.afinidades)
	# Movimiento por el mapa.
	var Mapa = load("res://escenas/juego/mapa.gd")
	var p = "Puente"
	for i in 3: p = Mapa.vecina(p, 1, "Piltover")
	print("derecha desde Puente: ", p)
	print("ascensor abajo: ", Mapa.ascensor("AscensorPromenade", 1))
	var Cat = load("res://escenas/juego/minijuegos/catalogo.gd")
	for id in Cat.ORDEN:
		var m = Cat.crear(id)
		root.add_child(m)
		await _frames(2)
		m._arrancar()
		for k in 30:
			await process_frame
		m._acabar()
		await _frames(2)
		m.queue_free()
		print("MINIJUEGO OK ", id)
	var pausa = load("res://escenas/juego/pausa.gd").new()
	juego.add_child(pausa)
	await _frames(3)
	pausa._menu_minijuegos()
	await _frames(2)
	pausa._menu_mapa()
	await _frames(2)
	pausa._menu_principal()
	await _frames(2)
	pausa._menu_personaje()
	await _frames(2)
	pausa._abrir_codice()
	await _frames(3)
	pausa._guardar()
	pausa._cerrar()
	print("PAUSA OK ranura=", pr.ranura)
	var fin = load("res://escenas/juego/fin.gd").new()
	root.add_child(fin)
	await _frames(3)
	print("FIN OK")
	juego.queue_free()
	fin.queue_free()
	var cp = load("res://escenas/cargar_partida.tscn").instantiate()
	root.add_child(cp)
	await _frames(3)
	print("CARGAR OK")
	var pro = load("res://escenas/juego/prologo.tscn").instantiate()
	root.add_child(pro)
	await _frames(3)
	print("PROLOGO OK")
	quit()
