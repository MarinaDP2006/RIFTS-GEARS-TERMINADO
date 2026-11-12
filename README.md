# Rifts & Gears

**Rifts & Gears** es un fangame narrativo para un jugador ambientado en el universo de *Arcane*. Creas a tu propio personaje, eliges si naces en **Piltover** o en **Zaun** y vives la historia de la serie desde dentro: hablas con Vi, Jinx, Jayce, Caitlyn o Silco, tomas decisiones que cambian cómo te tratan y llegas a uno de sus ocho finales.

El proyecto tiene dos partes: el **videojuego**, hecho en Godot 4, y una **web** que presenta el universo, los personajes, los lugares y el propio juego.

> **Estado: completo.** El juego se puede jugar de principio a fin.

- **Web:** https://rifts-gears-terminado.onrender.com
- **Descarga para Windows:** [última versión en Releases](https://github.com/MarinaDP2006/RIFTS-GEARS-TERMINADO/releases/latest)

---

## Índice
- [Descargar y jugar](#descargar-y-jugar)
- [El juego](#el-juego)
- [Los minijuegos](#los-minijuegos)
- [La web](#la-web)
- [Estructura del repositorio](#estructura-del-repositorio)
- [Abrir el proyecto](#abrir-el-proyecto)
- [Tecnologías](#tecnologías)
- [Aviso](#aviso)

---

## Descargar y jugar
1. Entra en [Releases](https://github.com/MarinaDP2006/RIFTS-GEARS-TERMINADO/releases/latest) y descarga `RiftsAndGears.exe`.
2. Ábrelo con doble clic. No hace falta instalar nada: todo el juego va dentro de ese archivo.
3. Si Windows muestra «Windows protegió su PC», pulsa **Más información → Ejecutar de todas formas**. Sale porque el .exe no tiene firma digital.

**Requisitos:** Windows 10 u 11 de 64 bits y una tarjeta gráfica compatible con OpenGL 3.3.

Las partidas se guardan en `%APPDATA%\Godot\app_userdata\RiftsAndGears`.

---

## El juego

### Empezar
- **Nueva partida:** eliges Piltover o Zaun. La ciudad decide en qué historia empiezas y cómo te recibe cada personaje.
- **Creación de personaje:** siete apartados (ciudad, familia, barrio, oficio, rasgos, aficiones y estadísticas) y cuatro atributos: **Ingenio, Carisma, Valor y Sigilo**. Puedes ser prima de Vi, hermano de Jayce o hija de Silco.
- **Prólogo:** la historia arranca después de la explosión y de la muerte de Vander.

### Jugar
- **Mapa 3D:** Piltover se recorre en línea, de parada en parada. Desde el Puente se baja a Zaun, que se recorre por niveles en ascensor.
- **Lugares:** cada sitio tiene su propia pantalla, con la gente que hay allí.
- **Chats:** cada personaje escribe a su manera, y tú eliges entre varias respuestas.
- **Relaciones:** confianza, amistad, afecto y rivalidad. Puedes pasar de desconocido a confidente, a pareja… o a enemigo.

### La historia
- **Parte 1:** nueve capítulos, distintos según tu ciudad.
- **Parte 2:** nueve capítulos comunes a las dos ciudades.
- **8 finales:** cuatro por parte. El que te toca depende de lo que hayas hecho y de con quién te lleves bien.
- Algunos personajes pueden morir o salvarse según tus decisiones.

### Menús
- **Pausa:** continuar, guardar partida, Códice, mapa, minijuegos, ajustes y salir al menú.
- **Códice:** un libro con tu propia historia, los personajes, Piltover, Zaun, la tecnología, la cultura y la cronología. Está completo desde el principio: no hay que desbloquear nada.
- **Cargar partida:** dos ranuras. Puedes continuar, borrar o importar una partida.
- **Ajustes:** general, audio, juego, pantalla y controles. La música tiene su propio volumen.
- **Música:** un tema para los menús y otro para cada ciudad.

---

## Los minijuegos
Cinco por ciudad. Se pueden jugar desde la pausa, y algunos entran en la historia cuando una misión los pide. Cada uno explica abajo cómo se juega y qué teclas usa.

| Piltover | Zaun |
|---|---|
| Calibrar el cristal | El foso |
| Tiro de precisión | Carrera de aerotabla |
| Debate del Consejo | Grafiti |
| El Archivo | Mezclas de quimtec |
| Baile de gala | Cartas en La Última Gota |

---

## La web
Una web de fan sobre el universo de Arcane y sobre el juego:
- **Universo:** Piltover, Zaun y lo que separa a las dos ciudades.
- **Personajes:** fichas de los protagonistas, con su papel en la Parte 1 y en la Parte 2.
- **Lugares y Atlas:** los sitios de cada ciudad y el mapa.
- **Videojuego:** qué incluye, capturas, los minijuegos y el enlace de descarga.
- **Contacto:** para avisar de errores.

Está hecha con React y se publica en Render a partir de la carpeta `Web/` (configuración en `render.yaml`).

---

## Estructura del repositorio
```
juego/                  Proyecto de Godot (abrir juego/project.godot)
  escenas/              Pantallas y scripts del juego
    juego/datos/        Historia, capítulos y finales (historia.json)
    juego/minijuegos/   Los 10 minijuegos
  assets/               Imágenes, fuentes y música
  pruebas/              Pruebas automáticas (no van en el .exe)
Web/                    Código de la web
DATOS/                  Textos de partida: historia, chats, mundo, relaciones…
DOCUMENTOS/             Propuesta del TFG y guías del proyecto
interfaces_diseño/      Diseños de las pantallas
minijuegos_capturas/    Diseños de los minijuegos
render.yaml             Despliegue de la web en Render
```

---

## Abrir el proyecto

### Juego
1. Instala **Godot 4.7.2**.
2. Abre `juego/project.godot`.
3. Para crear el .exe: *Proyecto → Exportar → Windows*, o ejecuta `juego/exportar_windows.bat`. Antes hay que instalar las plantillas de exportación de Godot 4.7.2.

Prueba automática del juego completo. Recorre las dos ciudades y las dos partes, y abre los 10 minijuegos, la pausa, el final, *Cargar partida* y el prólogo:
```bash
godot --headless --path juego -s res://pruebas/prueba_auto.gd
```

### Web
```bash
cd Web
npm ci
npm run dev
```
`npm run build` genera la versión final en `Web/dist`.

---

## Tecnologías
- **Juego:** Godot Engine 4.7.2 y GDScript, con el renderizador *Compatibility* (OpenGL 3.3).
- **Web:** React 19, React Router, Vite, TypeScript y Tailwind CSS.
- **Datos:** la historia y las partidas guardadas van en JSON.
- **Despliegue:** Render (web) y GitHub Releases (juego).
- **Idioma:** español.

---

## Aviso
Rifts & Gears es un proyecto de fan sin ánimo de lucro hecho como Trabajo de Fin de Grado. *Arcane* y *League of Legends* pertenecen a Riot Games. Este proyecto no está afiliado a Riot Games ni respaldado por ellos.
