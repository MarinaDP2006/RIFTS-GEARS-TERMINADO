// Aplica reescritura_tono.tsv (ruta<TAB>texto) sobre historia.json sin tocar la estructura:
// mismos capítulos, nodos, elecciones, condiciones y efectos; solo cambia el texto.
const fs = require("fs");
const h = JSON.parse(fs.readFileSync(__dirname + "/historia.json", "utf8"));
const lineas = fs.readFileSync(__dirname + "/reescritura_tono.tsv", "utf8").split(/\r?\n/).filter(Boolean);
const valido = /\{(name|job|district|family|hobby|g:[^|{}]*\|[^|{}]*\|[^|{}]*)\}/g;
let cambiados = 0, errores = 0;
for (const l of lineas) {
	const i = l.indexOf("\t");
	const ruta = l.slice(0, i).split(".");
	const texto = l.slice(i + 1);
	let o = h;
	for (let k = 0; k < ruta.length - 1; k++) o = o == null ? undefined : o[ruta[k]];
	const ultima = ruta[ruta.length - 1];
	if (o == null || typeof o[ultima] !== "string") { console.log("NO EXISTE:", ruta.join(".")); errores++; continue; }
	const resto = texto.replace(valido, "");
	if (/[{}]/.test(resto)) { console.log("MARCADOR MAL:", ruta.join("."), texto); errores++; continue; }
	if (o[ultima] !== texto) { o[ultima] = texto; cambiados++; }
}
fs.writeFileSync(__dirname + "/historia.json", JSON.stringify(h));
console.log("líneas:", lineas.length, "cambiadas:", cambiados, "errores:", errores);
