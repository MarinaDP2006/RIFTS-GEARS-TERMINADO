extends Node

# Guarda y carga partidas en dos ranuras (user://partida_1.json y partida_2.json).

const RANURAS := 2
const CAMPOS_PERSONAJE := [
	"ciudad_elegida", "nombre_personaje", "genero", "edad", "tipo_avatar", "numero_avatar",
	"padres", "familia", "atraccion", "distrito", "ocupacion", "rasgos", "aficiones",
	"estadisticas", "afinidades", "personaje_creado",
]

func ruta(ranura: int) -> String:
	return "user://partida_%d.json" % ranura

func existe(ranura: int) -> bool:
	return FileAccess.file_exists(ruta(ranura))

# Guarda la partida actual. Si no hay ranura elegida usa la primera libre (o la 1).
func guardar(ranura: int = 0) -> bool:
	if ranura <= 0:
		ranura = Progreso.ranura if Progreso.ranura > 0 else primera_libre()
	Progreso.ranura = ranura
	var personaje := {}
	for campo in CAMPOS_PERSONAJE:
		personaje[campo] = DatosPartida.get(campo)
	var datos := {
		"personaje": personaje,
		"progreso": Progreso.a_diccionario(),
		"fecha": Time.get_datetime_string_from_system(false, true),
		"unix": Time.get_unix_time_from_system(),
	}
	var f := FileAccess.open(ruta(ranura), FileAccess.WRITE)
	if f == null:
		push_error("No se pudo guardar la partida en la ranura %d." % ranura)
		return false
	f.store_string(JSON.stringify(datos, "\t"))
	return true

# Lee el contenido de una ranura sin cargarla (para la pantalla de cargar).
func leer(ranura: int) -> Dictionary:
	if not existe(ranura):
		return {}
	var f := FileAccess.open(ruta(ranura), FileAccess.READ)
	if f == null:
		return {}
	var datos = JSON.parse_string(f.get_as_text())
	return datos if datos is Dictionary else {}

# Carga una ranura en DatosPartida y Progreso.
func cargar(ranura: int) -> bool:
	var datos := leer(ranura)
	if datos.is_empty():
		return false
	var personaje: Dictionary = datos.get("personaje", {})
	for campo in CAMPOS_PERSONAJE:
		if personaje.has(campo):
			var valor = personaje[campo]
			if campo in ["edad", "numero_avatar"]:
				valor = int(valor)
			elif campo in ["rasgos", "aficiones"]:
				var lista: Array[String] = []
				for v in valor:
					lista.append(str(v))
				valor = lista
			DatosPartida.set(campo, valor)
	Progreso.desde_diccionario(datos.get("progreso", {}))
	Progreso.ranura = ranura
	return true

func borrar(ranura: int) -> void:
	if existe(ranura):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(ruta(ranura)))

func primera_libre() -> int:
	for i in range(1, RANURAS + 1):
		if not existe(i):
			return i
	return 1

# Ranura guardada más reciente (0 si no hay ninguna).
func mas_reciente() -> int:
	var mejor := 0
	var mejor_fecha := -1.0
	for i in range(1, RANURAS + 1):
		var d := leer(i)
		if not d.is_empty() and float(d.get("unix", 0)) > mejor_fecha:
			mejor_fecha = float(d.get("unix", 0))
			mejor = i
	return mejor
