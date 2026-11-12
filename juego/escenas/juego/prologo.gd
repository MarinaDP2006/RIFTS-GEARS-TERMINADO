extends Control

# Prólogo: si existe res://assets/video/prologo.ogv lo reproduce (el vídeo lo edita Marina).
# Si todavía no está, muestra una presentación de Piltover y Zaun con imágenes.
# ESPACIO / INTRO / ESC lo saltan.

const VIDEO := "res://assets/video/prologo.ogv"
const DIAPOSITIVAS := [
	["res://assets/lugares/s1/piltover.webp", "Piltover", "La Ciudad del Progreso. Torres doradas, vidrieras y engranajes de latón. Aquí arriba, el futuro se fabrica."],
	["res://assets/lugares/s1/zaun.webp", "Zaun", "Debajo del Puente, una ciudad de humo, tuberías y gente que no se rinde. Aquí abajo, el futuro se sobrevive."],
	["res://assets/lugares/s1/puente.webp", "El Puente del Progreso", "Lo único que las une. Y lo primero que se rompe cuando algo sale mal."],
	["", "", "Y en medio de todo, alguien más del barrio: tú."],
]

var indice := 0
var imagen: TextureRect
var titulo: Label
var texto: Label
var terminado := false

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var negro := ColorRect.new()
	negro.color = Color.BLACK
	negro.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(negro)
	if ResourceLoader.exists(VIDEO):
		var v := VideoStreamPlayer.new()
		v.stream = load(VIDEO)
		v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		v.expand = true
		add_child(v)
		v.finished.connect(_terminar)
		v.play()
	else:
		imagen = Estilo.fondo_imagen("")
		add_child(imagen)
		var sombra := ColorRect.new()
		sombra.color = Color(0, 0, 0, 0.45)
		sombra.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		add_child(sombra)
		var col := VBoxContainer.new()
		col.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
		col.grow_horizontal = Control.GROW_DIRECTION_BOTH
		col.grow_vertical = Control.GROW_DIRECTION_BEGIN
		col.offset_bottom = -110
		col.custom_minimum_size.x = 900
		col.offset_left = -450
		col.offset_right = 450
		add_child(col)
		titulo = Estilo.titulo("", 64)
		col.add_child(titulo)
		texto = Estilo.etiqueta("", 22, Estilo.MARFIL, false, true)
		texto.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		col.add_child(texto)
		_mostrar()
	var saltar := Estilo.etiqueta("ESPACIO  siguiente   ·   ESC  saltar", 15, Estilo.TEXTO)
	saltar.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	saltar.offset_left = -360
	saltar.offset_top = -40
	saltar.offset_right = -24
	saltar.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(saltar)

func _mostrar() -> void:
	var d: Array = DIAPOSITIVAS[indice]
	imagen.texture = load(d[0]) if d[0] != "" and ResourceLoader.exists(d[0]) else null
	titulo.text = d[1]
	texto.text = d[2]
	modulate.a = 0.0
	create_tween().tween_property(self, "modulate:a", 1.0, 0.7)

func _unhandled_input(evento: InputEvent) -> void:
	if evento.is_action_pressed("ui_cancel"):
		_terminar()
	elif evento.is_action_pressed("ui_accept") or (evento is InputEventMouseButton and evento.pressed):
		if imagen == null:
			return
		indice += 1
		if indice >= DIAPOSITIVAS.size():
			_terminar()
		else:
			_mostrar()

func _terminar() -> void:
	if terminado:
		return
	terminado = true
	Progreso.prologo_visto = true
	Guardado.guardar()
	get_tree().change_scene_to_file("res://escenas/juego/juego.tscn")
