extends RefCounted

# Aplica el estilo visual del título principal de Rifts & Gears.
static func aplicar(titulo: Label, tamano: int = 46) -> void:
	# Carga la misma fuente que utiliza el menú de inicio.
	var fuente := load("res://assets/fonts/Arcane Nine.otf") as Font

	if fuente != null:
		titulo.add_theme_font_override("font", fuente)
	else:
		push_warning("No se pudo cargar la fuente Arcane Nine.")

	# Centra el texto y establece su tamaño.
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	titulo.add_theme_font_size_override("font_size", tamano)
	# Utiliza el mismo color marfil del menú principal.
	titulo.add_theme_color_override("font_color",Color(1.0, 0.94, 0.79))
	# Añade la sombra oscura para mejorar la legibilidad.
	titulo.add_theme_color_override("font_shadow_color", Color(0.0, 0.015, 0.035, 0.95))
	titulo.add_theme_constant_override("shadow_offset_x", 2)
	titulo.add_theme_constant_override("shadow_offset_y", 3)
