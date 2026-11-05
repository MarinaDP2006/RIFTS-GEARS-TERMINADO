# Rifts & Gears
**Rifts & Gears** es un proyecto narrativo e interactivo inspirado en el universo de *Arcane* y *League of Legends*. Reúne un portal web informativo y un videojuego narrativo 2D ambientado en las ciudades de **Piltover** y **Zaun**.
El proyecto busca trasladar la atmósfera, los conflictos y la identidad visual de ambas ciudades a una experiencia centrada en los personajes, la exploración y las decisiones del jugador.

## Índice
- [Concepto y objetivos](#concepto-y-objetivos)
- [Componentes del proyecto](#componentes-del-proyecto)
- [El videojuego](#el-videojuego)
- [Las ciudades](#las-ciudades)
- [Tecnologías](#tecnologías)
- [Estado del desarrollo](#estado-del-desarrollo)
- [Organización del proyecto](#organización-del-proyecto)

## Concepto y objetivos
Rifts & Gears quiere ofrecer una experiencia narrativa para un jugador en la que el mundo, sus personajes y las decisiones tengan un papel central. La ambientación toma como referencia principalmente la serie *Arcane*, prestando especial atención a la personalidad y los contrastes entre Piltover y Zaun.

Los objetivos del proyecto son:
- Crear una experiencia narrativa interactiva con identidad visual propia.
- Permitir que el jugador comience su historia desde Piltover o Zaun.
- Desarrollar personajes, relaciones, misiones y contenidos que amplíen el mundo.
- Mantener una presentación visual e interfaces coherentes con la ambientación.
- Construir y probar los sistemas de forma progresiva.

## Componentes del proyecto

### Portal web informativo
Un espacio web para presentar el universo y ofrecer información de referencia sobre el proyecto, sus ciudades y sus contenidos. La web y el videojuego son partes diferenciadas y se mantienen separadas durante el desarrollo.

### Videojuego narrativo 2D
Una experiencia para un jugador desarrollada con **Godot Engine 4**. El jugador crea su propio personaje y vive una aventura interactiva desde la perspectiva de Piltover o Zaun.

## El videojuego
Entre los sistemas y contenidos previstos se encuentran:

- **Nueva partida:** elección de Piltover o Zaun como punto de partida.
- **Creación de personaje:** elección de procedencia, familia y datos del protagonista.
- **Historia interactiva:** diálogos, respuestas y decisiones que dan forma al recorrido narrativo.
- **Personajes y relaciones:** encuentros y vínculos con los habitantes del mundo.
- **Misiones:** historia principal, misiones secundarias e historias jugables.
- **Códice:** información sobre personajes, lugares, criaturas y razas, tecnologías, mundo y facciones.
- **Atlas:** consulta y exploración del mapa del mundo.
- **Ficha de personaje y comunicador:** información del protagonista y herramientas relacionadas con la aventura.
- **Sistema de guardado:** dos espacios independientes, uno para Piltover y otro para Zaun, con opciones previstas para cargar, borrar y exportar partidas.

Estas características forman parte de la dirección de diseño del juego; su disponibilidad dependerá del avance del desarrollo.

## Las ciudades

### Piltover
La Ciudad del Progreso. Una metrópolis de arquitectura elegante, innovación, comercio y tecnología Hextech. Su identidad visual se inspira en tonos dorados y azules, edificios refinados y contrastes sociales.

### Zaun
La ciudad subterránea. Un entorno industrial y desigual, marcado por la supervivencia, la inventiva y el poder del shimmer. Su identidad visual se inspira en tonos verdes y azules oscuros, estructuras industriales y una atmósfera más cruda.

## Tecnologías
- **Motor del videojuego:** Godot Engine 4 (desarrollo realizado con Godot 4.7.2).
- **Lenguaje del videojuego:** GDScript.
- **Portal web:** tecnologías web como HTML, CSS y JavaScript.
- **Formato previsto para intercambio de partidas:** JSON.
- **Tipo de juego:** aventura narrativa 2D para un jugador.
- **Idioma inicial:** español.

## Estado del desarrollo
El desarrollo se realiza por etapas, separando el diseño de las interfaces, la programación de sus funciones, las pruebas y la integración.

| Área | Estado |
|---|---|
| Pantalla de inicio | Completada |
| Nueva partida y selección de ciudad | Completada y funcional |
| Creación de personaje | Completada y funcional |
| Ajustes | Completados y funcionales |
| Cargar partida y gestión de guardados | En desarrollo |
| Códice y sus entradas | Estructura inicial creada; programación y contenido pendientes |
| Atlas / mapa 3D | Escena creada; integración pendiente |
| Historia, diálogos y decisiones | Desarrollo futuro |
| Misiones, personajes y comunicador | Planificados |

El estado puede cambiar conforme avance el proyecto. Una pantalla diseñada no se considera necesariamente terminada hasta que sus funciones estén implementadas y probadas.

## Organización del proyecto
Rifts & Gears se construye de forma gradual. Las interfaces se desarrollan y revisan antes de integrar los sistemas que dependen de ellas. Se priorizan la coherencia visual, la claridad de navegación, la estabilidad y la posibilidad de ampliar el juego sin rehacer lo que ya funciona.

La web informativa y el videojuego se mantienen como partes diferenciadas del proyecto.
