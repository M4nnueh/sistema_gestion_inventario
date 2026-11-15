# Sistema de Gestión de Inventario — API REST + Flutter con Autenticación JWT

Taller: Implementación de autenticación JWT y protección de servicios en Flutter  
Asignatura: Electiva Profesional I - Desarrollo de Aplicaciones Móviles  
Institución: UCEVA

---

## 1. Estructura del Proyecto

```text
mobiles_parcial2/
├── backend/                              # API REST con Node.js + Express + SQLite
│   ├── data/inventario.db                # Base de datos SQLite persistente
│   ├── src/
│   │   ├── config/
│   │   ├── middleware/
│   │   │   └── auth.js                   # Middleware JWT (authenticateToken)
│   │   ├── routes/
│   │   │   ├── auth.js                   # Rutas de login, verify y profile
│   │   │   └── productos.js              # Rutas CRUD de productos protegidas
│   │   ├── db.js                         # Inicialización SQLite y semillas (usuarios + productos)
│   │   ├── server.js                     # Servidor Express
│   │   └── validators.js                 # Validaciones de entrada
│   ├── .env.example
│   └── package.json
└── frontend/inventario_app/              # Aplicación móvil Flutter
    ├── lib/
    │   ├── models/
    │   │   ├── producto.dart             # Modelo de datos Producto
    │   │   └── user.dart                 # Modelo de datos Usuario
    │   ├── providers/
    │   │   ├── auth_provider.dart        # Estado de autenticación y sesión
    │   │   └── producto_provider.dart    # Estado de productos
    │   ├── repositories/
    │   │   └── producto_repository.dart  # Capa de repositorio
    │   ├── router/
    │   │   └── app_router.dart           # GoRouter con guards de redirección
    │   ├── screens/
    │   │   ├── dashboard_screen.dart     # Pantalla principal (protegida)
    │   │   ├── login_screen.dart         # Pantalla de inicio de sesión
    │   │   ├── productos_list_screen.dart# Lista de productos (protegida)
    │   │   ├── producto_detail_screen.dart # Detalle de producto (protegida)
    │   │   ├── producto_form_screen.dart # Crear/Editar producto (protegida)
    │   │   └── session_screen.dart       # Vista de información de sesión
    │   ├── services/
    │   │   ├── api_client.dart           # Cliente Dio con Interceptors automáticos
    │   │   ├── auth_service.dart         # Consumo de endpoints de auth
    │   │   ├── producto_service.dart     # Consumo de endpoints de productos
    │   │   └── session_service.dart      # flutter_secure_storage + shared_preferences
    │   ├── widgets/
    │   │   └── app_drawer.dart           # Menú lateral dinámico con perfil y logout
    │   ├── app.dart                      # Configuración de MaterialApp con GoRouter
    │   └── main.dart                     # Punto de entrada con inicialización asíncrona
    └── pubspec.yaml
```

---

## 2. Backend (Node.js + Express + SQLite + JWT)

### Tecnologías
- **Express**: Framework HTTP.
- **jsonwebtoken**: Generación y verificación de tokens JWT.
- **bcryptjs**: Encriptación segura de contraseñas con salt.
- **node:sqlite**: Base de datos SQLite integrada.
- **dotenv**: Manejo de variables de entorno.
- **cors**: Configuración de CORS para clientes web y móviles.

### Variables de entorno (`backend/.env`)
```env
PORT=3000
DB_PATH=./data/inventario.db
JWT_SECRET=s3cr3t_k3y_inventario_2024_jwt_!@#
JWT_EXPIRES_IN=24h
```

### Ejecución del Backend
```bash
cd backend
npm install
npm start
```
Disponible en: `http://localhost:3000` (o `http://10.0.2.2:3000` para emulador Android).

### Endpoints de la API

| Método | Endpoint | Protegido | Descripción |
|---|---|---|---|
| `POST` | `/api/auth/login` | No | Inicio de sesión, retorna JWT y usuario |
| `GET` | `/api/auth/profile` | **Sí (Bearer)** | Obtiene perfil del usuario autenticado |
| `POST` | `/api/auth/verify` | **Sí (Bearer)** | Valida vigencia del token |
| `GET` | `/api/productos` | **Sí (Bearer)** | Listar productos |
| `GET` | `/api/productos/:id` | **Sí (Bearer)** | Detalle de producto |
| `POST` | `/api/productos` | **Sí (Bearer)** | Crear producto |
| `PUT` | `/api/productos/:id` | **Sí (Bearer)** | Actualizar producto |
| `DELETE`| `/api/productos/:id` | **Sí (Bearer)** | Eliminar producto |

### Credenciales de prueba por defecto
- **Email:** `admin@inventario.com`
- **Contraseña:** `admin123`

*(Se genera automáticamente al iniciar el servidor con contraseña hasheada mediante bcrypt).*

---

## 3. Frontend (Flutter)

### Tecnologías y Librerías
- **dio (^5.11.1)**: Cliente HTTP para consumir los servicios REST con `InterceptorsWrapper` que adjunta automáticamente el encabezado `Authorization: Bearer <token>` y detecta respuestas `401 Unauthorized`.
- **flutter_secure_storage (^9.2.4)**: Almacenamiento seguro del token JWT cifrado en el llavero/Keystore del sistema.
- **shared_preferences (^2.3.4)**: Almacenamiento local de datos de sesión no sensibles (id, nombre, email del usuario).
- **go_router (^18.1.1)**: Enrutamiento declarativo con control de acceso (`redirect`) y reactividad mediante `refreshListenable: authProvider`. Si no hay sesión activa, bloquea el acceso a cualquier ruta protegida y redirige a `/login`.
- **provider (^6.1.5+1)**: Gestión de estado reactiva (`AuthProvider`, `ProductoProvider`).
- **flutter_dotenv (^6.0.1)**: Configuración de URL base.

### Ejecución de Flutter
```bash
cd frontend/inventario_app
flutter pub get
flutter run
```

---

## 4. Escenarios de Prueba Obligatorios (Demostración)

A continuación se detalla cómo demostrar y verificar cada uno de los 7 escenarios requeridos:

1. **Acceso sin autenticación:**
   - Al abrir la aplicación sin sesión activa, el `GoRouter` redirige automáticamente a `/login`. Intentar ingresar a `/`, `/productos` o `/sesion` es bloqueado tanto en la interfaz como en el backend.
2. **Credenciales incorrectas:**
   - En la pantalla de login, ingresar un usuario o contraseña inválido (ej. clave incorrecta).
   - Se muestra un mensaje de error claro en pantalla (`Credenciales incorrectas` o mensaje HTTP del servidor) y se deniega el acceso.
3. **Inicio de sesión correcto:**
   - Ingresar con `admin@inventario.com` y `admin123`.
   - El backend valida el hash bcrypt, emite el token JWT y el frontend lo guarda en `flutter_secure_storage`.
   - Se redirige automáticamente al **Dashboard** principal.
4. **Consumo de servicios CRUD protegidos con JWT:**
   - Con la sesión iniciada, listar productos, consultar detalles, agregar un nuevo producto, editarlo y eliminarlo.
   - Cada petición HTTP viaja con el encabezado `Authorization: Bearer <token>` gestionado de forma transparente por el interceptor de `Dio`.
5. **Persistencia de sesión:**
   - Cerrar completamente la aplicación y volver a abrirla.
   - La aplicación recupera el token de `flutter_secure_storage`, valida su vigencia contra `/api/auth/verify` y restaura el estado autenticado sin pedir credenciales nuevamente.
6. **Validación directa desde backend (Sin token):**
   - Realizar una petición directa sin token (usando cURL, Postman o navegador) a `http://localhost:3000/api/productos`.
   - La API responde inmediatamente con código de estado HTTP `401 Unauthorized` (`Acceso denegado. Token no proporcionado`).
7. **Cierre de sesión:**
   - En el menú lateral o desde la pantalla **Información de Sesión**, pulsar el botón **Cerrar Sesión**.
   - Se eliminan el token de `flutter_secure_storage` y los datos de `shared_preferences`.
   - El usuario es redirigido inmediatamente a la pantalla de login y pierde acceso a todas las rutas protegidas.

---

## 5. Flujo GitFlow

- **Rama Base:** `dev`
- **Rama de Trabajo:** `feature/taller_jwt`
- **Integraciones:** Commits descriptivos con trazabilidad de cambios en Backend y Frontend.
