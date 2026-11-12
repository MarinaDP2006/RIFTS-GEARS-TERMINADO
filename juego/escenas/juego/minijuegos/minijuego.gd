extends Control

# Base de los 10 minijuegos, hecha sobre los diseños de Nina (minijuegos_capturas/).
# Todo se dibuja en un lienzo de 1600 x 900, como las capturas, y se escala a la ventana.
# Común a todos: cabecera (título, lugar · estadística, marcadores), panel «Para qué sirve»
# y la barra de abajo de 118 px con «CÓMO SE JUEGA», las teclas y «F1 · ver instrucciones completas».

signal terminado(puntos: int, ganado: bool)

const DISENO := Vector2(1600, 900)
const ALTO_PIE := 118.0

# Colores de cada ciudad.
const P_FONDO := Color("#0a1428")
const P_PANEL := Color(0.04, 0.08, 0.15, 0.92)
const P_ORO := Color("#d9b25f")
const P_HEX := Color("#3fb6e0")
const Z_FONDO := Color("#120818")
const Z_PANEL := Color(0.09, 0.04, 0.11, 0.92)
const Z_SHIMMER := Color("#C24DE0")
const Z_ROSA := Color("#ff4fa3")
const MARFIL := Color(1.0, 0.94, 0.79)
const TEXTO := Color(0.91, 0.91, 0.93)

var id := ""
var nombre := "Minijuego"
var subtitulo := ""            # «TALLER DE JAYCE · INGENIO»
var ciudad := "Piltover"
var como_se_juega := ""
var teclas: Array = []         # [["Q / E", "girar anillo"], ...]
var instrucciones := ""        # texto largo para F1
var fondo_ruta := ""
var oscurecer := 0.55
var estadistica := ""          # la que sube al ganar
var con_quien: Array = []      # ids de personajes cuya relación sube al ganar

var puntos := 0
var jugando := false
var acabado := false
var ganado := false
var tiempo := 0.0              # segundos jugados
var panel_mensaje: PanelContainer

var _fondo_tex: Texture2D
var _escala := 1.0
var _desplazamiento := Vector2.ZERO
var _fuentes := {}
var _texturas := {}

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	_configurar()
	_empezar()
	if fondo_ruta != "" and ResourceLoader.exists(fondo_ruta):
		_fondo_tex = load(fondo_ruta)
	resized.connect(queue_redraw)
	_mensaje(nombre, como_se_juega, "Empezar", _arrancar)

func es_zaun() -> bool:
	return ciudad == "Zaun"

func acento() -> Color:
	return Z_SHIMMER if es_zaun() else P_ORO

func color_panel() -> Color:
	return Z_PANEL if es_zaun() else P_PANEL

# ---------- Ciclo ----------

func _arrancar() -> void:
	puntos = 0
	tiempo = 0.0
	jugando = true
	acabado = false
	ganado = false
	_empezar()
	queue_redraw()

func _process(delta: float) -> void:
	if jugando:
		tiempo += delta
		_actualizar(delta)
	queue_redraw()

func _gui_input(evento: InputEvent) -> void:
	if not jugando:
		return
	if evento is InputEventMouse:
		var copia: InputEventMouse = evento.duplicate()
		copia.position = a_diseno(evento.position)
		_entrada_raton(copia)

func _unhandled_input(evento: InputEvent) -> void:
	if evento.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		if panel_mensaje:
			return
		if jugando:
			acabar(false)
		else:
			terminado.emit(puntos, ganado)
		return
	if evento is InputEventKey and evento.pressed and evento.keycode == KEY_F1:
		get_viewport().set_input_as_handled()
		if panel_mensaje == null:
			var seguia := jugando
			jugando = false
			_mensaje("Cómo se juega", instrucciones if instrucciones != "" else como_se_juega, "Volver",
				func(): jugando = seguia)
		return
	if jugando and not evento is InputEventMouse:
		_entrada(evento)

func raton() -> Vector2:
	return a_diseno(get_local_mouse_position())

func a_diseno(p: Vector2) -> Vector2:
	return (p - _desplazamiento) / _escala

# Termina la partida. Al ganar sube la estadística y la relación con quien cuenta.
func acabar(gano: bool, detalle: String = "") -> void:
	if acabado:
		return
	acabado = true
	jugando = false
	ganado = gano
	if puntos > int(Progreso.records.get(id, 0)):
		Progreso.records[id] = puntos
	var premio := ""
	if gano:
		if estadistica != "":
			DatosPartida.estadisticas[estadistica] = int(DatosPartida.estadisticas.get(estadistica, 0)) + 1
			premio = "%s +1" % estadistica.capitalize()
		for p in con_quien:
			Progreso.cambiar_afinidad(p, 1)
		_premio_extra()
	var texto_final := detalle
	if premio != "":
		texto_final += ("\n\n" if texto_final != "" else "") + premio
	_mensaje("¡Lo has conseguido!" if gano else "Esta vez no ha salido", texto_final, "Continuar",
		func(): terminado.emit(puntos, ganado))

func _mensaje(titulo: String, cuerpo: String, boton: String, accion: Callable) -> void:
	if panel_mensaje:
		panel_mensaje.queue_free()
	panel_mensaje = Estilo.panel(28)
	panel_mensaje.custom_minimum_size = Vector2(620, 0)
	panel_mensaje.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	panel_mensaje.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel_mensaje.grow_vertical = Control.GROW_DIRECTION_BOTH
	add_child(panel_mensaje)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 14)
	panel_mensaje.add_child(col)
	col.add_child(Estilo.titulo(titulo, 34))
	var l := Estilo.etiqueta(cuerpo, 18, Estilo.TEXTO, false, true)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(l)
	if not jugando and not acabado:
		_opciones_mensaje(col)
	var b := Estilo.boton(boton, 220, true)
	b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	col.add_child(b)
	b.grab_focus.call_deferred()
	var p := panel_mensaje
	b.pressed.connect(func():
		p.queue_free()
		if panel_mensaje == p:
			panel_mensaje = null
		accion.call())

# ---------- Dibujo ----------

func _draw() -> void:
	_escala = minf(size.x / DISENO.x, size.y / DISENO.y)
	_desplazamiento = (size - DISENO * _escala) / 2.0
	draw_rect(Rect2(Vector2.ZERO, size), Color.BLACK)
	draw_set_transform(_desplazamiento, 0.0, Vector2(_escala, _escala))
	draw_rect(Rect2(Vector2.ZERO, DISENO), Z_FONDO if es_zaun() else P_FONDO)
	if _fondo_tex:
		imagen(_fondo_tex, Rect2(0, 0, 1600, 900), Color(1, 1, 1, 1.0 - oscurecer))
	_dibujar()
	_cabecera()
	_pie()
	draw_set_transform(Vector2.ZERO)

func _cabecera() -> void:
	draw_rect(Rect2(0, 0, 1600, 90), Color(0, 0, 0, 0.55))
	texto(Vector2(36, 54), nombre.to_upper(), 46, MARFIL, "titulo")
	if es_zaun():
		texto(Vector2(36, 80), _espaciado(subtitulo), 15, Z_ROSA, "titulo")
		draw_line(Vector2(0, 90), Vector2(1600, 90), Z_SHIMMER, 3)
	else:
		texto(Vector2(36, 79), _espaciado(subtitulo), 16, P_ORO, "cinzel")
		draw_line(Vector2(0, 90), Vector2(1600, 90), P_ORO, 2)
		draw_line(Vector2(0, 95), Vector2(1600, 95), Color(P_ORO, 0.35), 1)
	# Marcadores de arriba a la derecha (de derecha a izquierda).
	var x := 1564.0
	var chips: Array = _chips()
	chips.reverse()
	for c in chips:
		var ancho := ancho_texto(str(c[0]), 20, "titulo") + 38
		var r := Rect2(x - ancho, 24, ancho, 42)
		var destacado: bool = c.size() > 1 and c[1]
		var borde := (Z_ROSA if es_zaun() else P_HEX) if destacado else (Color(Z_SHIMMER, 0.8) if es_zaun() else Color(P_ORO, 0.8))
		draw_rect(r, Color(0, 0, 0, 0.35))
		draw_rect(r, borde, false, 1.5)
		texto(r.get_center() + Vector2(0, 8), str(c[0]), 20, MARFIL if not destacado or es_zaun() else Color("#bfe9f7"), "titulo", 1)
		x -= ancho + 14

func _pie() -> void:
	var y := DISENO.y - ALTO_PIE
	draw_rect(Rect2(0, y, 1600, ALTO_PIE), Color(0.07, 0.03, 0.09, 0.97) if es_zaun() else Color(0.04, 0.07, 0.13, 0.97))
	if es_zaun():
		var px := 0.0
		while px < 1600:
			draw_line(Vector2(px, y), Vector2(px + 6, y), Color(Z_SHIMMER, 0.8), 1.5)
			px += 10
	else:
		draw_line(Vector2(0, y), Vector2(1600, y), Color(P_ORO, 0.7), 1)
	texto(Vector2(36, y + 51), "CÓMO SE JUEGA", 20, acento(), "titulo")
	parrafo(Rect2(186, y + 30, 1380, 50), como_se_juega, 16, TEXTO)
	var x := 36.0
	for t in teclas:
		var ancho := ancho_texto(str(t[0]), 15, "titulo") + 18
		var r := Rect2(x, y + 64, ancho, 28)
		draw_rect(r, Z_SHIMMER if es_zaun() else Color("#f6e6bf"))
		texto(r.get_center() + Vector2(0, 6), str(t[0]), 15, Color.WHITE if es_zaun() else Color("#1a1a1a"), "titulo", 1)
		texto(Vector2(r.end.x + 9, y + 85), str(t[1]), 17, TEXTO)
		x = r.end.x + 9 + ancho_texto(str(t[1]), 17) + 28
	var aviso := "F1 · ver instrucciones completas · Minijuegos de %s" % ciudad
	texto(Vector2(1564, y + 85), aviso, 14, Color(TEXTO, 0.6), "texto", 2)

func _espaciado(s: String) -> String:
	return " ".join(s.to_upper().split(""))

# Panel «PARA QUÉ SIRVE» con puntos y, si hay, la cara y la frase de alguien.
func panel_info(r: Rect2, titulo: String, puntos_lista: Array, cara: String = "", frase: String = "") -> void:
	# El panel crece si el texto no cabe.
	var fin := r.position.y + 62
	for p in puntos_lista:
		fin = rico(Vector2(r.position.x + 40, fin), r.size.x - 62, str(p), 16, TEXTO, MARFIL, true) + 4
	if cara != "":
		fin += 76
	r.size.y = maxf(r.size.y, fin + 14 - r.position.y)
	panel(r)
	texto(r.position + Vector2(22, 42), titulo.to_upper(), 22, MARFIL, "titulo")
	var y := r.position.y + 62
	for p in puntos_lista:
		draw_circle(Vector2(r.position.x + 28, y + 11), 2.5, TEXTO)
		y = rico(Vector2(r.position.x + 40, y), r.size.x - 62, str(p), 16, TEXTO) + 4
	if cara != "":
		var c := Vector2(r.position.x + 52, y + 34)
		retrato(cara, c, 28)
		parrafo(Rect2(r.position.x + 92, y + 14, r.size.x - 110, 60), frase, 15, MARFIL, "italica")

func panel(r: Rect2, borde_izq: Color = Color.TRANSPARENT) -> void:
	draw_rect(r, color_panel())
	draw_rect(r, Color(Z_SHIMMER, 0.7) if es_zaun() else Color(P_ORO, 0.9), false, 1.5)
	var izq := borde_izq if borde_izq.a > 0 else (Z_SHIMMER if es_zaun() else Color.TRANSPARENT)
	if izq.a > 0:
		draw_rect(Rect2(r.position, Vector2(4, r.size.y)), izq)

# ---------- Ayudas de dibujo (coordenadas del diseño) ----------

func fuente(tipo: String) -> Font:
	if not _fuentes.has(tipo):
		var ruta: String = {"titulo": "res://assets/fonts/Arcane Nine.otf", "cinzel": "res://assets/fonts/Cinzel-VariableFont_wght.ttf",
			"italica": "res://assets/fonts/RobotoCondensed-Italic-VariableFont_wght.ttf"}.get(tipo, "res://assets/fonts/RobotoCondensed-VariableFont_wght.ttf")
		var f: Font = load(ruta)
		if tipo == "negrita":
			var v := FontVariation.new()
			v.base_font = f
			v.variation_embolden = 0.9
			f = v
		_fuentes[tipo] = f
	return _fuentes[tipo]

func ancho_texto(s: String, tam: int, tipo: String = "texto") -> float:
	return fuente(tipo).get_string_size(s, HORIZONTAL_ALIGNMENT_LEFT, -1, tam).x

# alinear: 0 izquierda, 1 centro, 2 derecha. pos.y es la línea base.
func texto(pos: Vector2, s: String, tam: int = 18, color: Color = TEXTO, tipo: String = "texto", alinear: int = 0) -> void:
	var ancho := ancho_texto(s, tam, tipo)
	var x := pos.x - (ancho / 2.0 if alinear == 1 else (ancho if alinear == 2 else 0.0))
	draw_string(fuente(tipo), Vector2(x, pos.y), s, HORIZONTAL_ALIGNMENT_LEFT, -1, tam, color)

func parrafo(r: Rect2, s: String, tam: int = 16, color: Color = TEXTO, tipo: String = "texto", alinear: int = 0) -> void:
	var al: int = [HORIZONTAL_ALIGNMENT_LEFT, HORIZONTAL_ALIGNMENT_CENTER, HORIZONTAL_ALIGNMENT_RIGHT][alinear]
	draw_multiline_string(fuente(tipo), r.position + Vector2(0, tam), s, al, r.size.x, tam, -1, color)

# Texto con **negritas** que se parte en líneas. Devuelve la y siguiente.
func rico(pos: Vector2, ancho: float, s: String, tam: int, color: Color, color_negrita: Color = MARFIL, solo_medir: bool = false) -> float:
	var x := pos.x
	var y := pos.y + tam
	var negrita := false
	for trozo in s.split("**"):
		for palabra in trozo.split(" ", false):
			var tipo := "negrita" if negrita else "texto"
			var w := ancho_texto(palabra + " ", tam, tipo)
			if x + w > pos.x + ancho and x > pos.x:
				x = pos.x
				y += tam + 7
			if not solo_medir:
				draw_string(fuente(tipo), Vector2(x, y), palabra, HORIZONTAL_ALIGNMENT_LEFT, -1, tam, color_negrita if negrita else color)
			x += w
		negrita = not negrita
	return y + 4

func cargar(ruta: String) -> Texture2D:
	if not _texturas.has(ruta):
		_texturas[ruta] = load(ruta) if ResourceLoader.exists(ruta) else null
	return _texturas[ruta]

# Imagen que rellena el rectángulo sin deformarse (recortando lo que sobra).
func imagen(t: Texture2D, r: Rect2, mod: Color = Color.WHITE) -> void:
	if t == null:
		return
	var ts := t.get_size()
	var k := maxf(r.size.x / ts.x, r.size.y / ts.y)
	var vista := r.size / k
	var origen := (ts - vista) / 2.0
	draw_texture_rect_region(t, r, Rect2(origen, vista), mod)

# Cara redonda de un personaje (o del jugador con "tu").
func retrato(quien: String, c: Vector2, radio: float, borde: Color = Color.TRANSPARENT) -> void:
	var ruta := Estilo.avatar_jugador() if quien == "tu" else Estilo.retrato(quien)
	var t := cargar(ruta)
	draw_circle(c, radio + 3, borde if borde.a > 0 else acento())
	draw_circle(c, radio, Color(0.1, 0.1, 0.12))
	if t:
		var puntos_c := PackedVector2Array()
		var uvs := PackedVector2Array()
		var ts := t.get_size()
		var lado := minf(ts.x, ts.y)
		var o := (ts - Vector2(lado, lado)) / 2.0
		for i in 40:
			var d := Vector2.from_angle(TAU * i / 40.0)
			puntos_c.append(c + d * radio)
			uvs.append((o + (d * 0.5 + Vector2(0.5, 0.5)) * lado) / ts)
		draw_colored_polygon(puntos_c, Color.WHITE, uvs, t)

func barra(r: Rect2, valor: float, color: Color, fondo_c: Color = Color(0, 0, 0, 0.5)) -> void:
	draw_rect(r, fondo_c)
	draw_rect(Rect2(r.position, Vector2(r.size.x * clampf(valor, 0, 1), r.size.y)), color)
	draw_rect(r, Color(color, 0.8), false, 1.2)

func reloj(segundos: float, decimas: bool = false) -> String:
	var s := maxf(segundos, 0.0)
	if decimas:
		return "%02d:%04.1f" % [int(s / 60), fmod(s, 60.0)]
	return "%02d:%02d" % [int(s / 60), int(s) % 60]

# --- Para sobrescribir ---
func _configurar() -> void: pass
func _empezar() -> void: pass
func _actualizar(_delta: float) -> void: pass
func _entrada(_evento: InputEvent) -> void: pass
func _entrada_raton(_evento: InputEvent) -> void: pass
func _dibujar() -> void: pass
func _chips() -> Array: return []
func _premio_extra() -> void: pass
func _opciones_mensaje(_col: VBoxContainer) -> void: pass

# Imagen con los bordes difuminados (para personajes con fondo propio): se funde con la escena.
func imagen_difuminada(t: Texture2D, r: Rect2, borde: float = 0.22) -> void:
	if t == null:
		return
	var n := 8
	for i in n:
		for j in n:
			var u0 := float(i) / n
			var u1 := float(i + 1) / n
			var v0 := float(j) / n
			var v1 := float(j + 1) / n
			var pts := PackedVector2Array()
			var uvs := PackedVector2Array()
			var cols := PackedColorArray()
			for uv in [Vector2(u0, v0), Vector2(u1, v0), Vector2(u1, v1), Vector2(u0, v1)]:
				pts.append(r.position + r.size * uv)
				uvs.append(uv)
				var d := minf(minf(uv.x, 1.0 - uv.x), minf(uv.y, 1.0 - uv.y) if uv.y < 0.5 else 1.0)
				cols.append(Color(1, 1, 1, smoothstep(0.0, borde, d)))
			draw_polygon(pts, cols, uvs, t)
