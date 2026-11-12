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
	# Recorre toda la historia (las dos partes) eligiendo siempre la primera respuesta posible.
	var Lugar = load("res://escenas/juego/lugar.gd")
	var Hist = load("res://escenas/juego/historia.gd")
	for ciudad in ["Piltover", "Zaun"]:
		dp.ciudad_elegida = ciudad
		pr.flags = {}
		for parte in [1, 2]:
			for c in range(1, Hist.capitulos_en_parte(parte) + 1):
				pr.parte = parte
				var l = Lugar.new()
				l.capitulo = Hist.capitulo_de(parte, c)
				root.add_child(l)
				await _frames(1)
				var pasos := 0
				while not l.acabado and pasos < 400:
					pasos += 1
					if l.esperando_decision:
						var ops: Array = (l.nodo["choices"] as Array).filter(func(o): return Hist.cumple(o.get("req", {})))
						l._elegir(ops[0] if not ops.is_empty() else l.nodo["choices"][0])
					else:
						l._siguiente()
				print(ciudad, " P", parte, " C", c, " ", l.capitulo["titulo"], " @", l.capitulo["lugar"], " pasos=", pasos, " fin=", l.acabado)
				l.queue_free()
				await _frames(1)
		print("FLAGS ", ciudad, ": ", pr.flags.keys().filter(func(k): return k.begins_with("final_")))
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
