extends Control

# Botón de la barra inferior de la pantalla de cargar partida
@onready var boton_volver: Button = $CanvasLayer/ContenedorPrincipal/BarraInferior/BotonVolver

func _ready() -> void:
	# Conectar el botón para que responda al hacer clic
	boton_volver.pressed.connect(_volver_al_menu)

# Vuelve al menú principal
func _volver_al_menu() -> void:
	get_tree().change_scene_to_file("res://escenas/inicio.scn")
