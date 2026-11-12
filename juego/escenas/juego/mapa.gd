class_name Mapa
extends RefCounted

# Paradas del mapa 3D y cómo se conectan.
# Movimiento lineal: ← → recorre la línea; ↑ ↓ usa el ascensor de Zaun.
# Piltover está arriba; el Puente lleva a la Promenade de Zaun.

const LINEAS := {
	"Piltover": ["Hexpuertas", "Academia", "Consejo", "Plaza", "Taller", "Kiramman", "Puente", "AscensorPromenade"],
	"Promenade": ["AscensorPromenade", "UltimaGota", "Mercado", "TiendaBenzo"],
	"Entresuelo": ["AscensorEntresuelo", "Fabricas", "Luciernagas"],
	"Sumidero": ["AscensorSumidero", "LabSinged", "EsconditeJinx"],
}

const ASCENSOR := ["AscensorPromenade", "AscensorEntresuelo", "AscensorSumidero"]

# Ruta del Marker3D de cada parada dentro de mapa_3d.tscn.
const NODOS := {
	"Hexpuertas": "Rutas/Piltover/Hexpuertas", "Academia": "Rutas/Piltover/Academia",
	"Consejo": "Rutas/Piltover/Consejo", "Plaza": "Rutas/Piltover/Plaza",
	"Taller": "Rutas/Piltover/Taller", "Kiramman": "Rutas/Piltover/Kiramman",
	"Puente": "Rutas/Piltover/Puente",
	"UltimaGota": "Rutas/Zaun/Promenade/UltimaGota", "Mercado": "Rutas/Zaun/Promenade/Mercado",
	"TiendaBenzo": "Rutas/Zaun/Promenade/TiendaBenzo",
	"Fabricas": "Rutas/Zaun/Entresuelo/Fabricas", "Luciernagas": "Rutas/Zaun/Entresuelo/Luciernagas",
	"LabSinged": "Rutas/Zaun/Sumidero/LabSinged", "EsconditeJinx": "Rutas/Zaun/Sumidero/EsconditeJinx",
	"AscensorPromenade": "Rutas/Ascensor/Promenade", "AscensorEntresuelo": "Rutas/Ascensor/Entresuelo",
	"AscensorSumidero": "Rutas/Ascensor/Sumidero",
}

const NOMBRES := {
	"Hexpuertas": "Las Hexpuertas", "Academia": "La Academia", "Consejo": "La Sala del Consejo",
	"Plaza": "La Plaza", "Taller": "El taller de Jayce", "Kiramman": "Mansión Kiramman",
	"Puente": "El Puente del Progreso", "UltimaGota": "La Última Gota", "Mercado": "El Mercado",
	"TiendaBenzo": "La tienda de Benzo", "Fabricas": "Las Fábricas", "Luciernagas": "El árbol de las Luciérnagas",
	"LabSinged": "Laboratorio de Singed", "EsconditeJinx": "Escondite de Jinx",
	"AscensorPromenade": "Ascensor · Promenade", "AscensorEntresuelo": "Ascensor · Entresuelo",
	"AscensorSumidero": "Ascensor · Sumidero",
}

# Línea en la que está una parada (la primera que la contiene).
static func linea_de(parada: String) -> String:
	for l in LINEAS:
		if parada in LINEAS[l]:
			return l
	return "Piltover"

# Parada vecina en la dirección indicada (-1 izquierda, 1 derecha).
# Desde el ascensor de la Promenade se puede seguir hacia Piltover o hacia Zaun.
static func vecina(parada: String, direccion: int, linea_preferida: String = "") -> String:
	var linea := linea_preferida if linea_preferida != "" and parada in LINEAS.get(linea_preferida, []) else linea_de(parada)
	var lista: Array = LINEAS[linea]
	var i := lista.find(parada)
	var j := i + direccion
	if j >= 0 and j < lista.size():
		return lista[j]
	# En el ascensor de la Promenade, al ir a la izquierda pasamos a la línea de Piltover y viceversa.
	if parada == "AscensorPromenade":
		var otra := "Promenade" if linea == "Piltover" else "Piltover"
		var lista2: Array = LINEAS[otra]
		var k := lista2.find(parada) + direccion
		if k >= 0 and k < lista2.size():
			return lista2[k]
	return parada

# Parada del ascensor de arriba (-1) o de abajo (1).
static func ascensor(parada: String, direccion: int) -> String:
	var i := ASCENSOR.find(parada)
	if i == -1:
		return parada
	return ASCENSOR[clampi(i + direccion, 0, ASCENSOR.size() - 1)]

static func es_ascensor(parada: String) -> bool:
	return parada in ASCENSOR

static func nombre(parada: String) -> String:
	return NOMBRES.get(parada, parada)

static func es_piltover(parada: String) -> bool:
	return linea_de(parada) == "Piltover" and not es_ascensor(parada)
