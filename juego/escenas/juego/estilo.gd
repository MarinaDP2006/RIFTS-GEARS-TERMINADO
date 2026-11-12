class_name Estilo
extends RefCounted

# Colores y ayudas de estilo compartidos por todas las pantallas del juego.
# Piltover = azul marino y dorado. Zaun = oscuro con brillo shimmer (#C24DE0).

const MARINO := Color(0.025, 0.075, 0.14, 0.97)
const MARINO_CLARO := Color(0.055, 0.15, 0.24, 1.0)
const DORADO := Color(0.83, 0.67, 0.34, 1.0)
const DORADO_SUAVE := Color(0.70, 0.54, 0.27, 1.0)
const MARFIL := Color(1.0, 0.94, 0.79)
const TEXTO := Color(0.91, 0.93, 0.95)
const ZAUN_FONDO := Color(0.06, 0.03, 0.08, 0.97)
const ZAUN_FONDO_CLARO := Color(0.13, 0.06, 0.16, 1.0)
const SHIMMER := Color("#C24DE0")

const FUENTE_TITULO := "res://assets/fonts/Arcane Nine.otf"
const FUENTE_TEXTO := "res://assets/fonts/RobotoCondensed-VariableFont_wght.ttf"

# Devuelve true si la partida es de Zaun.
static func es_zaun() -> bool:
	return DatosPartida.ciudad_elegida == "Zaun"

# Color de acento según la ciudad de la partida.
static func acento() -> Color:
	return SHIMMER if es_zaun() else DORADO

static func fondo_panel() -> Color:
	return ZAUN_FONDO if es_zaun() else MARINO

static func fondo_panel_claro() -> Color:
	return ZAUN_FONDO_CLARO if es_zaun() else MARINO_CLARO

static func fuente_titulo() -> Font:
	return load(FUENTE_TITULO) as Font

static func fuente_texto() -> Font:
	return load(FUENTE_TEXTO) as Font

# Caja con fondo oscuro y borde del color de la ciudad.
static func caja(borde: Color = Color.TRANSPARENT, radio: int = 10, margen: int = 16) -> StyleBoxFlat:
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = fondo_panel()
	estilo.border_color = acento() if borde == Color.TRANSPARENT else borde
	estilo.set_border_width_all(2)
	estilo.set_corner_radius_all(radio)
	estilo.corner_detail = 1
	estilo.set_content_margin_all(margen)
	return estilo

# Panel ya montado con la caja de la ciudad.
static func panel(margen: int = 16) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", caja(Color.TRANSPARENT, 10, margen))
	return p

# Etiqueta con la fuente del juego.
static func etiqueta(texto: String, tamano: int = 18, color: Color = TEXTO, titulo: bool = false, ajustar: bool = false) -> Label:
	var l := Label.new()
	l.text = texto
	l.add_theme_font_override("font", fuente_titulo() if titulo else fuente_texto())
	l.add_theme_font_size_override("font_size", tamano)
	l.add_theme_color_override("font_color", color)
	# Solo se parte en varias líneas si se pide: en filas horizontales, un texto partido se queda sin ancho.
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART if ajustar else TextServer.AUTOWRAP_OFF
	return l

static func titulo(texto: String, tamano: int = 42) -> Label:
	var l := etiqueta(texto, tamano, MARFIL, true, true)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_color_override("font_shadow_color", Color(0, 0.015, 0.035, 0.95))
	l.add_theme_constant_override("shadow_offset_x", 2)
	l.add_theme_constant_override("shadow_offset_y", 3)
	return l

# Botón con el mismo estilo que los del menú de inicio.
static func boton(texto: String, ancho: float = 300.0, destacado: bool = false) -> Button:
	var b := Button.new()
	b.text = texto
	b.custom_minimum_size = Vector2(ancho, 48)
	b.focus_mode = Control.FOCUS_ALL
	var normal := caja(acento() if destacado else (SHIMMER.darkened(0.25) if es_zaun() else DORADO_SUAVE), 10, 10)
	normal.content_margin_left = 18
	normal.content_margin_right = 18
	b.add_theme_stylebox_override("normal", normal)
	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = fondo_panel_claro()
	hover.border_color = acento()
	b.add_theme_stylebox_override("hover", hover)
	b.add_theme_stylebox_override("focus", hover)
	var pulsado := hover.duplicate() as StyleBoxFlat
	pulsado.bg_color = fondo_panel_claro().darkened(0.2)
	b.add_theme_stylebox_override("pressed", pulsado)
	var apagado := normal.duplicate() as StyleBoxFlat
	apagado.bg_color = apagado.bg_color.darkened(0.4)
	apagado.border_color = Color(0.4, 0.4, 0.4)
	b.add_theme_stylebox_override("disabled", apagado)
	b.add_theme_color_override("font_color", TEXTO)
	b.add_theme_color_override("font_hover_color", Color.WHITE)
	b.add_theme_color_override("font_pressed_color", Color.WHITE)
	b.add_theme_color_override("font_focus_color", Color.WHITE)
	b.add_theme_font_override("font", fuente_texto())
	b.add_theme_font_size_override("font_size", 18)
	return b

# Capa oscura que tapa la pantalla (para menús y ventanas).
static func velo(opacidad: float = 0.72) -> ColorRect:
	var v := ColorRect.new()
	v.color = Color(0, 0.01, 0.03, opacidad)
	v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	v.mouse_filter = Control.MOUSE_FILTER_STOP
	return v

# Imagen que cubre todo el control sin deformarse.
static func fondo_imagen(ruta: String) -> TextureRect:
	var t := TextureRect.new()
	t.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if ResourceLoader.exists(ruta):
		t.texture = load(ruta)
	return t

# Barra al pie con «Cómo se juega» y las teclas (obligatoria en minijuegos).
static func barra_instrucciones(como_se_juega: String, teclas: String) -> PanelContainer:
	var p := PanelContainer.new()
	var estilo := caja(Color.TRANSPARENT, 0, 10)
	estilo.border_width_left = 0
	estilo.border_width_right = 0
	estilo.border_width_bottom = 0
	p.add_theme_stylebox_override("panel", estilo)
	p.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	p.grow_vertical = Control.GROW_DIRECTION_BEGIN
	var fila := HBoxContainer.new()
	fila.add_theme_constant_override("separation", 24)
	p.add_child(fila)
	var izq := etiqueta("CÓMO SE JUEGA  ", 16, acento(), true)
	fila.add_child(izq)
	var texto := etiqueta(como_se_juega, 16, TEXTO, false, true)
	texto.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	texto.custom_minimum_size.x = 300
	fila.add_child(texto)
	var t := etiqueta(teclas, 16, MARFIL)
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	fila.add_child(t)
	return p

# Ruta de la cara pequeña de un personaje (o "" si no hay).
static func retrato(id: String) -> String:
	var r := "res://assets/caras/retratos/%s.jpg" % id
	if ResourceLoader.exists(r):
		return r
	r = "res://assets/caras/%s.png" % id
	return r if ResourceLoader.exists(r) else ""

# Ruta del avatar del jugador.
static func avatar_jugador() -> String:
	return "res://assets/avatares/%s-%d.webp" % [DatosPartida.tipo_avatar, DatosPartida.numero_avatar]
