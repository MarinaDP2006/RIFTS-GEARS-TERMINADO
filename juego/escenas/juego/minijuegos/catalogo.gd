extends RefCounted

# Lista de los 10 minijuegos y cómo crearlos.

const ORDEN := ["aerotabla", "archivo", "cartas", "consejo", "cristal", "foso", "gala", "grafiti", "mezclas", "tiro"]

const NOMBRES := {
	"aerotabla": "Aerotabla", "archivo": "El Archivo", "cartas": "Cartas", "consejo": "El Consejo",
	"cristal": "Cristal hextech", "foso": "El Foso", "gala": "Baile de gala", "grafiti": "Grafiti",
	"mezclas": "Mezclas", "tiro": "Tiro de precisión",
}

static func crear(id: String) -> Control:
	var ruta := "res://escenas/juego/minijuegos/mj_%s.gd" % id
	if not ResourceLoader.exists(ruta):
		push_warning("No existe el minijuego " + id)
		return null
	var juego: Control = (load(ruta) as GDScript).new()
	juego.id = id
	return juego
