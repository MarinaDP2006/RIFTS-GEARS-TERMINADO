extends Control

# Archivo donde se guardan los ajustes entre partidas.
const RUTA_AJUSTES := "user://ajustes.cfg"
# Idiomas en el mismo orden que el desplegable de Idioma.
const IDIOMAS := ["es", "en", "fr"]

# Qué apartado enseña cada botón de la lista.
const APARTADOS := {
	"BotonGeneral": "ContenidoGeneral",
	"BotonAudio": "ContenidoAudio",
	"BotonJuego": "ContenidoJuego",
	"BotonPantalla": "ContenidoPantalla",
	"BotonControles": "ContenidoControles",
	"BotonAcercaDe": "ContenidoAcercaDe",
}

# Bus de audio que controla cada slider (se crean en la pestaña Audio del editor).
const BUSES := {
	"SelectorVolumenGeneral": "Master",
	"SelectorMusica": "Musica",
	"SelectorEfectos": "Efectos",
	"SelectorVoces": "Voces",
}

# Cada control de la escena con la sección y la clave con las que se guarda.
const CONTROLES := {
	# General
	"SelectorIdioma": ["general", "idioma"],
	"SelectorVelocidad": ["general", "velocidad_texto"],
	"SelectorTamanoLetra": ["general", "tamano_letra"],
	# Audio
	"SelectorVolumenGeneral": ["audio", "volumen_general"],
	"SelectorMusica": ["audio", "musica"],
	"SelectorEfectos": ["audio", "efectos"],
	"SelectorVoces": ["audio", "voces"],
	"SelectorSilenciar": ["audio", "silenciar"],
	# Juego
	"SelectorDificultad": ["juego", "dificultad"],
	"SelectorAutoguardado": ["juego", "autoguardado"],
	"SelectorConfirmarSalida": ["juego", "confirmar_salida"],
	"SelectorConsejos": ["juego", "consejos"],
	# Pantalla
	"SelectorPantallaCompleta": ["pantalla", "pantalla_completa"],
	"SelectorCalidadGrafica": ["pantalla", "calidad_grafica"],
	"SelectorBrillo": ["pantalla", "brillo"],
	"SelectorMostrarFPS": ["pantalla", "mostrar_fps"],
	# Controles en móvil
	"SelectorTamanoBotones": ["controles", "tamano_botones"],
	"SelectorOpacidad": ["controles", "opacidad"],
}

# Ajustes guardados en el archivo.
var ajustes := ConfigFile.new()

# Busca un nodo por su nombre dentro de toda la escena.
func _buscar_nodo(nombre: String) -> Node:
	return find_child(nombre, true, false)

func _ready() -> void:
	# 1. Conectar cada botón de la lista con su apartado y empezar en General.
	for nombre_boton in APARTADOS:
		var boton := _buscar_nodo(nombre_boton) as Button
		if boton == null:
			push_error("No se encontró el botón " + nombre_boton + ".")
			continue
		boton.pressed.connect(_mostrar_apartado.bind(APARTADOS[nombre_boton]))
	_mostrar_apartado("ContenidoGeneral")

	# 2. Cargar los ajustes guardados y ponerlos en los controles.
	# Si el archivo aún no existe, se quedan los valores que tiene la escena.
	ajustes.load(RUTA_AJUSTES)
	_cargar_en_controles()

	# 3. El volumen cambia en cuanto se mueve el slider, para oírlo al momento.
	for nombre_slider in BUSES:
		var slider := _buscar_nodo(nombre_slider) as HSlider
		if slider == null:
			continue
		slider.value_changed.connect(_cambiar_volumen.bind(BUSES[nombre_slider]))
		_cambiar_volumen(slider.value, BUSES[nombre_slider])
	var boton_silenciar := _buscar_nodo("SelectorSilenciar") as CheckButton
	if boton_silenciar != null:
		boton_silenciar.toggled.connect(_silenciar)
		_silenciar(boton_silenciar.button_pressed)

	# 4. Conectar los botones de abajo.
	var boton_volver := _buscar_nodo("BotonVolver") as Button
	var boton_aplicar := _buscar_nodo("BotonAplicar") as Button
	if boton_volver != null:
		boton_volver.pressed.connect(_volver_al_menu)
	if boton_aplicar != null:
		boton_aplicar.pressed.connect(_aplicar)

# Enseña solo el apartado elegido y oculta los demás.
func _mostrar_apartado(nombre_contenido: String) -> void:
	for contenido in APARTADOS.values():
		var nodo := _buscar_nodo(contenido) as Control
		if nodo != null:
			nodo.visible = contenido == nombre_contenido

# Pone en cada control el valor guardado.
func _cargar_en_controles() -> void:
	for nombre in CONTROLES:
		var control := _buscar_nodo(nombre)
		if control == null:
			push_warning("No se encontró " + nombre + ".")
			continue
		var seccion: String = CONTROLES[nombre][0]
		var clave: String = CONTROLES[nombre][1]
		_escribir_control(control, ajustes.get_value(seccion, clave, _leer_control(control)))

# Devuelve el valor de un control según su tipo.
# OptionButton va primero porque también es un botón.
func _leer_control(control: Node) -> Variant:
	if control is OptionButton:
		return control.selected
	if control is Range:
		return control.value
	if control is BaseButton:
		return control.button_pressed
	return null

# Cambia el valor de un control según su tipo.
func _escribir_control(control: Node, valor: Variant) -> void:
	if control is OptionButton:
		control.select(valor)
	elif control is Range:
		control.value = valor
	elif control is BaseButton:
		control.button_pressed = valor

# Pasa el valor del slider (0 a 100) a decibelios en su bus.
func _cambiar_volumen(valor: float, bus: String) -> void:
	var indice := AudioServer.get_bus_index(bus)
	# Si el bus aún no está creado en la pestaña Audio, no hace nada.
	if indice == -1:
		return
	AudioServer.set_bus_volume_db(indice, linear_to_db(maxf(valor / 100.0, 0.0001)))

# Silencia o devuelve el sonido de todo el juego (bus Master).
func _silenciar(activado: bool) -> void:
	AudioServer.set_bus_mute(0, activado)

# Guarda todos los ajustes y aplica los de pantalla.
func _aplicar() -> void:
	for nombre in CONTROLES:
		var control := _buscar_nodo(nombre)
		if control != null:
			ajustes.set_value(CONTROLES[nombre][0], CONTROLES[nombre][1], _leer_control(control))
	var resultado := ajustes.save(RUTA_AJUSTES)
	if resultado != OK:
		push_error("No se pudieron guardar los ajustes.")

	# Pantalla completa.
	var pantalla_completa := ajustes.get_value("pantalla", "pantalla_completa", false) as bool
	if pantalla_completa:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	# Idioma.
	var idioma := ajustes.get_value("general", "idioma", 0) as int
	TranslationServer.set_locale(IDIOMAS[idioma])

# Vuelve al menú sin guardar lo que no se haya aplicado.
func _volver_al_menu() -> void:
	# Devolver los controles a lo guardado; así el volumen también vuelve a como estaba.
	_cargar_en_controles()
	var resultado := get_tree().change_scene_to_file("res://escenas/inicio.scn")
	if resultado != OK:
		push_error("No se pudo volver al menú.")
