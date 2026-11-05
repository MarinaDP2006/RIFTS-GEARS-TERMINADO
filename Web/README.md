# Rifts & Gears · Portal web

Portal informativo del proyecto, basado en el diseño de Figma Make.
Hecho con **React + Vite** (TypeScript) + para animaciones o detalles minimos ClaudeCodex.

## Páginas
Inicio · Universo · Ciudades · Personajes · Lugares · Atlas · Videojuego · Contacto

## Estructura
```
Web/
├── index.html            Plantilla HTML (título, icono, descripción)
├── src/
│   ├── main.tsx          Arranque de React
│   ├── index.css         Todos los estilos
│   └── app/
│       ├── routes.tsx    Rutas de cada página
│       ├── components.tsx  Cabecera, pie, fichas, marcos de imagen
│       ├── pages.tsx     Contenido de cada página
│       └── data.ts       Personajes, lugares y capturas del juego
└── public/               Archivos que se sirven tal cual
    ├── icono-arcane.svg
    └── assets/           Imagen de portada e imágenes de ciudades, personajes y capturas
```

## Usarla en el ordenador
Necesitas Node.js. En la carpeta `Web`:
```
npm install
npm run dev
```
y abre http://localhost:5173

Para generar la versión final (carpeta `dist/`):
```
npm run build
```

## Cambiar contenido
- **Personajes, lugares o capturas**: edita `src/app/data.ts`. Las imágenes van en `public/assets/img/...` y se escriben con ruta `/assets/img/...`.
- **Textos de una página**: `src/app/pages.tsx`.

## Publicar en Render
El archivo `render.yaml` de la raíz del repositorio ya lo deja configurado como **Static Site**:
- Root directory: `Web`
- Build command: `npm ci && npm run build`
- Publish directory: `dist`
- Rewrite `/*` → `/index.html` (para que /personajes, /atlas, etc. funcionen al recargar)
