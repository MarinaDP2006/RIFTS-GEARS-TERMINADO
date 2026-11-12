extends Node

# Guarda la ciudad elegida para la partida.
var ciudad_elegida: String = ""
# Guarda el nombre del personaje.
var nombre_personaje: String = ""
# Guarda el género con el que se escriben los textos.
var genero: String = "hombre"
# Guarda la edad del personaje.
var edad: int = 20
# Guarda el tipo de avatar elegido.
var tipo_avatar: String = "hombre"
# Guarda el número del avatar elegido.
var numero_avatar: int = 1
# Guardan lo elegido en los apartados 2 a 6 (identificadores de opciones_creacion.gd).
var padres: String = ""
var familia: String = ""
var atraccion: String = ""
var distrito: String = ""
var ocupacion: String = ""
var rasgos: Array[String] = []
var aficiones: Array[String] = []
# Guardan los puntos de cada estadística y la afinidad inicial con los personajes.
var estadisticas: Dictionary = {}
var afinidades: Dictionary = {}
# Indica si el personaje ya está terminado.
var personaje_creado: bool = false

# Borra lo elegido en la creación para empezarla de nuevo.
func reiniciar_creacion() -> void:
	nombre_personaje = ""
	genero = "hombre"
	edad = 20
	tipo_avatar = "hombre"
	numero_avatar = 1
	padres = ""
	familia = ""
	atraccion = ""
	distrito = ""
	ocupacion = ""
	rasgos = []
	aficiones = []
	estadisticas = {}
	afinidades = {}
	personaje_creado = false
