// Convierte la historia de Nina (DATOS/story.js + story-expansion.js + alternate-fates.js) a JSON para Godot.
// Cambios: sin capítulos de infancia (z1, z2, p1, p2), títulos sin «T1/T2/temporada/episodio»,
// el brillo nunca es verde, y las condiciones de los finales pasan a datos.
const D='C:/Users/Nina/Documents/TFG/DATOS-IMG/DATOS/';
global.window={};require(D+'story.js');require(D+'story-expansion.js');require(D+'alternate-fates.js');
const S=window.STORY;
const QUITAR=['z1','z2','p1','p2'];
const limpiar=t=>t.replace(/^T\d · (Final de temporada · )?(Acto [IVX]+ · [^·]+ · )?(Episodio \d+\/\d+ · )?/,'').replace(/^Parte [IVX]+ · /,'').replace(/^Capítulo (\d+|final) · /,'');
const verde=t=>t.replace(/luces son verdes/g,'luces son violetas').replace(/luces verdes/g,'luces violetas').replace(/niebla verde/g,'niebla violeta');
const caps={};
for(const c of S.chapters){ if(QUITAR.includes(c.id)) continue;
  caps[c.id]={titulo:limpiar(c.title),intro:verde(c.intro||''),conoce:c.unlocks||[],inicio:c.start,nodos:JSON.parse(verde(JSON.stringify(c.nodes)))}; }
const sinQ=a=>a.filter(x=>!QUITAR.includes(x));
// Condiciones de los finales (en story.js eran funciones).
const PRUEBAS={
 t2_segunda_oportunidad:{alguna:['salva_jinx','salva_isha','salva_jayce_viktor']},
 t2_union:{flag:'union',notFlag:'elige_evolucion'}, t2_evolucion:{flag:'elige_evolucion'}, t2_ruinas:{},
 paz:{alguna:['jinx_escucha','cohete_saboteado'],o:[{alguna:['pacto','puente_hermanas','alianza_luciernagas']},{rep:{zaun:3,piltover:1}}]},
 zaun_libre:{flag:'deja_cohete',rep:{zaun:3}}, orden:{o:[{alguna:['evacuacion']},{rep:{piltover:3}}]}, humo:{},
};
const finales=l=>l.map(e=>({id:e.id,fondo:e.scene,titulo:limpiar(e.title),prueba:PRUEBAS[e.id],lineas:JSON.parse(verde(JSON.stringify(e.lines)))}));
for(const e of [...S.endings,...S.endings2]) if(!(e.id in PRUEBAS)) throw new Error('final sin prueba '+e.id);
const out={
 rutas:{zaun:sinQ(S.routes.zaun),piltover:sinQ(S.routes.piltover),parte2:S.routes.t2},
 romance_desde:S.romanceFrom, muertes:S.deaths, rescates:S.rescues,
 capitulos:caps, finales:finales(S.endings), finales2:finales(S.endings2),
};
require('fs').writeFileSync(process.argv[2],JSON.stringify(out,null,1));
console.log(out.rutas, Object.values(caps).map(c=>c.titulo).join(' | '));

// Después de generar historia.json, aplica el tono reescrito: node aplicar_reescritura.js
