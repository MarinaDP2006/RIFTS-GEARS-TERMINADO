extends Node2D

# Referencias a los nodos visuales creados en la escena inicio.scn
@onready var sprite_fondo: Sprite2D = $Sprite2D
@onready var columna_menu: VBoxContainer = $Interfaz/ContenedorPantalla/ColumnaMenu
@onready var titulo: Label = $Interfaz/ContenedorPantalla/ColumnaMenu/Titulo
@onready var linea_decorativa: HSeparator = $Interfaz/ContenedorPantalla/ColumnaMenu/LineaDecorativa
@onready var boton_jugar: Button = $Interfaz/ContenedorPantalla/ColumnaMenu/BotonJugar
@onready var boton_nueva: Button = $Interfaz/ContenedorPantalla/ColumnaMenu/BotonNueva
@onready var boton_cargar: Button = $Interfaz/ContenedorPantalla/ColumnaMenu/BotonCargar
@onready var boton_ajustes: Button = $Interfaz/ContenedorPantalla/ColumnaMenu/BotonAjustes
@onready var boton_salir: Button = $Interfaz/ContenedorPantalla/ColumnaMenu/BotonSalir

func _ready() -> void:
	# Sprite2D tiene este script repetido por error: solo actúa el de Mundo.
	if sprite_fondo == null:
		return

	# 1. Configurar el fondo y volver a ajustarlo si cambia la ventana
	sprite_fondo.centered = true
	sprite_fondo.z_index = -1
	_ajustar_fondo()
	get_viewport().size_changed.connect(_ajustar_fondo)

	# Configurar el estilo y texto del Título principal
	if titulo:
		titulo.text = "RIFTS & GEARS"
		titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		var fuente_titulo = load("res://assets/fonts/Arcane Nine.otf") as Font
		if fuente_titulo != null:
			titulo.add_theme_font_override("font", fuente_titulo)
		else:
			push_warning("No se pudo cargar la fuente Arcane Nine.")

		titulo.add_theme_font_size_override("font_size", 64)
		titulo.add_theme_color_override("font_color", Color(1.0, 0.94, 0.79)) # Marfil
		titulo.add_theme_color_override("font_shadow_color", Color(0.0, 0.015, 0.035, 0.95))
		titulo.add_theme_constant_override("shadow_offset_x", 2)
		titulo.add_theme_constant_override("shadow_offset_y", 3)
		titulo.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	# 3. Aplicar estilos personalizados a los botones del menú
	_aplicar_estilo_boton(boton_jugar)
	# Destacar el botón principal con un borde dorado más intenso.
	if boton_jugar:
		var estilo_jugar = StyleBoxFlat.new()
		estilo_jugar.bg_color = Color(0.035, 0.12, 0.21, 0.98)
		estilo_jugar.border_color = Color(0.83, 0.67, 0.34, 1.0)
		estilo_jugar.set_border_width_all(2)
		estilo_jugar.set_corner_radius_all(10)
		estilo_jugar.corner_detail = 1
		estilo_jugar.content_margin_left = 18
		estilo_jugar.content_margin_right = 18
		estilo_jugar.content_margin_top = 10
		estilo_jugar.content_margin_bottom = 10
		boton_jugar.add_theme_stylebox_override("normal", estilo_jugar)
		
	_aplicar_estilo_boton(boton_nueva)
	_aplicar_estilo_boton(boton_cargar)
	_aplicar_estilo_boton(boton_ajustes)
	_aplicar_estilo_boton(boton_salir)

	# 4. Conectar señales de los botones para que respondan al hacer clic
	if boton_jugar and not boton_jugar.pressed.is_connected(_on_boton_jugar_pressed):
		boton_jugar.pressed.connect(_on_boton_jugar_pressed)
	if boton_nueva and not boton_nueva.pressed.is_connected(_on_boton_nueva_pressed):
		boton_nueva.pressed.connect(_on_boton_nueva_pressed)
	if boton_cargar and not boton_cargar.pressed.is_connected(_on_boton_cargar_pressed):
		boton_cargar.pressed.connect(_on_boton_cargar_pressed)
	if boton_ajustes and not boton_ajustes.pressed.is_connected(_on_boton_ajustes_pressed):
		boton_ajustes.pressed.connect(_on_boton_ajustes_pressed)
	if boton_salir and not boton_salir.pressed.is_connected(_on_boton_salir_pressed):
		boton_salir.pressed.connect(_on_boton_salir_pressed)

	# 5. Colocar el menú
	_colocar_menu()

# Escala la imagen para cubrir toda la ventana sin deformarla.
func _ajustar_fondo() -> void:
	var tamano_ventana := get_viewport_rect().size
	var tamano_imagen := sprite_fondo.texture.get_size()
	var escala := maxf(tamano_ventana.x / tamano_imagen.x, tamano_ventana.y / tamano_imagen.y)
	sprite_fondo.scale = Vector2(escala, escala)
	sprite_fondo.position = tamano_ventana / 2.0

# Coloca la columna a la derecha y centrada en vertical, para dejar a la vista a Jinx.
func _colocar_menu() -> void:
	columna_menu.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	columna_menu.grow_vertical = Control.GROW_DIRECTION_BOTH
	columna_menu.set_anchors_and_offsets_preset(Control.PRESET_CENTER_RIGHT, Control.PRESET_MODE_MINSIZE, 72)

# Función para aplicar estilos visuales a cada botón
func _aplicar_estilo_boton(boton: Button) -> void:
	# Comprobar que el botón existe.
	if boton == null:
		return

	# Ajustar el tamaño y centrar el botón en la columna.
	boton.custom_minimum_size = Vector2(300, 52)
	boton.size_flags_horizontal = Control.SIZE_SHRINK_CENTER

	# Definir los colores azul marino y dorado.
	var color_normal = Color(0.025, 0.075, 0.14, 0.97)
	var color_hover = Color(0.055, 0.15, 0.24, 1.0)
	var color_borde = Color(0.70, 0.54, 0.27, 1.0)

	# Dar al botón un fondo oscuro con borde dorado.
	var estilo_normal = StyleBoxFlat.new()
	estilo_normal.bg_color = color_normal
	estilo_normal.border_color = color_borde
	estilo_normal.set_border_width_all(2)
	estilo_normal.set_corner_radius_all(10)
	estilo_normal.corner_detail = 1
	estilo_normal.content_margin_left = 18
	estilo_normal.content_margin_right = 18
	estilo_normal.content_margin_top = 10
	estilo_normal.content_margin_bottom = 10
	boton.add_theme_stylebox_override("normal", estilo_normal)

	# Aclarar el fondo cuando el ratón pasa por encima.
	var estilo_hover = estilo_normal.duplicate() as StyleBoxFlat
	estilo_hover.bg_color = color_hover
	boton.add_theme_stylebox_override("hover", estilo_hover)

	# Oscurecer el fondo al pulsar el botón.
	var estilo_pulsado = estilo_normal.duplicate() as StyleBoxFlat
	estilo_pulsado.bg_color = color_hover.darkened(0.2)
	boton.add_theme_stylebox_override("pressed", estilo_pulsado)

	# Mantener el texto claro y legible.
	boton.add_theme_color_override("font_color", Color(0.91, 0.93, 0.95))
	boton.add_theme_color_override("font_hover_color", Color.WHITE)
	boton.add_theme_color_override("font_pressed_color", Color.WHITE)
	boton.add_theme_color_override("font_focus_color", Color.WHITE)

	# Establecer el tamaño de las letras.
	boton.add_theme_font_size_override("font_size", 18)

	# Cargar la fuente Roboto Condensed.
	var fuente_botones = load("res://assets/fonts/RobotoCondensed-VariableFont_wght.ttf") as Font
	if fuente_botones != null:
		boton.add_theme_font_override("font", fuente_botones)
	else:
		push_warning("No se pudo cargar la fuente de los botones.")

# --- Funciones de acción de los botones ---
func _on_boton_jugar_pressed() -> void:
	# Continúa la partida guardada más reciente; si no hay ninguna, empieza una nueva.
	var ranura := Guardado.mas_reciente()
	if ranura > 0 and Guardado.cargar(ranura):
		var destino := "res://escenas/juego/juego.tscn" if Progreso.prologo_visto else "res://escenas/juego/prologo.tscn"
		get_tree().change_scene_to_file(destino)
	else:
		Progreso.reiniciar()
		get_tree().change_scene_to_file("res://escenas/nueva_partida.tscn")
# Abre la ventana para empezar una partida nueva
func _on_boton_nueva_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/nueva_partida.tscn")
func _on_boton_cargar_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/cargar_partida.tscn")
func _on_boton_ajustes_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/ajustes.tscn")
func _on_boton_salir_pressed() -> void:
	get_tree().quit()
