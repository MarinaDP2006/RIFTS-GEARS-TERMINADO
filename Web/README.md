# Rifts & Gears · Portal web

Web informativa del proyecto. Es HTML, CSS y JavaScript estático: no necesita compilar nada.

## Estructura
```
Web/
├── index.html          Página principal
├── privacidad.html     Privacidad y aviso legal
├── menu.js             Menú desplegable en móvil
├── icono-arcane.svg    Icono de la pestaña y del logo
├── css/estilos.css     Todos los estilos
└── assets/img/
    ├── capturas/       Capturas reales del juego (Godot)
    ├── ciudades/       Piltover y Zaun
    ├── personajes/     Retratos de personajes
    └── interfaz/       Iconos
```

## Verla en el ordenador
Doble clic en `index.html`, o con un servidor local:
```
python -m http.server 8080
```
y abrir http://localhost:8080

## Añadir una captura del juego
1. Guarda la imagen en `assets/img/capturas/` (mejor en .webp, 1152×648).
2. En `index.html`, dentro de `galeria-capturas`, copia una línea `<figure class="captura">` y cambia la ruta y el texto.

## Datos que aparecen en la web
Versión 0.1 · 16 personajes · 14 lugares · 30 capítulos · 8 finales · 15 minijuegos.
Si cambian, se editan directamente en `index.html`.
