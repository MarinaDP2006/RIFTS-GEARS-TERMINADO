extends Node
# Música de fondo de todo el juego (autoload "Musica").
# Menús: tema del menú. Prólogo y partida: el tema de la ciudad elegida.
# Suena por el bus "Musica", así que el control de Ajustes la sube y la baja.

const TEMA_MENU := "res://assets/music/menu-theme.mp3"
const TEMA_PILTOVER := "res://assets/music/piltover-theme.mp3"
const TEMA_ZAUN := "res://assets/music/zaun-theme.mp3"
const ESCENAS_CIUDAD := ["res://escenas/juego/prologo.tscn", "res://escenas/juego/juego.tscn"]
const FUNDIDO := 1.2

var reproductor: AudioStreamPlayer
var tema_actual := ""
var escena_actual: Node = null


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_window().title = "Rifts & Gears"
	reproductor = AudioStreamPlayer.new()
	reproductor.bus = &"Musica" if AudioServer.get_bus_index("Musica") != -1 else &"Master"
	add_child(reproductor)


func _process(_delta: float) -> void:
	var escena := get_tree().current_scene
	if escena == escena_actual:
		return
	escena_actual = escena
	if escena == null:
		return
	_poner(_tema_para(escena.scene_file_path))


func _tema_para(ruta: String) -> String:
	if ruta in ESCENAS_CIUDAD:
		return TEMA_ZAUN if DatosPartida.ciudad_elegida == "Zaun" else TEMA_PILTOVER
	return TEMA_MENU


func _poner(tema: String) -> void:
	if tema == tema_actual or not ResourceLoader.exists(tema):
		return
	tema_actual = tema
	var t := create_tween()
	if reproductor.playing:
		t.tween_property(reproductor, "volume_db", -40.0, FUNDIDO * 0.5)
	t.tween_callback(func():
		reproductor.stream = load(tema)
		reproductor.volume_db = -40.0
		reproductor.play())
	t.tween_property(reproductor, "volume_db", 0.0, FUNDIDO)
