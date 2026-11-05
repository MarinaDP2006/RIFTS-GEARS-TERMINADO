import { createBrowserRouter } from "react-router";
import { Layout, NotFound } from "./components";
import {
  AtlasPage,
  CharactersPage,
  CitiesPage,
  ContactPage,
  GamePage,
  HomePage,
  PlacesPage,
  UniversePage,
} from "./pages";

export const router = createBrowserRouter([
  {
    path: "/",
    Component: Layout,
    children: [
      { index: true, Component: HomePage },
      { path: "universo", Component: UniversePage },
      { path: "ciudades", Component: CitiesPage },
      { path: "personajes", Component: CharactersPage },
      { path: "lugares", Component: PlacesPage },
      { path: "atlas", Component: AtlasPage },
      { path: "videojuego", Component: GamePage },
      { path: "contacto", Component: ContactPage },
      { path: "*", Component: NotFound },
    ],
  },
]);
