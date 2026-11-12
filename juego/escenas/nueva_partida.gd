extends Control
# Color principal de los textos.
const MARFIL := Color("#E9DFC9")
# Colores propios de Piltover.
const ORO_PILTOVER := Color("#C5A15B")
const AZUL_PILTOVER := Color("#173D4A")
# Colores propios de Zaun.
const SHIMMER_ZAUN := Color("#C24DE0")
const OSCURO_ZAUN := Color("#1E1428")
# Color común para el botón de regreso.
const FONDO_BOTON := Color("#171B20")
# Color de las sombras de los textos.
const SOMBRA_TEXTO := Color("#080B10")

# Busca un nodo por su nombre dentro de toda la escena.
func _buscar_nodo(nombre: String) -> Node:
	return find_child(nombre, true, false)

func _ready() -> void:
	var boton_piltover := _buscar_nodo("BotonPiltover") as Button
	var boton_zaun := _buscar_nodo("BotonZaun") as Button
	var boton_volver := _buscar_nodo("BotonVolver") as Button
	# Comprobar que los botones existen.
	if boton_piltover == null:
		push_error("No se encontró el botón de Piltover.")
		return
	if boton_zaun == null:
		push_error("No se encontró el botón de Zaun.")
		return
	if boton_volver == null:
		push_error("No se encontró el botón Volver.")
		return

	# Conectar los botones con funciones.
	if not boton_piltover.pressed.is_connected(_elegir_piltover):
		boton_piltover.pressed.connect(_elegir_piltover)
	if not boton_zaun.pressed.is_connected(_elegir_zaun):
		boton_zaun.pressed.connect(_elegir_zaun)
	if not boton_volver.pressed.is_connected(_volver_al_menu):
		boton_volver.pressed.connect(_volver_al_menu)

	# Configurar las imágenes y símbolos de las ciudades.
	var imagen_piltover := _buscar_nodo("ImgPiltover") as TextureRect
	var imagen_zaun := _buscar_nodo("ImgZaun") as TextureRect
	if imagen_piltover != null:
		_configurar_imagen(imagen_piltover)
	if imagen_zaun != null:
		_configurar_imagen(imagen_zaun)
	var simbolo_piltover := _buscar_nodo("SimboloPiltover") as TextureRect
	var simbolo_zaun := _buscar_nodo("SimboloZaun") as TextureRect
	if simbolo_piltover != null:
		_configurar_simbolo(simbolo_piltover)
	if simbolo_zaun != null:
		_configurar_simbolo(simbolo_zaun)

	# Estilo visual de cada botón.
	_estilizar_boton(boton_piltover, AZUL_PILTOVER, ORO_PILTOVER)
	_estilizar_boton(boton_zaun,OSCURO_ZAUN,SHIMMER_ZAUN)
	_estilizar_boton(boton_volver,FONDO_BOTON, ORO_PILTOVER)

# Configurar los nombres de las ciudades.
	var etiqueta_piltover := _buscar_nodo("LabelPiltover") as Label
	var etiqueta_zaun := _buscar_nodo("LabelZaun") as Label
	if etiqueta_piltover != null:
		_estilizar_titulo(etiqueta_piltover, MARFIL, 44)
	if etiqueta_zaun != null:
		_estilizar_titulo(etiqueta_zaun, MARFIL, 44)

	# Dar a cada tarjeta el borde de su ciudad.
	var tarjeta_piltover := _buscar_nodo("TarjetaPiltover") as PanelContainer
	var tarjeta_zaun := _buscar_nodo("TarjetaZaun") as PanelContainer
	if tarjeta_piltover != null:
		_estilizar_tarjeta(tarjeta_piltover, ORO_PILTOVER)
	if tarjeta_zaun != null:
		_estilizar_tarjeta(tarjeta_zaun, SHIMMER_ZAUN)

	var titulo := _buscar_nodo("Titulo") as Control
	if titulo != null:
		_estilizar_titulo(titulo, MARFIL, 32)
		# Si es un Button, quitar q parece un boton
		if titulo is Button:
			var boton_titulo := titulo as Button
			boton_titulo.flat = true
			boton_titulo.focus_mode = Control.FOCUS_NONE
			boton_titulo.mouse_filter = Control.MOUSE_FILTER_IGNORE

			# Eliminamos el fondo y el borde del botón.
			boton_titulo.add_theme_stylebox_override(
				"normal",
				StyleBoxEmpty.new()
			)
			boton_titulo.add_theme_stylebox_override(
				"hover",
				StyleBoxEmpty.new()
			)
			boton_titulo.add_theme_stylebox_override(
				"pressed",
				StyleBoxEmpty.new()
			)
			boton_titulo.add_theme_stylebox_override(
				"focus",
				StyleBoxEmpty.new()
			)

# CONFIGURACIÓN DE LAS IMÁGENES
# Ajusta la presentación de las imágenes sin sustituir sus texturas.
func _configurar_imagen(imagen: TextureRect) -> void:
	# Ignora el tamaño original de la imagen.
	imagen.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	# Rellena el espacio disponible manteniendo las proporciones.
	imagen.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED

# CONFIGURACIÓN DE LOS SÍMBOLOS
# Ajusta la presentación de los símbolos sin cambiar su posición.
func _configurar_simbolo(simbolo: TextureRect) -> void:
	# Permite adaptar el símbolo al espacio asignado.
	simbolo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	# Mantiene las proporciones originales del símbolo.
	simbolo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	# Evita que el símbolo se estire de manera desproporcionada.
	simbolo.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	simbolo.size_flags_vertical = Control.SIZE_SHRINK_CENTER

# ESTILO DE LAS TARJETAS
# Dibuja solo el borde: la foto de la ciudad hace de fondo de la tarjeta.
func _estilizar_tarjeta(tarjeta: PanelContainer, color_borde: Color) -> void:
	var estilo := StyleBoxFlat.new()
	estilo.draw_center = false
	estilo.border_color = color_borde
	estilo.set_border_width_all(2)
	estilo.set_content_margin_all(2.0)
	tarjeta.add_theme_stylebox_override("panel", estilo)

# ESTILO DE LOS BOTONES
func _estilizar_boton(
	boton: Button,
	color_base: Color,
	color_borde: Color
) -> void:
	# Colores del texto en los diferentes estados.
	boton.add_theme_color_override("font_color", MARFIL)
	boton.add_theme_color_override("font_hover_color", Color.WHITE)
	boton.add_theme_color_override("font_pressed_color", MARFIL)
	boton.add_theme_color_override("font_focus_color", MARFIL)
	# Tamaño de la letra.
	boton.add_theme_font_size_override("font_size", 20)
	# Sombra del texto.
	boton.add_theme_color_override("font_shadow_color",SOMBRA_TEXTO)
	boton.add_theme_constant_override("shadow_offset_x", 2)
	boton.add_theme_constant_override("shadow_offset_y", 2)

	# Apariencia normal del botón.
	var normal := StyleBoxFlat.new()
	normal.bg_color = color_base
	normal.border_color = color_borde
	normal.set_border_width_all(2)
	# Esquinas cortadas en diagonal, como en creacion_personaje.gd.
	normal.set_corner_radius_all(10)
	normal.corner_detail = 1
	normal.content_margin_left = 22.0
	normal.content_margin_right = 22.0
	normal.content_margin_top = 12.0
	normal.content_margin_bottom = 12.0

	# Apariencia al pasar el ratón.
	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = color_base.lightened(0.16)
	hover.border_color = MARFIL
	hover.set_border_width_all(2)

	# Apariencia al pulsar el botón.
	var pulsado := normal.duplicate() as StyleBoxFlat
	pulsado.bg_color = color_base.darkened(0.15)
	pulsado.border_color = color_borde

	# Aplicamos los estilos al botón.
	boton.add_theme_stylebox_override("normal", normal)
	boton.add_theme_stylebox_override("hover", hover)
	boton.add_theme_stylebox_override("pressed", pulsado)
	boton.add_theme_stylebox_override("focus", normal)

# ESTILO DE LOS TÍTULOS
# Da presencia a los títulos y añade una sombra oscura.
func _estilizar_titulo(
	etiqueta: Control,
	color: Color,
	tamano: int
) -> void:
	# Color principal del texto.
	etiqueta.add_theme_color_override("font_color", color)
	# Color de la sombra.
	etiqueta.add_theme_color_override("font_shadow_color",SOMBRA_TEXTO)
	# Desplazamiento de la sombra.
	etiqueta.add_theme_constant_override("shadow_offset_x", 3)
	etiqueta.add_theme_constant_override("shadow_offset_y", 3)
	# Tamaño de la letra.
	etiqueta.add_theme_font_size_override("font_size", tamano)

# SELECCIÓN DE CIUDAD
# Guarda Piltover y abre el creador de personajes.
func _elegir_piltover() -> void:
	DatosPartida.ciudad_elegida = "Piltover"
	_abrir_creador()

# Guarda Zaun y abre el creador de personajes.
func _elegir_zaun() -> void:
	DatosPartida.ciudad_elegida = "Zaun"
	_abrir_creador()

# NAVEGACIÓN ENTRE PANTALLAS
# Abre la pantalla de creación de personaje.
func _abrir_creador() -> void:
	var resultado := get_tree().change_scene_to_file(
		"res://escenas/creacion_personaje.tscn"
	)
	if resultado != OK:
		push_error("No se pudo abrir el creador de personajes.")

# Regresa al menú principal.
func _volver_al_menu() -> void:
	var resultado := get_tree().change_scene_to_file(
		"res://escenas/inicio.scn"
	)
	if resultado != OK:
		push_error("No se pudo regresar al menú principal.")
