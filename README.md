# Sistema de Gestion de Inventario — API REST + Flutter

Segundo Parcial Practico — Electiva Profesional I (Desarrollo de Aplicaciones Moviles).

## Estructura

- `backend/`: API REST con Node.js + Express + SQLite (persistencia real).
- `frontend/inventario_app/`: aplicacion movil en Flutter.

## Backend

Tecnologias: Node.js, Express, SQLite (node:sqlite), CORS, dotenv.

### Instalacion y ejecucion

```bash
cd backend
npm install
npm start
```

La API queda disponible en `http://localhost:3000`.

### Endpoints

- `GET /api/productos` — listar todos los productos
- `GET /api/productos/{id}` — detalle de un producto
- `POST /api/productos` — registrar producto
- `PUT /api/productos/{id}` — actualizar producto
- `DELETE /api/productos/{id}` — eliminar producto

### Base de datos

SQLite en `backend/data/inventario.db`. Se crean 10 productos de prueba automaticamente si la tabla esta vacia.

## Flutter

Tecnologias: Flutter, Dio, go_router, flutter_dotenv, provider.

### Instalacion y ejecucion

```bash
cd frontend/inventario_app
flutter pub get
flutter run
```

Configura la URL base en `assets/.env`:

```
API_BASE_URL=http://localhost:3000
```

En emulador Android se usa automaticamente `http://10.0.2.2:3000`.

## Funcionalidades

- Dashboard con total de productos, unidades disponibles y valor total del inventario.
- CRUD completo de productos consumiendo la API mediante Dio.
- Navegacion con go_router y menu lateral.
- Validacion de formularios y manejo de errores.
- Estados de carga, error y lista vacia.

## Validaciones API

Campos obligatorios: nombre, codigo, precio, cantidad, categoria. Precio >= 0, cantidad entero >= 0. Codigo unico.

## Notas

- No se incluyen credenciales en el repositorio.
- El despliegue en la nube es opcional (5%).