class_name Historia
extends RefCounted

# La historia es la de Nina: DATOS/story.js (+ story-expansion.js y alternate-fates.js),
# convertida a datos/historia.json con datos/convertir_historia.js.
# Parte 1: la ruta de tu ciudad (Zaun o Piltover). Parte 2: la misma para las dos.
# Aquí solo se lee: no se escribe historia nueva.

const Opciones := preload("res://escenas/opciones_creacion.gd")
const RUTA := "res://escenas/juego/datos/historia.json"

const NOMBRES := {
	"vi": "Vi", "jinx": "Jinx", "vander": "Vander", "silco": "Silco", "jayce": "Jayce",
	"viktor": "Viktor", "caitlyn": "Caitlyn", "mel": "Mel", "heimerdinger": "Heimerdinger",
	"ekko": "Ekko", "sevika": "Sevika", "singed": "Singed", "benzo": "Benzo", "ambessa": "Ambessa",
	"cassandra": "Cassandra", "marcus": "Marcus", "finn": "Finn", "salo": "Salo", "shoola": "Shoola",
	"maddie": "Maddie", "isha": "Isha", "kino": "Kino", "narrador": "",
}

# Quién es tu familia según el vínculo elegido al crear el personaje (relations.js · familyLinks).
const FAMILIA := {
	"vander": ["vander", "vi", "jinx"], "silco": ["silco", "jinx"], "prima_vi": ["vi", "jinx"],
	"primo_ekko": ["ekko"], "viktor": ["viktor"], "sevika": ["sevika"], "benzo": ["benzo"],
	"singed": ["singed"], "finn": ["finn"], "jayce": ["jayce"], "mel": ["mel"],
	"primo_caitlyn": ["caitlyn", "cassandra"], "heimerdinger": ["heimerdinger"],
	"ambessa": ["ambessa"], "maddie": ["maddie"], "salo": ["salo"], "shoola": ["shoola"], "marcus": ["marcus"],
}

# En qué parada del mapa 3D pasa cada escena (por su fondo).
const PARADA := {
	"ultima-gota": "UltimaGota", "foso": "UltimaGota", "callejones": "Mercado", "zaun": "Mercado",
	"tejados": "Fabricas", "fabrica": "Fabricas", "arbol": "Luciernagas", "sumidero": "LabSinged",
	"escondite-jinx": "EsconditeJinx", "puente": "Puente", "puente-zaun": "Puente",
	"taller-jayce": "Taller", "hexcore": "Taller", "academia": "Academia", "mansion-kiramman": "Kiramman",
	"consejo": "Consejo", "piltover": "Plaza", "ejecutores": "Plaza", "stillwater": "Hexpuertas",
	"hexpuertas": "Hexpuertas",
}

# Imagen de cada fondo en la Parte 1 y en la Parte 2 (assets/lugares).
const IMAGEN := {
	"ultima-gota": ["s1/ultima-gota.webp", "s1/zaun-ultima-gota-bar.jpg"],
	"foso": ["s1/zaun-ultima-gota-bar.jpg", "s1/zaun-ultima-gota-bar.jpg"],
	"callejones": ["s1/zaun-centro.jpg", "s2/callejones.webp"],
	"zaun": ["s1/zaun.webp", "s2/callejones.webp"],
	"tejados": ["s1/tejados.webp", "s2/tejados.webp"],
	"fabrica": ["s1/fabrica.webp", "s2/zaun-fisuras-superiores.jpg"],
	"arbol": ["s1/arbol.webp", "s2/zaun-comuna-viktor.jpg"],
	"sumidero": ["s1/sumidero.webp", "s2/zaun-singed-laboratorio.png"],
	"escondite-jinx": ["s1/zaun-ciudad-subterranea.jpg", "s2/escondite-jinx.webp"],
	"puente": ["s1/puente.webp", "s1/puente.webp"],
	"puente-zaun": ["s1/puente-zaun.webp", "s2/puente-zaun.webp"],
	"taller-jayce": ["s1/taller-jayce.webp", "s2/taller-jayce.webp"],
	"hexcore": ["s1/taller-jayce.webp", "s2/taller-jayce.webp"],
	"academia": ["s1/piltover.webp", "s2/piltover.webp"],
	"mansion-kiramman": ["s1/artesanos.webp", "s2/mansion-kiramman.webp"],
	"consejo": ["s1/plaza.webp", "s2/consejo.webp"],
	"piltover": ["s1/piltover.webp", "s2/piltover.webp"],
	"ejecutores": ["s1/zaun-punto-seguridad.jpg", "s1/zaun-punto-seguridad.jpg"],
	"stillwater": ["s1/stillwater.webp", "s2/stillwater.webp"],
	"hexpuertas": ["s1/hexpuertas.webp", "s2/hexpuertas.webp"],
}

static var _datos: Dictionary = {}

static func datos() -> Dictionary:
	if _datos.is_empty():
		var f := FileAccess.open(RUTA, FileAccess.READ)
		if f:
			var d = JSON.parse_string(f.get_as_text())
			if d is Dictionary:
				_datos = d
	return _datos

# Lista de capítulos (ids) de una parte.
static func ruta(parte: int) -> Array:
	var r: Dictionary = datos().get("rutas", {})
	if parte >= 2:
		return r.get("parte2", [])
	return r.get("piltover" if DatosPartida.ciudad_elegida == "Piltover" else "zaun", [])

static func capitulos_en_parte(parte: int) -> int:
	return ruta(parte).size()

# Capítulo por parte y número (1..n). Añade lugar y personaje para el mapa.
static func capitulo_de(parte: int, numero: int) -> Dictionary:
	var ids := ruta(parte)
	if ids.is_empty():
		return {"titulo": "", "lugar": "Puente", "personaje": "narrador", "nodos": {}}
	var id: String = ids[clampi(numero, 1, ids.size()) - 1]
	var c: Dictionary = datos()["capitulos"][id].duplicate()
	c["id"] = id
	var primero: Dictionary = c["nodos"].get(c.get("inicio", "a"), {})
	c["lugar"] = PARADA.get(str(primero.get("bg", "puente")), "Puente")
	c["personaje"] = "narrador"
	for l in primero.get("lines", []):
		if not l["s"] in ["narrador", "yo"]:
			c["personaje"] = l["s"]
			break
	return c

static func capitulo_actual() -> Dictionary:
	return capitulo_de(Progreso.parte, Progreso.capitulo)

static func nombre(id: String) -> String:
	if id == "yo":
		return DatosPartida.nombre_personaje
	return NOMBRES.get(id, id.capitalize())

static func imagen(bg: String, parte: int) -> String:
	var op: Array = IMAGEN.get(bg, ["s1/puente.webp", "s2/puente-zaun.webp"])
	return "res://assets/lugares/" + op[clampi(parte, 1, 2) - 1]

# Para el mapa: fondo de una parada.
static func fondo(lugar: String, parte: int) -> String:
	for bg in PARADA:
		if PARADA[bg] == lugar:
			return imagen(bg, parte)
	return imagen("puente", parte)

# ---------- Textos ----------

static func _texto_opcion(lista: Array, id: String) -> String:
	for o in lista:
		if o.get("id", "") == id:
			return str(o.get("texto", id))
	return id

static func formatear(texto: String) -> String:
	var ciudad := Opciones.de_ciudad(DatosPartida.ciudad_elegida)
	var familia := _texto_opcion(ciudad.get("familias", []), DatosPartida.familia)
	var aficion := ""
	if not DatosPartida.aficiones.is_empty():
		aficion = _texto_opcion(Opciones.AFICIONES, DatosPartida.aficiones[0]).to_lower()
	var t := texto.replace("{name}", DatosPartida.nombre_personaje)
	t = t.replace("{job}", _texto_opcion(ciudad.get("ocupaciones", []), DatosPartida.ocupacion).to_lower())
	t = t.replace("{district}", _texto_opcion(ciudad.get("distritos", []), DatosPartida.distrito))
	t = t.replace("{family}", familia.to_lower())
	t = t.replace("{hobby}", aficion)
	# {g:masculino|femenino|neutro}
	var g := 0 if DatosPartida.genero == "hombre" else (1 if DatosPartida.genero == "mujer" else 2)
	var re := RegEx.create_from_string("\\{g:([^}]*)\\}")
	for m in re.search_all(t):
		var formas := m.get_string(1).split("|")
		t = t.replace(m.get_string(0), formas[mini(g, formas.size() - 1)])
	return t

# ---------- Condiciones ----------

static func es_familia(id: String) -> bool:
	return id in FAMILIA.get(DatosPartida.familia, [])

# cond de las líneas y req de las respuestas (mismo formato que story.js).
static func cumple(c: Dictionary) -> bool:
	if c.is_empty():
		return true
	if c.has("flag") and not Progreso.flags.has(c["flag"]):
		return false
	if c.has("notFlag") and Progreso.flags.has(c["notFlag"]):
		return false
	if c.has("met") and not c["met"] in Progreso.conocidos:
		return false
	if c.has("notMet") and c["notMet"] in Progreso.conocidos:
		return false
	if c.has("kin") and not es_familia(c["kin"]):
		return false
	if c.has("notKin") and es_familia(c["notKin"]):
		return false
	if c.has("origin") and DatosPartida.ciudad_elegida.to_lower() != c["origin"]:
		return false
	if c.has("stat") and int(DatosPartida.estadisticas.get(c["stat"], 0)) < int(c.get("min", 0)):
		return false
	if c.has("aff") and Progreso.afinidad(c["aff"][0]) < int(c["aff"][1]):
		return false
	return true

# Aplica fx: { aff, rep, stats, flags }.
static func aplicar(fx: Dictionary) -> void:
	for p in fx.get("aff", {}):
		Progreso.cambiar_afinidad(p, int(fx["aff"][p]))
	for lado in fx.get("rep", {}):
		Progreso.rep[lado] = int(Progreso.rep.get(lado, 0)) + int(fx["rep"][lado])
	for s in fx.get("stats", {}):
		DatosPartida.estadisticas[s] = int(DatosPartida.estadisticas.get(s, 0)) + int(fx["stats"][s])
	for f in fx.get("flags", []):
		Progreso.flags[f] = true

# ---------- Finales ----------

static func _prueba(p: Dictionary) -> bool:
	if p.has("flag") and not Progreso.flags.has(p["flag"]):
		return false
	if p.has("notFlag") and Progreso.flags.has(p["notFlag"]):
		return false
	if p.has("alguna"):
		var alguna := false
		for f in p["alguna"]:
			if Progreso.flags.has(f):
				alguna = true
		if not alguna:
			return false
	for lado in p.get("rep", {}):
		if int(Progreso.rep.get(lado, 0)) < int(p["rep"][lado]):
			return false
	if p.has("o"):
		var vale := false
		for sub in p["o"]:
			if _prueba(sub):
				vale = true
		if not vale:
			return false
	return true

# El primer final cuya condición se cumple ("finales" = Parte 1, "finales2" = Parte 2).
static func elegir_final(grupo: String) -> Dictionary:
	for f in datos().get(grupo, []):
		if _prueba(f.get("prueba", {})):
			return f
	return {}
