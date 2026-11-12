extends Control
# Opciones de los apartados 2 a 6.
const Opciones = preload("res://escenas/opciones_creacion.gd")
# Número del último apartado: 0 es Identidad y 6 es la Ficha final.
const APARTADO_FINAL := 6
# Tamaño del corte de las esquinas, como en los marcos art déco de Arcane.
const CHAFLAN := 10

# Colores de la identidad visual (los mismos que en nueva_partida.gd).
const MARFIL := Color("#E9DFC9")
const ORO_PILTOVER := Color("#C5A15B")
const AZUL_PILTOVER := Color("#173D4A")
const SHIMMER_ZAUN := Color("#C24DE0")
const OSCURO_ZAUN := Color("#1E1428")
const SOMBRA_TEXTO := Color("#080B10")

# Referencias a los nodos de la interfaz.
@onready var titulo: Label = $MargenPrincipal/ContenedorPrincipal/Encabezado/Titulo
@onready var panel_contenido: PanelContainer = $MargenPrincipal/ContenedorPrincipal/CuerpoCreacion/PanelContenido
@onready var panel_apartados: PanelContainer = $MargenPrincipal/ContenedorPrincipal/CuerpoCreacion/PanelApartados
@onready var lista_apartados: VBoxContainer = $MargenPrincipal/ContenedorPrincipal/CuerpoCreacion/PanelApartados/ListaApartados
@onready var boton_identidad: Button = $MargenPrincipal/ContenedorPrincipal/CuerpoCreacion/PanelApartados/ListaApartados/BotonIdentidad
@onready var boton_volver: Button = $MargenPrincipal/ContenedorPrincipal/Pie/BotonVolver
@onready var boton_continuar: Button = $MargenPrincipal/ContenedorPrincipal/Pie/BotonContinuar
@onready var boton_hombre: Button = $MargenPrincipal/ContenedorPrincipal/CuerpoCreacion/PanelContenido/ContenidoIdentidad/ZonaAvatar/PanelPersonajes/SelectorTipoAvatar/BotonHombre
@onready var boton_mujer: Button = $MargenPrincipal/ContenedorPrincipal/CuerpoCreacion/PanelContenido/ContenidoIdentidad/ZonaAvatar/PanelPersonajes/SelectorTipoAvatar/BotonMujer
@onready var tarjetas_avatares: GridContainer = $MargenPrincipal/ContenedorPrincipal/CuerpoCreacion/PanelContenido/ContenidoIdentidad/ZonaAvatar/PanelPersonajes/TarjetasAvatares
@onready var vista_previa: TextureRect = $MargenPrincipal/ContenedorPrincipal/CuerpoCreacion/PanelContenido/ContenidoIdentidad/ZonaAvatar/VistaPrevia
@onready var nombre_personaje: LineEdit = $MargenPrincipal/ContenedorPrincipal/CuerpoCreacion/PanelContenido/ContenidoIdentidad/NombrePersonaje
@onready var titulo_creacion: Label = $MargenPrincipal/ContenedorPrincipal/Encabezado/TituloCreacion
@onready var contenido_identidad: VBoxContainer = $MargenPrincipal/ContenedorPrincipal/CuerpoCreacion/PanelContenido/ContenidoIdentidad
@onready var zona_apartado: ScrollContainer = $MargenPrincipal/ContenedorPrincipal/CuerpoCreacion/PanelContenido/ZonaApartado
@onready var contenido_apartado: VBoxContainer = $MargenPrincipal/ContenedorPrincipal/CuerpoCreacion/PanelContenido/ZonaApartado/ContenidoApartado
@onready var aviso: Label = $MargenPrincipal/ContenedorPrincipal/Pie/Aviso
@onready var edad: SpinBox = $MargenPrincipal/ContenedorPrincipal/CuerpoCreacion/PanelContenido/ContenidoIdentidad/ZonaAvatar/PanelPersonajes/SelectorTipoAvatar/Edad

# Guarda el género con el que se escriben los textos.
var genero: String = "hombre"
# Guarda el apartado que se está mostrando.
var apartado_actual: int = 0
# Guarda el apartado más avanzado al que se ha llegado.
var apartado_maximo: int = 0
# Busca las marcas {g:o|a} de los textos.
var patron_genero := RegEx.create_from_string("\\{g:([^|}]*)\\|([^}]*)\\}")
# Guarda el tipo de avatar que se está mostrando.
var tipo_avatar: String = "hombre"
# Guarda el número del avatar seleccionado.
var avatar_seleccionado: int = 1
# Guardan los colores de la ciudad elegida.
var color_base: Color = AZUL_PILTOVER
var color_borde: Color = ORO_PILTOVER
# Guarda las rutas de los avatares masculinos.
var avatares_hombre: Array[String] = [
	"res://assets/avatares/hombre-1.webp",
	"res://assets/avatares/hombre-2.webp",
	"res://assets/avatares/hombre-3.webp",
	"res://assets/avatares/hombre-4.webp",
	"res://assets/avatares/hombre-5.webp",
	"res://assets/avatares/hombre-6.webp",
	"res://assets/avatares/hombre-7.webp",
	"res://assets/avatares/hombre-8.webp"
]
# Guarda las rutas de los avatares femeninos.
var avatares_mujer: Array[String] = [
	"res://assets/avatares/mujer-1.webp",
	"res://assets/avatares/mujer-2.webp",
	"res://assets/avatares/mujer-3.webp",
	"res://assets/avatares/mujer-4.webp",
	"res://assets/avatares/mujer-5.webp",
	"res://assets/avatares/mujer-6.webp",
	"res://assets/avatares/mujer-7.webp",
	"res://assets/avatares/mujer-8.webp"
]

# Conecta los botones y muestra los avatares al abrir la pantalla.
func _ready() -> void:
	boton_hombre.pressed.connect(_mostrar_hombres)
	boton_mujer.pressed.connect(_mostrar_mujeres)
	# Conecta cada botón de la lista con su apartado.
	for i in range(lista_apartados.get_child_count()):
		(lista_apartados.get_child(i) as Button).pressed.connect(_ir_a_apartado.bind(i))
	# Empieza de cero: la ciudad ha podido cambiar y sus opciones son distintas.
	DatosPartida.reiniciar_creacion()
	# Al probar, no se ha pasado por la selección de ciudad.
	if DatosPartida.ciudad_elegida == "":
		DatosPartida.ciudad_elegida = "Piltover"
	_aplicar_estilo_ciudad()
	actualizar_avatares()
	_mostrar_apartado()

# Elige los colores según la ciudad y los aplica a toda la pantalla.
func _aplicar_estilo_ciudad() -> void:
	if DatosPartida.ciudad_elegida == "Zaun":
		color_base = OSCURO_ZAUN
		color_borde = SHIMMER_ZAUN

	titulo.add_theme_color_override("font_color", MARFIL)
	titulo.add_theme_color_override("font_shadow_color", SOMBRA_TEXTO)

	_estilizar_panel(panel_contenido)
	_estilizar_panel(panel_apartados)
	_estilizar_campo(nombre_personaje)
	_estilizar_campo(edad.get_line_edit())
	_estilizar_boton(boton_volver)
	_estilizar_boton(boton_continuar)

	var fuente := titulo.get_theme_font("font")
	edad.get_line_edit().add_theme_font_override("font", fuente)
	aviso.add_theme_font_override("font", fuente)
	aviso.add_theme_font_size_override("font_size", 18)
	aviso.add_theme_color_override("font_color", MARFIL)
	aviso.add_theme_color_override("font_shadow_color", SOMBRA_TEXTO)

# Corta las esquinas en diagonal: con un solo punto de curva quedan rectas.
func _cortar_esquinas(estilo: StyleBoxFlat) -> void:
	estilo.set_corner_radius_all(CHAFLAN)
	estilo.corner_detail = 1

# Da a un panel el fondo y el borde de la ciudad.
func _estilizar_panel(panel: PanelContainer) -> void:
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = Color(color_base, 0.88)
	estilo.border_color = color_borde
	estilo.set_border_width_all(2)
	_cortar_esquinas(estilo)
	estilo.set_content_margin_all(12.0)
	panel.add_theme_stylebox_override("panel", estilo)

# Da al campo de texto los colores de la ciudad.
func _estilizar_campo(campo: LineEdit) -> void:
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = color_base.darkened(0.35)
	estilo.border_color = color_borde
	estilo.set_border_width_all(2)
	_cortar_esquinas(estilo)
	estilo.content_margin_left = 12.0
	estilo.content_margin_right = 12.0
	estilo.content_margin_top = 6.0
	estilo.content_margin_bottom = 6.0

	campo.add_theme_stylebox_override("normal", estilo)
	campo.add_theme_stylebox_override("focus", estilo)
	campo.add_theme_color_override("font_color", MARFIL)
	campo.add_theme_color_override("font_placeholder_color", Color(MARFIL, 0.6))
	campo.add_theme_color_override("caret_color", MARFIL)

# Da a un botón el estilo de la ciudad. Un botón activo brilla como la hextech.
func _estilizar_boton(boton: Button, tamano: int = 20, activo: bool = false) -> void:
	boton.add_theme_color_override("font_color", MARFIL)
	boton.add_theme_color_override("font_hover_color", Color.WHITE)
	boton.add_theme_color_override("font_pressed_color", MARFIL)
	boton.add_theme_color_override("font_focus_color", MARFIL)
	boton.add_theme_color_override("font_disabled_color", Color(MARFIL, 0.45))
	boton.add_theme_color_override("font_shadow_color", SOMBRA_TEXTO)
	boton.add_theme_constant_override("shadow_offset_x", 2)
	boton.add_theme_constant_override("shadow_offset_y", 2)
	boton.add_theme_font_size_override("font_size", tamano)

	var normal := StyleBoxFlat.new()
	normal.bg_color = color_base.lightened(0.16) if activo else color_base
	normal.border_color = MARFIL if activo else color_borde
	normal.set_border_width_all(2)
	# Bordes redondos: el radio es mayor que la mitad del alto del botón.
	normal.set_corner_radius_all(40)
	if activo:
		normal.shadow_color = Color(color_borde, 0.5)
		normal.shadow_size = 6
	normal.content_margin_left = 22.0
	normal.content_margin_right = 22.0
	normal.content_margin_top = 8.0
	normal.content_margin_bottom = 8.0

	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = color_base.lightened(0.08)
	hover.border_color = color_borde.lightened(0.35)

	var pulsado := normal.duplicate() as StyleBoxFlat
	pulsado.bg_color = color_base.darkened(0.15)
	pulsado.border_color = color_borde

	var desactivado := normal.duplicate() as StyleBoxFlat
	desactivado.bg_color = Color(color_base, 0.5)
	desactivado.border_color = Color(color_borde, 0.35)
	desactivado.shadow_size = 0
	boton.add_theme_stylebox_override("normal", normal)
	boton.add_theme_stylebox_override("hover", hover)
	boton.add_theme_stylebox_override("pressed", pulsado)
	boton.add_theme_stylebox_override("focus", normal)
	boton.add_theme_stylebox_override("disabled", desactivado)

# Marca una tarjeta de avatar con el borde de la ciudad si está elegida.
func _estilizar_tarjeta(tarjeta: Button, activa: bool) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = color_base
	normal.border_color = color_borde if activa else color_base
	normal.set_border_width_all(3)
	normal.set_corner_radius_all(5)

	var hover := normal.duplicate() as StyleBoxFlat
	hover.border_color = MARFIL
	tarjeta.add_theme_stylebox_override("normal", normal)
	tarjeta.add_theme_stylebox_override("hover", hover)
	tarjeta.add_theme_stylebox_override("pressed", normal)
	tarjeta.add_theme_stylebox_override("focus", normal)

# Muestra como activo el botón del género elegido.
func _actualizar_selector_tipo() -> void:
	_estilizar_boton(boton_mujer, 16, genero == "mujer")
	_estilizar_boton(boton_hombre, 16, genero == "hombre")

# Muestra los avatares masculinos.
func _mostrar_hombres() -> void:
	genero = "hombre"
	tipo_avatar = "hombre"
	avatar_seleccionado = 1
	actualizar_avatares()

# Muestra los avatares femeninos.
func _mostrar_mujeres() -> void:
	genero = "mujer"
	tipo_avatar = "mujer"
	avatar_seleccionado = 1
	actualizar_avatares()

# Crea las tarjetas de los avatares disponibles.
func actualizar_avatares() -> void:
	_actualizar_selector_tipo()
	var contenedor: GridContainer = tarjetas_avatares
	# Elimina las tarjetas anteriores.
	for hijo in contenedor.get_children():
		contenedor.remove_child(hijo)
		hijo.free()
	# Selecciona la lista de avatares correspondiente.
	var lista_avatares: Array[String]
	if tipo_avatar == "hombre":
		lista_avatares = avatares_hombre
	else:
		lista_avatares = avatares_mujer

	# Crea una tarjeta para cada avatar con tamaño sin alteración
	for i in range(lista_avatares.size()):
		var tarjeta := Button.new()
		tarjeta.custom_minimum_size = Vector2(100, 120)
		tarjeta.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tarjeta.size_flags_vertical = Control.SIZE_EXPAND_FILL
		tarjeta.clip_contents = true
		# Carga la imagen del avatar.
		var textura := load(lista_avatares[i]) as Texture2D
		if textura != null:
			var imagen := TextureRect.new()
			imagen.texture = textura
			imagen.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			imagen.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
			# Deja 3 píxeles libres para que se vea el borde de la tarjeta.
			imagen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_MINSIZE, 3)
			# Permite que el clic llegue al botón.
			imagen.mouse_filter = Control.MOUSE_FILTER_IGNORE
			tarjeta.add_child(imagen)
		else:
			push_error("No se pudo cargar el avatar: " + lista_avatares[i])

		# Conecta la tarjeta con el avatar que representa.
		tarjeta.pressed.connect(_seleccionar_avatar.bind(i + 1))
		# Añade la tarjeta a la cuadrícula.
		contenedor.add_child(tarjeta)
	# Selecciona automáticamente el primer avatar.
	_seleccionar_avatar(1)

# Guarda el avatar seleccionado y actualiza su vista previa.
func _seleccionar_avatar(numero: int) -> void:
	avatar_seleccionado = numero
	# Resalta solo la tarjeta elegida.
	for i in range(tarjetas_avatares.get_child_count()):
		_estilizar_tarjeta(tarjetas_avatares.get_child(i) as Button, i + 1 == numero)
	var ruta: String
	if tipo_avatar == "hombre":
		ruta = avatares_hombre[numero - 1]
	else:
		ruta = avatares_mujer[numero - 1]

	var textura := load(ruta) as Texture2D
	if textura != null:
		vista_previa.texture = textura
		vista_previa.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		vista_previa.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	else:
		push_error("No se pudo cargar la vista previa: " + ruta)

# Retrocede un apartado o, desde Identidad, vuelve a la selección de ciudad.
func _on_boton_volver_pressed() -> void:
	if apartado_actual > 0:
		_ir_a_apartado(apartado_actual - 1)
	else:
		get_tree().change_scene_to_file("res://escenas/nueva_partida.tscn")

# Avanza al siguiente apartado si el actual está completo.
func _on_boton_continuar_pressed() -> void:
	if apartado_actual == APARTADO_FINAL:
		_finalizar_personaje()
		return

	var problema := _comprobar_apartado(apartado_actual)
	if problema != "":
		aviso.text = problema
		return

	if apartado_actual == 0:
		_guardar_identidad()
	apartado_actual += 1
	apartado_maximo = maxi(apartado_maximo, apartado_actual)
	_mostrar_apartado()

# Abre un apartado desde la lista lateral.
func _ir_a_apartado(numero: int) -> void:
	# Identidad no se guarda sola: hay que guardarla antes de salir de ella.
	if apartado_actual == 0:
		var problema := _comprobar_apartado(0)
		if problema != "":
			aviso.text = problema
			return
		_guardar_identidad()
	apartado_actual = numero
	_mostrar_apartado()

# Guarda el nombre y el avatar en el Autoload.
func _guardar_identidad() -> void:
	DatosPartida.nombre_personaje = nombre_personaje.text.strip_edges()
	DatosPartida.genero = genero
	DatosPartida.edad = int(edad.value)
	DatosPartida.tipo_avatar = tipo_avatar
	DatosPartida.numero_avatar = avatar_seleccionado

# Devuelve qué falta en un apartado, o un texto vacío si está completo.
func _comprobar_apartado(numero: int) -> String:
	match numero:
		0:
			if nombre_personaje.text.strip_edges().is_empty():
				return "Escribe un nombre para tu personaje."
		1:
			if DatosPartida.padres == "":
				return "Elige cómo es tu familia."
			if DatosPartida.familia == "":
				return "Elige tu vínculo familiar."
			if DatosPartida.atraccion == "":
				return "Elige quién te atrae."
		2:
			if DatosPartida.distrito == "":
				return "Elige de qué lugar vienes."
		3:
			if DatosPartida.ocupacion == "":
				return "Elige tu ocupación."
		4:
			if DatosPartida.rasgos.is_empty():
				return "Elige al menos un rasgo."
		5:
			if DatosPartida.aficiones.is_empty():
				return "Elige al menos una afición."
	return ""

# Comprueba toda la creación y marca el personaje como terminado.
func _finalizar_personaje() -> void:
	for i in range(APARTADO_FINAL):
		var problema := _comprobar_apartado(i)
		if problema != "":
			# Lleva al apartado incompleto para que se pueda arreglar.
			_ir_a_apartado(i)
			aviso.text = problema
			return
	DatosPartida.estadisticas = _calcular_estadisticas()
	DatosPartida.afinidades = _familia_elegida().get("afinidad", {}).duplicate()
	DatosPartida.personaje_creado = true
	aviso.text = "¡Personaje creado!"
	# Empieza la partida: guarda en una ranura y abre el prólogo.
	var ranura := Progreso.ranura
	Progreso.reiniciar()
	Progreso.ranura = ranura
	Guardado.guardar()
	await get_tree().create_timer(0.8).timeout
	get_tree().change_scene_to_file("res://escenas/juego/prologo.tscn")

# Muestra el apartado actual y actualiza la lista lateral y los botones.
func _mostrar_apartado() -> void:
	aviso.text = ""
	# Tras cualquier cambio hay que volver a pulsar FINALIZAR.
	DatosPartida.personaje_creado = false
	for i in range(lista_apartados.get_child_count()):
		var boton := lista_apartados.get_child(i) as Button
		boton.disabled = i > apartado_maximo
		_estilizar_boton(boton, 16, i == apartado_actual)

	var boton_actual := lista_apartados.get_child(apartado_actual) as Button
	titulo_creacion.text = "· " + boton_actual.text.get_slice("· ", 1)
	boton_continuar.text = "FINALIZAR" if apartado_actual == APARTADO_FINAL else "CONTINUAR"

	# Identidad tiene sus propios nodos; los demás apartados se crean por código.
	contenido_identidad.visible = apartado_actual == 0
	zona_apartado.visible = apartado_actual != 0

	for hijo in contenido_apartado.get_children():
		contenido_apartado.remove_child(hijo)
		hijo.queue_free()

	match apartado_actual:
		1:
			_construir_familia()
		2:
			_construir_procedencia()
		3:
			_construir_ocupacion()
		4:
			_construir_personalidad()
		5:
			_construir_aficiones()
		6:
			_construir_ficha()

# Apartado 2: padres, vínculo familiar y atracción.
func _construir_familia() -> void:
	_nuevo_titulo("Tus padres")
	_nuevo_grupo(Opciones.PADRES, [DatosPartida.padres], _elegir_padres, 4)
	_nuevo_titulo("Vínculo familiar")
	_nuevo_grupo(_familias_posibles(), [DatosPartida.familia], _elegir_familia, 3)

	var familia := _familia_elegida()
	if not familia.is_empty():
		var descripcion := Label.new()
		descripcion.text = _genero(familia["descripcion"])
		descripcion.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		descripcion.add_theme_font_override("font", titulo.get_theme_font("font"))
		descripcion.add_theme_font_size_override("font_size", 16)
		descripcion.add_theme_color_override("font_color", MARFIL)
		contenido_apartado.add_child(descripcion)

	_nuevo_titulo("Te atraen")
	_nuevo_grupo(Opciones.ATRACCIONES, [DatosPartida.atraccion], _elegir_atraccion, 4)

# Devuelve las familias posibles según los padres elegidos.
func _familias_posibles() -> Array:
	var posibles: Array = []
	for familia in Opciones.de_ciudad(DatosPartida.ciudad_elegida)["familias"]:
		if DatosPartida.padres == "ambos" and familia.get("falta_familia", false):
			continue
		posibles.append(familia)
	return posibles

# Devuelve la familia elegida, o un diccionario vacío si aún no hay ninguna.
func _familia_elegida() -> Dictionary:
	for familia in Opciones.de_ciudad(DatosPartida.ciudad_elegida)["familias"]:
		if familia["id"] == DatosPartida.familia:
			return familia
	return {}

# Suma a la base de 1 punto lo que dan la ocupación, la familia y las aficiones.
func _calcular_estadisticas() -> Dictionary:
	var ciudad := Opciones.de_ciudad(DatosPartida.ciudad_elegida)
	var total := {}
	for nombre in Opciones.ESTADISTICAS:
		total[nombre] = 1

	var elegidas: Array = [_familia_elegida()]
	for ocupacion in ciudad["ocupaciones"]:
		if ocupacion["id"] == DatosPartida.ocupacion:
			elegidas.append(ocupacion)
	for aficion in Opciones.AFICIONES:
		if DatosPartida.aficiones.has(aficion["id"]):
			elegidas.append(aficion)

	for opcion in elegidas:
		var puntos: Dictionary = opcion.get("stats", {})
		for nombre in puntos:
			total[nombre] += puntos[nombre]
	return total

# Convierte los puntos de una opción en un texto como "+2 Ingenio".
func _texto_puntos(puntos: Dictionary) -> String:
	var textos := PackedStringArray()
	for nombre in puntos:
		textos.append("+%d %s" % [puntos[nombre], Opciones.ESTADISTICAS[nombre]])
	return ", ".join(textos)

# Apartado 3: barrio de procedencia.
func _construir_procedencia() -> void:
	_nuevo_titulo("¿De qué lugar de %s vienes?" % DatosPartida.ciudad_elegida)
	_nuevo_grupo(Opciones.de_ciudad(DatosPartida.ciudad_elegida)["distritos"], [DatosPartida.distrito], _elegir_distrito)

# Apartado 4: ocupación.
func _construir_ocupacion() -> void:
	_nuevo_titulo("¿A qué te dedicas?")
	_nuevo_grupo(Opciones.de_ciudad(DatosPartida.ciudad_elegida)["ocupaciones"], [DatosPartida.ocupacion], _elegir_ocupacion)

# Apartado 5: rasgos de personalidad.
func _construir_personalidad() -> void:
	_nuevo_titulo("Elige hasta %d rasgos (%d de %d)" % [Opciones.MAX_RASGOS, DatosPartida.rasgos.size(), Opciones.MAX_RASGOS])
	_nuevo_grupo(Opciones.RASGOS, DatosPartida.rasgos, _alternar_rasgo, 3)

# Apartado 6: aficiones.
func _construir_aficiones() -> void:
	_nuevo_titulo("Elige hasta %d aficiones (%d de %d)" % [Opciones.MAX_AFICIONES, DatosPartida.aficiones.size(), Opciones.MAX_AFICIONES])
	_nuevo_grupo(Opciones.AFICIONES, DatosPartida.aficiones, _alternar_aficion)

# Apartado 7: ficha final con el avatar y todo lo elegido.
func _construir_ficha() -> void:
	var ciudad := Opciones.de_ciudad(DatosPartida.ciudad_elegida)
	var fila := HBoxContainer.new()
	fila.add_theme_constant_override("separation", 20)
	contenido_apartado.add_child(fila)

	var retrato := TextureRect.new()
	retrato.texture = vista_previa.texture
	retrato.custom_minimum_size = Vector2(300, 400)
	retrato.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	retrato.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	fila.add_child(retrato)

	var datos := GridContainer.new()
	datos.columns = 2
	datos.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	datos.add_theme_constant_override("h_separation", 16)
	datos.add_theme_constant_override("v_separation", 10)
	fila.add_child(datos)

	var puntos := PackedStringArray()
	var estadisticas := _calcular_estadisticas()
	for nombre in Opciones.ESTADISTICAS:
		puntos.append("%s %d" % [Opciones.ESTADISTICAS[nombre], estadisticas[nombre]])

	_nuevo_dato(datos, "Nombre", DatosPartida.nombre_personaje)
	_nuevo_dato(datos, "Género", Opciones.GENEROS[DatosPartida.genero])
	_nuevo_dato(datos, "Edad", str(DatosPartida.edad))
	_nuevo_dato(datos, "Ciudad", "%s · %s" % [DatosPartida.ciudad_elegida, _texto_de(ciudad["distritos"], DatosPartida.distrito)])
	_nuevo_dato(datos, "Ocupación", _texto_de(ciudad["ocupaciones"], DatosPartida.ocupacion))
	_nuevo_dato(datos, "Padres", _texto_de(Opciones.PADRES, DatosPartida.padres))
	_nuevo_dato(datos, "Vínculo familiar", _texto_de(ciudad["familias"], DatosPartida.familia))
	_nuevo_dato(datos, "Repercusión", _genero(_familia_elegida().get("descripcion", "")))
	_nuevo_dato(datos, "Te atraen", _texto_de(Opciones.ATRACCIONES, DatosPartida.atraccion))
	_nuevo_dato(datos, "Rasgos", _textos_de(Opciones.RASGOS, DatosPartida.rasgos))
	_nuevo_dato(datos, "Aficiones", _textos_de(Opciones.AFICIONES, DatosPartida.aficiones))
	_nuevo_dato(datos, "Estadísticas", " · ".join(puntos))

# Añade un título de sección al apartado.
func _nuevo_titulo(texto: String) -> void:
	var etiqueta := Label.new()
	etiqueta.text = texto
	etiqueta.add_theme_font_override("font", titulo.get_theme_font("font"))
	etiqueta.add_theme_font_size_override("font_size", 20)
	etiqueta.add_theme_color_override("font_color", color_borde)
	etiqueta.add_theme_color_override("font_shadow_color", SOMBRA_TEXTO)
	contenido_apartado.add_child(etiqueta)

# Añade una cuadrícula de botones; los que están en "elegidos" salen activos.
func _nuevo_grupo(opciones: Array, elegidos: Array, al_elegir: Callable, columnas: int = 2) -> void:
	var grupo := GridContainer.new()
	grupo.columns = columnas
	grupo.add_theme_constant_override("h_separation", 8)
	grupo.add_theme_constant_override("v_separation", 8)
	contenido_apartado.add_child(grupo)

	for opcion in opciones:
		var boton := Button.new()
		boton.text = _genero(opcion["texto"])
		if opcion.has("stats"):
			boton.text += "\n" + _texto_puntos(opcion["stats"])
		boton.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		boton.add_theme_font_override("font", titulo.get_theme_font("font"))
		_estilizar_boton(boton, 16, elegidos.has(opcion["id"]))
		boton.pressed.connect(al_elegir.bind(opcion["id"]))
		grupo.add_child(boton)

# Añade una fila "título: valor" a la ficha final.
func _nuevo_dato(datos: GridContainer, nombre: String, valor: String) -> void:
	var fuente := titulo.get_theme_font("font")

	var etiqueta := Label.new()
	etiqueta.text = nombre
	etiqueta.add_theme_font_override("font", fuente)
	etiqueta.add_theme_font_size_override("font_size", 16)
	etiqueta.add_theme_color_override("font_color", color_borde)
	datos.add_child(etiqueta)

	var contenido := Label.new()
	contenido.text = valor
	contenido.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	contenido.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	contenido.add_theme_font_override("font", fuente)
	contenido.add_theme_font_size_override("font_size", 16)
	contenido.add_theme_color_override("font_color", MARFIL)
	datos.add_child(contenido)

# Cambia las marcas {g:o|a} por la forma del género elegido.
func _genero(texto: String) -> String:
	var forma := "$1"
	if genero == "mujer":
		forma = "$2"
	return patron_genero.sub(texto, forma, true)

# Devuelve el texto de la opción con ese identificador.
func _texto_de(opciones: Array, id: String) -> String:
	for opcion in opciones:
		if opcion["id"] == id:
			return _genero(opcion["texto"])
	return ""

# Devuelve los textos de varias opciones separados por comas.
func _textos_de(opciones: Array, ids: Array[String]) -> String:
	var textos := PackedStringArray()
	for id in ids:
		textos.append(_texto_de(opciones, id))
	return ", ".join(textos)

# Guarda los padres y quita la familia elegida si deja de ser posible.
func _elegir_padres(id: String) -> void:
	DatosPartida.padres = id
	var quitada := DatosPartida.familia != "" and not _familias_posibles().has(_familia_elegida())
	if quitada:
		DatosPartida.familia = ""
	_mostrar_apartado()
	if quitada:
		aviso.text = "Tu vínculo familiar ya no encaja: elige otro."

# Guarda el vínculo familiar.
func _elegir_familia(id: String) -> void:
	DatosPartida.familia = id
	_mostrar_apartado()

# Guarda quién atrae al personaje.
func _elegir_atraccion(id: String) -> void:
	DatosPartida.atraccion = id
	_mostrar_apartado()

# Guarda el barrio de procedencia.
func _elegir_distrito(id: String) -> void:
	DatosPartida.distrito = id
	_mostrar_apartado()

# Guarda la ocupación.
func _elegir_ocupacion(id: String) -> void:
	DatosPartida.ocupacion = id
	_mostrar_apartado()

# Marca o desmarca un rasgo.
func _alternar_rasgo(id: String) -> void:
	_alternar(DatosPartida.rasgos, id, Opciones.MAX_RASGOS)

# Marca o desmarca una afición.
func _alternar_aficion(id: String) -> void:
	_alternar(DatosPartida.aficiones, id, Opciones.MAX_AFICIONES)

# Marca o desmarca una opción sin pasar del máximo permitido.
func _alternar(lista: Array[String], id: String, maximo: int) -> void:
	if lista.has(id):
		lista.erase(id)
	elif lista.size() < maximo:
		lista.append(id)
	_mostrar_apartado()
