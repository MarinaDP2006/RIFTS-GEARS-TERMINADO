# Prompt para ChatGPT · Arte de minijuegos y retratos de Rifts & Gears

Cómo usarlo:
1. Abre un chat nuevo en ChatGPT (con generación de imágenes).
2. Pega primero el **bloque A** (las reglas de estilo). ChatGPT las recordará durante todo el chat.
3. Luego pega **un bloque B** cada vez (uno por imagen). Adjunta la captura de la maqueta que se indica (está en `Juego_Godot/minijuegos_capturas/`) como referencia de composición.
4. Guarda cada imagen con el nombre que pone en «Archivo». Después la colocas en Godot en la ruta indicada.

---

## Bloque A · Reglas de estilo (pegar una sola vez)

```
Vas a crear arte para un videojuego de PC llamado «Rifts & Gears», un fan-game no comercial
inspirado en el mundo de Arcane (Piltover y Zaun). Sigue SIEMPRE estas reglas en todas las
imágenes de este chat:

ESTILO
- Pintura digital realista con pinceladas visibles, como los fondos pintados a mano de Arcane:
  luz dramática, texturas de óleo, sombras profundas, mucho detalle de materiales (latón, piedra,
  óxido, cristal, tela).
- NADA infantil: nada de dibujos animados, nada de caras redondas tipo mascota, nada de colores
  planos tipo app para niños, nada de contornos gruesos de cómic.
- Proporciones humanas reales. Personajes adultos y creíbles.
- Formato 16:9 horizontal, 1600 x 900 píxeles (o 1920 x 1080).
- SIN texto, SIN letras, SIN números, SIN logotipos, SIN marcas de agua. La interfaz la pongo yo
  en Godot encima de la imagen.
- Deja libres de detalle importante: la franja de arriba (unos 100 px, irá el título) y la franja
  de abajo (unos 120 px, irá la barra de instrucciones). Ahí solo fondo oscuro o desenfocado.

PALETAS
- Piltover: azul marino profundo (#0a1428), dorado viejo (#d9b25f), mármol crema, luz cálida de
  tarde, brillo azul hextech (#3fb6e0) en cristales y máquinas.
- Zaun: penumbra violeta y morada, niebla química de shimmer (#C24DE0), rosa neón (#ff4fa3) en
  carteles y grafitis, tuberías de cobre y metal oxidado. IMPORTANTE: el shimmer es MORADO,
  nunca verde. No uses verde tóxico.

Responde solo con la imagen. Si algo no se puede, dímelo y propón la alternativa más cercana.
```

---

## Bloque B · Una imagen cada vez

### 1. Carrera de aerotabla (Zaun) — estilo «Vector»
Referencia: `mj_aerotabla.jpg` · Archivo: `mj_aerotabla_fondo.png` · Godot: `assets/minijuegos/aerotabla/`
```
Fondo para un minijuego de carreras por los tejados, al estilo del juego de móvil «Vector»
(parkour con siluetas). Vista lateral, cámara fija de perfil, scroll horizontal.
- Cielo pálido y neblinoso de Zaun al amanecer, gris lavanda, con la silueta de Piltover muy
  lejana y desenfocada arriba.
- Tres capas de profundidad: edificios lejanos en gris claro, edificios medios en gris oscuro y
  los tejados del primer plano en NEGRO PURO (siluetas recortadas): chimeneas, depósitos de agua,
  antenas, barandillas, una tubería que cruza entre dos tejados.
- Entre los tejados, dos huecos de los que sube niebla de shimmer morada brillante.
- Sin personajes (el corredor lo pongo yo como silueta animada).
Haz además una segunda imagen aparte: una tira de 3200 x 900 con solo los tejados negros en
primer plano sobre fondo transparente (PNG), para el scroll.
```

### 2. Corredor en silueta (para aerotabla)
Archivo: `corredor_silueta.png` (transparente) · Godot: `assets/minijuegos/aerotabla/`
```
Hoja de sprites en PNG con fondo transparente: una persona joven en silueta NEGRA PURA, sin
rasgos, montada en una aerotabla (tabla flotante de Zaun con dos propulsores que brillan en
morado shimmer). 8 poses de parkour en fila, mismo tamaño cada una (256 x 256):
correr agachado, impulso, salto, vuelta en el aire, agarre de la tabla, deslizamiento por
debajo de una tubería, aterrizaje, caída. Proporciones realistas, movimiento fluido como en
«Vector». Sin texto.
```

### 3. El foso (Zaun)
Referencia: `mj_foso.jpg` · Archivo: `mj_foso_fondo.png` · Godot: `assets/minijuegos/foso/`
```
Fondo para un minijuego de pelea clandestina: el foso bajo el bar La Última Gota, en Zaun.
- Un círculo de pelea de tierra y tablones, rodeado de una jaula de hierro oxidado y gente en
  sombra apostando (solo siluetas, sin caras).
- Un único foco cenital de luz cálida que cae en el centro; el resto, penumbra morada con humo.
- Carteles rosa neón borrosos al fondo, botellas, cadenas.
- El centro del círculo vacío (ahí pongo a Sevika y al jugador).
Tono duro y realista, nada de dibujos animados.
```

### 4. Grafiti (Zaun)
Referencia: `mj_grafiti.jpg` · Archivo: `mj_grafiti_muro.png` · Godot: `assets/minijuegos/grafiti/`
```
Primer plano frontal de un muro de ladrillo viejo de los Callejones de Zaun, de noche, junto a un
puesto de ejecutores de Piltover. Ladrillo húmedo, desconchado, restos de carteles arrancados,
grafitis antiguos medio borrados en rosa y azul. A la izquierda entra el haz amarillo de un
foco de patrulla. El centro del muro limpio y plano (ahí se pinta la plantilla).
Haz también 4 plantillas aparte, en PNG blanco sobre transparente, de estilo stencil callejero:
el emblema de Zaun, un mono con dinamita, un ojo con engranaje y una calavera con trenzas.
```

### 5. Mezclas de Quimtec (Zaun)
Referencia: `mj_mezclas.jpg` · Archivo: `mj_mezclas_mesa.png` · Godot: `assets/minijuegos/mezclas/`
```
Mesa de trabajo del laboratorio de Singed en el Sumidero de Zaun, vista frontal a la altura de
los ojos. Matraces de vidrio soplado de verdad (no de dibujos), tubos de ensayo en una gradilla
de latón, un quemador, notas manchadas, jaulas al fondo en penumbra. Luz morada de shimmer que
sale de un tanque grande desenfocado. Centro de la mesa despejado (ahí van el matraz y los
viales interactivos).
```

### 6. Cartas en La Última Gota (Zaun) — cambiar poco
Referencia: `mj_cartas.jpg` · Archivo: `mj_cartas_mesa.png` · Godot: `assets/minijuegos/cartas/`
```
Mesa redonda de madera gastada en el fondo del bar La Última Gota, vista cenital inclinada.
Fichas y chapas de metal, vasos, ceniceros, luz de lámpara cálida en la mesa y bar en penumbra
morada alrededor. El centro de la mesa vacío para las cartas.
Haz también el reverso de una carta (PNG 220 x 320): papel viejo color hueso con un dibujo
grabado de engranaje y llave inglesa en cobre.
```

### 7. Calibrar el cristal (Piltover)
Referencia: `mj_cristal.jpg` · Archivo: `mj_cristal_fondo.png` · Godot: `assets/minijuegos/cristal/`
```
Taller de Jayce en Piltover de noche, visto de frente: banco de trabajo de latón y madera,
pizarras con fórmulas borrosas, herramientas colgadas. En el centro un soporte de latón vacío
con anillos concéntricos grabados con runas (sin el cristal, que lo pongo yo). Luz azul
hextech suave que viene del centro y lámparas cálidas a los lados.
```

### 8. Debate del Consejo (Piltover)
Referencia: `mj_consejo.jpg` · Archivo: `mj_consejo_sala.png` · Godot: `assets/minijuegos/consejo/`
```
La sala del Consejo de Piltover: mesa semicircular de madera noble, siete asientos altos vacíos,
ventanales altos con luz de tarde dorada, mármol y estandartes azules. Vista desde el centro de
la sala hacia la mesa. Sin personas.
```

### 9. Baile de gala, El Archivo y Tiro de precisión (Piltover) — NO cambiar el diseño
Estas tres maquetas ya están bien. Solo, si quieres, un fondo más bonito para cada una:
```
Tres fondos, uno cada vez:
a) Salón de baile de la Gala del Día del Progreso en Piltover: lámparas de araña, suelo de
   mármol, parejas desenfocadas al fondo, tonos dorado y azul marino.
b) Despacho de Caitlyn en la comisaría: tablero de corcho grande en la pared, lámpara de mesa,
   archivos, lluvia en la ventana. El corcho vacío (las pistas las pongo yo).
c) Jardines de la mansión Kiramman con dianas de tiro entre setos, luz de tarde y neblina.
```
Archivos: `mj_gala_salon.png`, `mj_archivo_despacho.png`, `mj_tiro_jardin.png`.

---

## Bloque C · Retratos que faltaban (opcional)

Ya están descargados de la wiki y puestos en el juego: **Singed, Benzo, Finn, Marcus, Salo y
Shoola** (`assets/caras/`). Si alguno no te gusta, pide esto:

```
Retrato de busto de [NOMBRE], personaje de Arcane, en el mismo estilo pintado realista de la
serie. Fondo liso oscuro ([azul marino si es de Piltover / morado si es de Zaun]), mirada a
cámara, luz lateral. Formato cuadrado 512 x 512. Sin texto.
```

---

## Recordatorio

- Los minijuegos llevan SIEMPRE las instrucciones en la barra de abajo («Cómo se juega» + teclas).
  Por eso las imágenes dejan libre la franja inferior.
- El juego es solo para ordenador (Windows y macOS). No hace falta nada para móvil.
- Es un fan-game sin ánimo de lucro: no subas estas imágenes como tuyas a ningún sitio comercial.
