extends Control

# Hace funcionar el Códice que diseñó Nina (escenas/codice.tscn) sin cambiar la escena:
# se le pone este script al abrirlo desde la pausa.
# - Los botones de la izquierda cambian de apartado.
# - TU HISTORIA enseña tu personaje de verdad.
# - PERSONAJES, PILTOVER, ZAUN y TECNOLOGÍA se rellenan con la enciclopedia (datos/wiki.json).
# - CULTURA y CRONOLOGÍA se quedan con los textos de la escena.
# - VOLVER cierra el Códice y MAPA pide abrir el mapa.

signal cerrado
signal mapa_pedido

const RUTA_WIKI := "res://escenas/juego/datos/wiki.json"
const QUITAR := ["kino"]

const APARTADOS := {
	"BotonTuHistoria": "ContenidoTuHistoria",
	"BotonPersonajes": "ContenidoPersonajes",
	"BotonPiltover": "ContenidoMundo",
	"BotonZaun": "ContenidoMundo",
	"BotonTecnologia": "ContenidoTecnologia",
	"BotonCultura": "ContenidoCultura",
	"BotonCronologia": "ContenidoCronologia",
}

var wiki: Dictionary = {}
var lista_mundo: Array = []

func _n(nombre: String, desde: Node = self) -> Node:
	return desde.find_child(nombre, true, false)

func _ready() -> void:
	var f := FileAccess.open(RUTA_WIKI, FileAccess.READ)
	if f:
		var d = JSON.parse_string(f.get_as_text())
		if d is Dictionary:
			wiki = d
	for boton in APARTADOS:
		var b := _n(boton) as Button
		if b:
			b.pressed.connect(_mostrar.bind(boton))
	var volver := _n("BotonVolver") as Button
	if volver:
		volver.pressed.connect(_cerrar)
	var mapa := _n("BotonMapa") as Button
	if mapa:
		mapa.pressed.connect(func(): mapa_pedido.emit())
	_rellenar_tu_historia()
	_preparar_lista(_n("ContenidoPersonajes"), _personajes())
	_preparar_lista(_n("ContenidoTecnologia"), _filtrar("tecnologia", ""))
	_mostrar("BotonTuHistoria")

func _unhandled_input(evento: InputEvent) -> void:
	if evento.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_cerrar()

func _cerrar() -> void:
	cerrado.emit()
	queue_free()

func _mostrar(boton: String) -> void:
	var destino: String = APARTADOS[boton]
	var panel := _n("PanelContenido")
	for hijo in panel.get_children():
		if hijo is Control:
			hijo.visible = hijo.name == destino
	if destino == "ContenidoMundo":
		var ciudad := "piltover" if boton == "BotonPiltover" else "zaun"
		var cont := _n("ContenidoMundo")
		var titulo := _n("TituloSeccion", cont) as Label
		if titulo:
			titulo.text = ciudad.to_upper()
		_preparar_lista(cont, _filtrar("lugares", ciudad))

# ---------- Tu historia ----------

func _rellenar_tu_historia() -> void:
	var cont := _n("ContenidoTuHistoria")
	var retrato := _n("Retrato", cont) as TextureRect
	var ruta := "res://assets/avatares/%s-%d.webp" % [DatosPartida.tipo_avatar, DatosPartida.numero_avatar]
	if retrato and ResourceLoader.exists(ruta):
		retrato.texture = load(ruta)
	for s in ["Ingenio", "Carisma", "Valor", "Sigilo"]:
		var barra := _n("Barra" + s, cont) as ProgressBar
		if barra:
			barra.value = float(DatosPartida.estadisticas.get(s.to_lower(), 0))
	_texto(cont, "NombrePersonaje", DatosPartida.nombre_personaje.to_upper())
	_texto(cont, "EtiquetaCiudad", DatosPartida.ciudad_elegida)
	_texto(cont, "EtiquetaDistrito", DatosPartida.distrito)
	_texto(cont, "EtiquetaOcupacion", DatosPartida.ocupacion)
	var bio := _n("Biografia", cont) as RichTextLabel
	if bio:
		# Solo lo que elegiste al crear el personaje, sin inventar nada.
		var filas := []
		filas.append("[b]Edad:[/b] %d años" % DatosPartida.edad)
		if DatosPartida.padres != "":
			filas.append("[b]Padres:[/b] %s" % DatosPartida.padres)
		if DatosPartida.familia != "":
			filas.append("[b]Familia:[/b] %s" % DatosPartida.familia)
		if not DatosPartida.rasgos.is_empty():
			filas.append("[b]Rasgos:[/b] %s" % ", ".join(DatosPartida.rasgos))
		if not DatosPartida.aficiones.is_empty():
			filas.append("[b]Aficiones:[/b] %s" % ", ".join(DatosPartida.aficiones))
		if DatosPartida.atraccion != "":
			filas.append("[b]Atracción:[/b] %s" % DatosPartida.atraccion)
		filas.append("[b]Parte %d · Capítulo %d[/b]" % [Progreso.parte, Progreso.capitulo])
		bio.text = "\n".join(filas)

func _texto(desde: Node, nombre: String, valor: String) -> void:
	var l := _n(nombre, desde) as Label
	if l:
		l.text = valor
		l.visible = valor != ""

# ---------- Enciclopedia ----------

func _personajes() -> Array:
	return (wiki.get("personajes", []) as Array).filter(func(p): return not QUITAR.has(p.get("id", "")))

func _filtrar(categoria: String, origen: String) -> Array:
	var todos: Array = wiki.get(categoria, [])
	if origen == "":
		return todos
	return todos.filter(func(e): return e.get("origin", "") == origen)

# Rellena la EntradaCodice (lista a la izquierda + ficha a la derecha) de un apartado.
func _preparar_lista(cont: Node, entradas: Array) -> void:
	if cont == null:
		return
	var entrada := _n("EntradaCodice", cont)
	if entrada == null:
		return
	var lista := _n("ListaEntradas", entrada) as ItemList
	lista.clear()
	for e in entradas:
		lista.add_item(str(e.get("name", "")))
	for c in lista.item_selected.get_connections():
		lista.item_selected.disconnect(c.callable)
	lista.item_selected.connect(func(i): _ficha(entrada, entradas[i]))
	if not entradas.is_empty():
		lista.select(0)
		_ficha(entrada, entradas[0])

func _ficha(entrada: Node, e: Dictionary) -> void:
	_texto(entrada, "Nombre", str(e.get("name", "")).to_upper())
	var origen := str(e.get("origin", ""))
	_texto(entrada, "EtiquetaCiudad", origen.capitalize())
	_texto(entrada, "EtiquetaParte", str(e.get("alias", "")))
	_texto(entrada, "EtiquetaLugar", str(e.get("role", "")))
	var rel := ""
	if e.has("relations"):
		var nombres := []
		for r in e["relations"]:
			nombres.append(_nombre(str(r)))
		rel = "Relacionado con: " + ", ".join(nombres)
	_texto(entrada, "Relacion", rel)
	var img := _n("Imagen", entrada) as TextureRect
	if img:
		var ruta := "res://assets/caras/%s.png" % str(e.get("id", ""))
		img.texture = load(ruta) if ResourceLoader.exists(ruta) else null
		img.get_parent().visible = img.texture != null
	var texto := _n("Texto", entrada) as RichTextLabel
	if texto:
		var partes := [str(e.get("summary", ""))]
		for d in e.get("details", []):
			partes.append(str(d))
		if e.get("spoiler", "") != "":
			partes.append(str(e["spoiler"]))
		if e.get("quote", "") != "":
			partes.append("[i]«%s»[/i]" % e["quote"])
		texto.text = "\n\n".join(partes)

func _nombre(id: String) -> String:
	for p in wiki.get("personajes", []):
		if p.get("id", "") == id:
			return str(p.get("name", id))
	return id.capitalize()
