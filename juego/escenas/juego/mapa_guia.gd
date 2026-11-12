extends Control

# Mapa 2D de guía: esquema de las líneas de Piltover y Zaun.
# Siempre completo; solo marca dónde estás y dónde te espera el capítulo.

func _ready() -> void:
	resized.connect(queue_redraw)

func _pos(parada: String) -> Vector2:
	var s := size
	var margen := 60.0
	for linea in Mapa.LINEAS:
		var lista: Array = Mapa.LINEAS[linea]
		if parada in lista and not (linea == "Piltover" and parada == "AscensorPromenade"):
			var fila := ["Piltover", "Promenade", "Entresuelo", "Sumidero"].find(linea)
			var y := 50.0 + fila * (s.y - 100.0) / 3.0
			if linea == "Piltover":
				var i := lista.find(parada)
				return Vector2(margen + i * (s.x * 0.62 - margen) / 6.0, y + 10.0)
			var j := lista.find(parada)
			return Vector2(s.x * 0.62 - (s.x * 0.62 - margen) / 6.0 * 0.0 + j * (s.x * 0.38 - margen + 20.0) / maxf(1.0, lista.size() - 1), y)
	return Vector2.ZERO

func _draw() -> void:
	var s := size
	draw_rect(Rect2(Vector2.ZERO, s), Color(0, 0, 0, 0.25))
	draw_rect(Rect2(0, 0, s.x, s.y * 0.2), Color(Estilo.DORADO, 0.07))
	draw_rect(Rect2(0, s.y * 0.2, s.x, s.y * 0.8), Color(Estilo.SHIMMER, 0.06))
	var f := Estilo.fuente_texto()
	draw_string(Estilo.fuente_titulo(), Vector2(12, 26), "PILTOVER", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Estilo.DORADO)
	draw_string(Estilo.fuente_titulo(), Vector2(12, s.y * 0.2 + 26), "ZAUN", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Estilo.SHIMMER)
	# Líneas.
	var pilt: Array = Mapa.LINEAS["Piltover"]
	for i in pilt.size() - 1:
		draw_line(_pos(pilt[i]), _pos(pilt[i + 1]), Estilo.DORADO_SUAVE, 4)
	for linea in ["Promenade", "Entresuelo", "Sumidero"]:
		var lista: Array = Mapa.LINEAS[linea]
		for i in lista.size() - 1:
			draw_line(_pos(lista[i]), _pos(lista[i + 1]), Estilo.SHIMMER.darkened(0.2), 4)
	for i in Mapa.ASCENSOR.size() - 1:
		draw_dashed_line(_pos(Mapa.ASCENSOR[i]), _pos(Mapa.ASCENSOR[i + 1]), Estilo.MARFIL, 3, 8)
	# Paradas.
	var objetivo: String = Historia.capitulo(Progreso.capitulo_global())["lugar"]
	for parada in Mapa.NODOS:
		var p := _pos(str(parada))
		var es_actual: bool = parada == Progreso.lugar_actual
		var es_objetivo: bool = parada == objetivo
		var c := Estilo.DORADO if Mapa.es_piltover(str(parada)) else Estilo.SHIMMER
		if Mapa.es_ascensor(str(parada)):
			c = Estilo.MARFIL
		draw_circle(p, 10, c)
		if es_objetivo:
			draw_arc(p, 18, 0, TAU, 32, Estilo.MARFIL, 3)
		if es_actual:
			draw_circle(p, 6, Color.WHITE)
		var nombre := Mapa.nombre(str(parada)).replace("Ascensor · ", "Ascensor ")
		var ancho := f.get_string_size(nombre, HORIZONTAL_ALIGNMENT_LEFT, -1, 14).x
		# Nombres alternados arriba y abajo para que no se pisen.
		var arriba: bool = Mapa.linea_de(str(parada)) == "Piltover" and int(Mapa.LINEAS["Piltover"].find(parada)) % 2 == 1
		if not Mapa.es_piltover(str(parada)) and not Mapa.es_ascensor(str(parada)):
			arriba = int(Mapa.LINEAS[Mapa.linea_de(str(parada))].find(parada)) % 2 == 0
		if Mapa.es_ascensor(str(parada)):
			nombre = nombre.replace("Ascensor ", "↕ ")
			ancho = f.get_string_size(nombre, HORIZONTAL_ALIGNMENT_LEFT, -1, 14).x
			draw_string(f, p + Vector2(-ancho - 18, 5), nombre, HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Estilo.MARFIL)
			continue
		draw_string(f, p + Vector2(-ancho / 2.0, -20 if arriba else 32), nombre, HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Estilo.MARFIL if es_objetivo or es_actual else Estilo.TEXTO)
	draw_string(f, Vector2(12, s.y - 12), "●  estás aquí      ◯  te espera el capítulo", HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Estilo.MARFIL)
