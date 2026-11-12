extends Control

# Pantalla de cargar partida: rellena las dos ranuras diseñadas en cargar_partida.tscn
# con las partidas guardadas, y permite cargar, borrar, empezar o importar una.

const RANURAS := 2

@onready var boton_volver: Button = $CanvasLayer/ContenedorPrincipal/BarraInferior/BotonVolver
@onready var boton_importar: Button = $CanvasLayer/ContenedorPrincipal/BarraInferior/BotonImportarPartida

var ranura_importar := 1
var dialogo: FileDialog

func _ready() -> void:
	boton_volver.pressed.connect(_volver_al_menu)
	boton_importar.pressed.connect(_importar.bind(0))
	for i in range(1, RANURAS + 1):
		_rellenar(i)

func _n(nombre: String) -> Node:
	return find_child(nombre, true, false)

func _rellenar(i: int) -> void:
	var datos := Guardado.leer(i)
	var lleno := not datos.is_empty()
	var vacio := _n("EstadoVacio%d" % i)
	var lleno_nodo := _n("DatosPartida%d" % i)
	if vacio:
		vacio.visible = not lleno
	if lleno_nodo:
		lleno_nodo.visible = lleno
	var nueva := _n("BotonNuevaPartida%d" % i) as Button
	if nueva and not nueva.pressed.is_connected(_nueva_partida):
		nueva.pressed.connect(_nueva_partida.bind(i))
	var imp := _n("BotonImportar%d" % i) as Button
	if imp and not imp.pressed.is_connected(_importar):
		imp.pressed.connect(_importar.bind(i))
	if not lleno:
		_texto("EtiquetaCiudadFija%d" % i, "RANURA %d" % i)
		return
	var p: Dictionary = datos.get("personaje", {})
	var g: Dictionary = datos.get("progreso", {})
	var ciudad := str(p.get("ciudad_elegida", ""))
	_texto("EtiquetaCiudadFija%d" % i, ciudad.to_upper())
	_texto("Personaje%d" % i, str(p.get("nombre_personaje", "Sin nombre")))
	_texto("ChipCiudad%d" % i, ciudad)
	_texto("ChipGuardado%d" % i, "Ranura %d" % i)
	var parte := int(g.get("parte", 1))
	var cap := int(g.get("capitulo", 1))
	var titulo: String = _titulo(p, parte, cap)
	_texto("Progreso%d" % i, "Parte %d · Capítulo %d — %s" % [parte, cap, titulo])
	_texto("Ciudad%d" % i, "%s · %s años" % [str(p.get("ocupacion", "")).capitalize(), str(p.get("edad", ""))])
	_texto("Capitulos%d" % i, "Capítulo %d / %d" % [cap, _total(p, parte)])
	var barra := _n("BarraParte%d" % i) as ProgressBar
	if barra:
		barra.max_value = _total(p, parte)
		barra.value = cap
	var stats: Dictionary = p.get("estadisticas", {})
	for s in ["Ingenio", "Carisma", "Valor", "Sigilo"]:
		var b := _n("Barra%s%d" % [s, i]) as ProgressBar
		if b:
			b.value = float(stats.get(s.to_lower(), 0))
	_texto("TiempoJugado%d" % i, Progreso.tiempo_texto(float(g.get("tiempo_jugado", 0))))
	_texto("Fecha%d" % i, str(datos.get("fecha", "")).replace("T", " ").left(16))
	var emblema := _n("Emblema%d" % i) as TextureRect
	if emblema:
		var r := "res://assets/simbolos/%s.png" % ciudad.to_lower()
		if ResourceLoader.exists(r):
			emblema.texture = load(r)
	var avatar := _n("Avatar%d" % i) as TextureRect
	if avatar:
		var ra := "res://assets/avatares/%s-%d.webp" % [str(p.get("tipo_avatar", "hombre")), int(p.get("numero_avatar", 1))]
		if ResourceLoader.exists(ra):
			avatar.texture = load(ra)
	# Las tres personas con más afinidad.
	var af: Dictionary = p.get("afinidades", {})
	var claves := af.keys()
	claves.sort_custom(func(a, b): return int(af[a]) > int(af[b]))
	for k in 3:
		var v := _n("Vinculo%d_%d" % [i, k + 1]) as TextureRect
		if v:
			v.texture = null
			if k < claves.size():
				var rr := Estilo.retrato(str(claves[k]))
				if rr != "":
					v.texture = load(rr)
					v.tooltip_text = "%s (%d)" % [Historia.nombre(str(claves[k])), int(af[claves[k]])]
	# Botones para cargar y borrar.
	var info := _n("Info%d" % i) as VBoxContainer
	if info and info.get_node_or_null("Acciones") == null:
		var fila := HBoxContainer.new()
		fila.name = "Acciones"
		fila.add_theme_constant_override("separation", 10)
		info.add_child(fila)
		var cargar := Estilo.boton("Cargar partida", 200, true)
		cargar.pressed.connect(_cargar.bind(i))
		fila.add_child(cargar)
		var borrar := Estilo.boton("Borrar", 120)
		borrar.pressed.connect(_borrar.bind(i))
		fila.add_child(borrar)

func _texto(nodo: String, valor: String) -> void:
	var l := _n(nodo) as Label
	if l:
		l.text = valor

func _cargar(i: int) -> void:
	if not Guardado.cargar(i):
		return
	var destino := "res://escenas/juego/juego.tscn" if Progreso.prologo_visto else "res://escenas/juego/prologo.tscn"
	get_tree().change_scene_to_file(destino)

func _borrar(i: int) -> void:
	var confirmar := ConfirmationDialog.new()
	confirmar.title = "Borrar partida"
	confirmar.dialog_text = "¿Seguro que quieres borrar la partida de la ranura %d? No se puede deshacer." % i
	confirmar.ok_button_text = "Borrar"
	confirmar.cancel_button_text = "Cancelar"
	add_child(confirmar)
	confirmar.confirmed.connect(func():
		Guardado.borrar(i)
		var info := _n("Info%d" % i)
		if info and info.get_node_or_null("Acciones"):
			info.get_node("Acciones").queue_free()
		_rellenar(i))
	confirmar.popup_centered()

func _nueva_partida(i: int) -> void:
	Progreso.reiniciar()
	Progreso.ranura = i
	DatosPartida.reiniciar_creacion()
	get_tree().change_scene_to_file("res://escenas/nueva_partida.tscn")

# Importa un archivo .json de partida a una ranura (0 = la primera libre).
func _importar(i: int) -> void:
	ranura_importar = i if i > 0 else Guardado.primera_libre()
	if dialogo == null:
		dialogo = FileDialog.new()
		dialogo.file_mode = FileDialog.FILE_MODE_OPEN_FILE
		dialogo.access = FileDialog.ACCESS_FILESYSTEM
		dialogo.filters = PackedStringArray(["*.json ; Partida de Rifts & Gears"])
		dialogo.title = "Importar partida"
		dialogo.file_selected.connect(_archivo_elegido)
		add_child(dialogo)
	dialogo.popup_centered(Vector2i(800, 500))

func _archivo_elegido(ruta: String) -> void:
	var f := FileAccess.open(ruta, FileAccess.READ)
	if f == null:
		return
	var datos = JSON.parse_string(f.get_as_text())
	if not (datos is Dictionary and datos.has("personaje")):
		push_warning("El archivo no es una partida válida.")
		return
	var salida := FileAccess.open(Guardado.ruta(ranura_importar), FileAccess.WRITE)
	salida.store_string(JSON.stringify(datos, "\t"))
	salida.close()
	_rellenar(ranura_importar)

func _volver_al_menu() -> void:
	get_tree().change_scene_to_file("res://escenas/inicio.scn")

# La ruta depende de la ciudad de esa partida, no de la que esté cargada ahora.
func _titulo(p: Dictionary, parte: int, cap: int) -> String:
	var antes := DatosPartida.ciudad_elegida
	DatosPartida.ciudad_elegida = str(p.get("ciudad_elegida", ""))
	var t: String = Historia.capitulo_de(parte, cap).get("titulo", "")
	DatosPartida.ciudad_elegida = antes
	return t

func _total(p: Dictionary, parte: int) -> int:
	var antes := DatosPartida.ciudad_elegida
	DatosPartida.ciudad_elegida = str(p.get("ciudad_elegida", ""))
	var n := Historia.capitulos_en_parte(parte)
	DatosPartida.ciudad_elegida = antes
	return n
