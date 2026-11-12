extends Node

# Escena principal de la partida: mapa 3D + HUD + capítulos.
# Flujo: título del capítulo → moverse por el mapa → entrar en el lugar marcado
# → diálogo, minijuego (si lo hay) y decisión → siguiente capítulo.

const ESCENA_MAPA := "res://escenas/mapa_3d.tscn"
const LugarEscena := preload("res://escenas/juego/lugar.gd")
const PausaEscena := preload("res://escenas/juego/pausa.gd")
const FinEscena := preload("res://escenas/juego/fin.gd")

const DESPLAZAMIENTO_CAMARA := Vector3(-30, 26, 62)

var mapa: Node3D
var jugador: Node3D
var camara: Camera3D
var marcador_objetivo: MeshInstance3D
var hud: CanvasLayer
var etiqueta_capitulo: Label
var etiqueta_objetivo: Label
var etiqueta_lugar: Label
var aviso_entrar: Label
var linea_actual: String = ""
var moviendo := false
# Mientras hay un lugar, título o menú abierto, el mapa no responde.
var bloqueado := false

func _ready() -> void:
	_montar_mapa()
	_montar_hud()
	# El punto de aparición es siempre el Puente, al empezar y al cargar.
	Progreso.lugar_actual = "Puente"
	linea_actual = "Piltover"
	_colocar_jugador(Progreso.lugar_actual, false)
	if Progreso.juego_terminado:
		_mostrar_fin()
		return
	_mostrar_titulo_capitulo()

# ---------- MAPA 3D ----------
func _montar_mapa() -> void:
	mapa = (load(ESCENA_MAPA) as PackedScene).instantiate()
	add_child(mapa)
	camara = mapa.get_node_or_null("CamaraMapa")
	jugador = mapa.get_node_or_null("Jugador")
	if jugador == null:
		jugador = Marker3D.new()
		mapa.add_child(jugador)
	# Figura del jugador: una esfera brillante del color de su ciudad.
	var figura := MeshInstance3D.new()
	var esfera := SphereMesh.new()
	esfera.radius = 2.2
	esfera.height = 4.4
	figura.mesh = esfera
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Estilo.acento()
	mat.emission_enabled = true
	mat.emission = Estilo.acento()
	mat.emission_energy_multiplier = 2.5
	figura.material_override = mat
	figura.position = Vector3(0, 3, 0)
	jugador.add_child(figura)
	var luz := OmniLight3D.new()
	luz.light_color = Estilo.acento()
	luz.omni_range = 14.0
	luz.light_energy = 2.0
	luz.position = Vector3(0, 5, 0)
	jugador.add_child(luz)
	# Aro que marca el lugar al que hay que ir.
	marcador_objetivo = MeshInstance3D.new()
	var aro := TorusMesh.new()
	aro.inner_radius = 3.2
	aro.outer_radius = 4.2
	marcador_objetivo.mesh = aro
	var mat2 := StandardMaterial3D.new()
	mat2.albedo_color = Estilo.MARFIL
	mat2.emission_enabled = true
	mat2.emission = Estilo.MARFIL
	mat2.emission_energy_multiplier = 3.0
	marcador_objetivo.material_override = mat2
	mapa.add_child(marcador_objetivo)

func _posicion(parada: String) -> Vector3:
	var nodo := mapa.get_node_or_null(Mapa.NODOS.get(parada, ""))
	return (nodo as Node3D).global_position if nodo else Vector3.ZERO

func _colocar_jugador(parada: String, animado: bool = true) -> void:
	Progreso.lugar_actual = parada
	var destino := _posicion(parada)
	if animado:
		moviendo = true
		var t := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		t.tween_property(jugador, "global_position", destino, 0.45)
		t.finished.connect(func(): moviendo = false)
	else:
		jugador.global_position = destino
	_actualizar_hud()

func _process(delta: float) -> void:
	if camara and jugador:
		var objetivo := jugador.global_position + DESPLAZAMIENTO_CAMARA
		camara.global_position = camara.global_position.lerp(objetivo, clampf(delta * 4.0, 0.0, 1.0))
		camara.look_at(jugador.global_position + Vector3(0, 4, 0), Vector3.UP)
	if marcador_objetivo:
		marcador_objetivo.rotate_y(delta * 1.4)

func _unhandled_input(evento: InputEvent) -> void:
	if evento.is_action_pressed("ui_cancel"):
		if not bloqueado:
			_abrir_pausa()
		get_viewport().set_input_as_handled()
		return
	if bloqueado or moviendo:
		return
	var actual := Progreso.lugar_actual
	if evento.is_action_pressed("ui_left") or evento.is_action_pressed("ui_right"):
		var dir := -1 if evento.is_action_pressed("ui_left") else 1
		var siguiente := Mapa.vecina(actual, dir, linea_actual)
		if siguiente != actual:
			# Al pasar por el ascensor de la Promenade cambiamos de línea.
			if actual == "AscensorPromenade":
				linea_actual = Mapa.linea_de(siguiente)
			elif not Mapa.es_ascensor(siguiente):
				linea_actual = Mapa.linea_de(siguiente)
			_colocar_jugador(siguiente)
	elif Mapa.es_ascensor(actual) and (evento.is_action_pressed("ui_up") or evento.is_action_pressed("ui_down")):
		var dir2 := -1 if evento.is_action_pressed("ui_up") else 1
		var piso := Mapa.ascensor(actual, dir2)
		if piso != actual:
			linea_actual = Mapa.linea_de(piso) if piso != "AscensorPromenade" else "Promenade"
			_colocar_jugador(piso)
	elif evento.is_action_pressed("ui_accept"):
		if actual == _capitulo()["lugar"]:
			_entrar_en_lugar()

# ---------- HUD ----------
func _montar_hud() -> void:
	hud = CanvasLayer.new()
	add_child(hud)
	var arriba := Estilo.panel(12)
	arriba.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	hud.add_child(arriba)
	var fila := HBoxContainer.new()
	fila.add_theme_constant_override("separation", 28)
	arriba.add_child(fila)
	var avatar := TextureRect.new()
	avatar.custom_minimum_size = Vector2(52, 52)
	avatar.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	avatar.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	if ResourceLoader.exists(Estilo.avatar_jugador()):
		avatar.texture = load(Estilo.avatar_jugador())
	fila.add_child(avatar)
	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	fila.add_child(col)
	etiqueta_capitulo = Estilo.etiqueta("", 22, Estilo.MARFIL, true)
	col.add_child(etiqueta_capitulo)
	etiqueta_objetivo = Estilo.etiqueta("", 16)
	col.add_child(etiqueta_objetivo)
	etiqueta_lugar = Estilo.etiqueta("", 18, Estilo.acento(), true)
	etiqueta_lugar.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	etiqueta_lugar.custom_minimum_size.x = 320
	fila.add_child(etiqueta_lugar)
	aviso_entrar = Estilo.etiqueta("Pulsa INTRO para entrar", 22, Estilo.MARFIL, true)
	aviso_entrar.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	aviso_entrar.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	aviso_entrar.offset_top = -120
	aviso_entrar.offset_bottom = -80
	aviso_entrar.grow_horizontal = Control.GROW_DIRECTION_BOTH
	hud.add_child(aviso_entrar)
	hud.add_child(Estilo.barra_instrucciones(
		"Recorre la ciudad hasta el lugar marcado con el aro y entra.",
		"← →  moverse   ·   ↑ ↓  ascensor   ·   INTRO  entrar   ·   ESC  pausa"))

func _capitulo() -> Dictionary:
	return Historia.capitulo(Progreso.capitulo_global())

func _actualizar_hud() -> void:
	if etiqueta_capitulo == null:
		return
	var c := _capitulo()
	etiqueta_capitulo.text = "Parte %d · Capítulo %d — %s" % [Progreso.parte, Progreso.capitulo, c["titulo"]]
	etiqueta_objetivo.text = "Ve a: %s  ·  Te espera %s" % [Mapa.nombre(c["lugar"]), Historia.nombre(c["personaje"])]
	etiqueta_lugar.text = Mapa.nombre(Progreso.lugar_actual)
	if Mapa.es_ascensor(Progreso.lugar_actual):
		etiqueta_lugar.text += "  (↑ ↓)"
	aviso_entrar.visible = Progreso.lugar_actual == c["lugar"] and not bloqueado
	if marcador_objetivo:
		marcador_objetivo.global_position = _posicion(c["lugar"]) + Vector3(0, 0.5, 0)

# ---------- CAPÍTULOS ----------
func _mostrar_titulo_capitulo() -> void:
	bloqueado = true
	_actualizar_hud()
	var capa := CanvasLayer.new()
	capa.layer = 5
	add_child(capa)
	var velo := Estilo.velo(0.88)
	capa.add_child(velo)
	var centro := CenterContainer.new()
	centro.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	centro.mouse_filter = Control.MOUSE_FILTER_IGNORE
	capa.add_child(centro)
	var caja := VBoxContainer.new()
	caja.custom_minimum_size.x = 1000
	caja.alignment = BoxContainer.ALIGNMENT_CENTER
	centro.add_child(caja)
	caja.add_child(Estilo.titulo("PARTE %d" % Progreso.parte, 26))
	caja.add_child(Estilo.titulo("Capítulo %d" % Progreso.capitulo, 58))
	var sep := HSeparator.new()
	sep.add_theme_color_override("separator", Estilo.acento())
	caja.add_child(sep)
	caja.add_child(Estilo.titulo(_capitulo()["titulo"], 34))
	capa.set_meta("velo", velo)
	velo.modulate.a = 0.0
	caja.modulate.a = 0.0
	var t := create_tween()
	t.tween_property(velo, "modulate:a", 1.0, 0.5)
	t.parallel().tween_property(caja, "modulate:a", 1.0, 0.8)
	t.tween_interval(2.0)
	t.tween_property(caja, "modulate:a", 0.0, 0.6)
	t.parallel().tween_property(velo, "modulate:a", 0.0, 0.6)
	t.finished.connect(func():
		capa.queue_free()
		bloqueado = false
		_actualizar_hud()
		_tutorial_mapa())

func _tutorial_mapa() -> void:
	if "mapa" in Progreso.tutoriales_vistos:
		return
	Progreso.tutoriales_vistos.append("mapa")
	_ventana_aviso("Cómo moverse por el mapa",
		"Piltover está arriba y Zaun abajo. Usa ← → para ir de un lugar a otro por cada línea.\n\nEn Zaun, al llegar al ascensor, usa ↑ ↓ para subir o bajar entre la Promenade, el Entresuelo y el Sumidero.\n\nEl aro brillante marca dónde te espera la historia: llega hasta él y pulsa INTRO.")

func _ventana_aviso(titulo: String, texto: String) -> void:
	bloqueado = true
	var capa := CanvasLayer.new()
	capa.layer = 6
	add_child(capa)
	capa.add_child(Estilo.velo(0.6))
	var p := Estilo.panel(28)
	p.custom_minimum_size = Vector2(620, 0)
	p.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	p.grow_horizontal = Control.GROW_DIRECTION_BOTH
	p.grow_vertical = Control.GROW_DIRECTION_BOTH
	capa.add_child(p)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 16)
	p.add_child(col)
	col.add_child(Estilo.titulo(titulo, 30))
	col.add_child(Estilo.etiqueta(texto, 18, Estilo.TEXTO, false, true))
	var b := Estilo.boton("Entendido", 220, true)
	b.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	col.add_child(b)
	b.grab_focus.call_deferred()
	b.pressed.connect(func():
		capa.queue_free()
		bloqueado = false
		_actualizar_hud())

func _entrar_en_lugar() -> void:
	bloqueado = true
	_actualizar_hud()
	var lugar := LugarEscena.new()
	lugar.capitulo = _capitulo()
	lugar.terminado.connect(_capitulo_terminado.bind(lugar))
	var capa := CanvasLayer.new()
	capa.layer = 7
	add_child(capa)
	capa.add_child(lugar)

func _capitulo_terminado(lugar: Control) -> void:
	lugar.get_parent().queue_free()
	var quedan := Progreso.avanzar_capitulo()
	Guardado.guardar()
	bloqueado = false
	if quedan:
		_mostrar_titulo_capitulo()
	else:
		_mostrar_fin()

func _mostrar_fin() -> void:
	bloqueado = true
	var capa := CanvasLayer.new()
	capa.layer = 8
	add_child(capa)
	capa.add_child(FinEscena.new())

func _abrir_pausa() -> void:
	var pausa := PausaEscena.new()
	add_child(pausa)
