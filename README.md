# Frontend - App Móvil Escuela Sabática Control

Esta es la aplicación móvil para el control de estudio y asistencia para la Escuela Sabática. Desarrollada con Flutter, la aplicación implementa una arquitectura desacoplada para facilitar el mantenimiento y la escalabilidad.

## Tecnologías y Herramientas
* **Framework:** Flutter / Dart
* **Gestión de Estado:** Provider
* **Arquitectura:** Clean Architecture (Data, Domain, Presentation)
* **Estilos y Temas:** Google Fonts, Custom Theme Extensions (Soporte para Modo Claro/Oscuro)
* **Inyección de Dependencias:** Contenedores de inyección manual por módulo.

## Estructura del Proyecto

El código se organiza dentro de la carpeta `lib` siguiendo los principios de separación de capas:

* **`core/`**: Utilidades globales, configuración de red (`api_conf`), rutas y temas.
* **`features/`**: Módulos independientes de la aplicación:
    * **`data/`**: Modelos de datos y fuentes de datos remotas.
    * **`domain/`**: Entidades de negocio y casos de uso.
    * **`presentation/`**: Páginas (UI), widgets, providers y controladores.

## Requerimientos Implementados Hasta el Momento

### 1. Módulo de Autenticación
* Flujo completo de registro y acceso de usuarios.
* Gestión de perfil de usuario con visualización de roles (dinámicas).
* Persistencia de sesión mediante tokens.

### 2. Estudio de Lección (Catálogo)
* Navegación jerárquica: Trimestres -> Lecciones -> Lecturas diarias.
* Renderizado de contenido de estudio basado en HTML.
* Marcado de progreso diario con actualización en tiempo real.
* Configuración de visualización (Ajuste de tamaño de fuente).

### 3. Gestión de Grupos
* **Para Miembros:** Visualización de tablero personal de progreso.
* **Para Líderes:** * Vista de administración de miembros del grupo.
  * Visualización de días estudiados por cada integrante (Cargados desde el backend).
* **Para Directores:** Vista de múltiples grupos de estudio asignados a su iglesiaia.
* **Interfaz Visual:** Indicadores de progreso circulares y lineales con colores según el desempeño.

### 4. Reportes y Estadísticas
* Visualización de estadísticas de estudio semanales y trimestrales.
* Historial de lecciones finalizadas.

### 5. Administración (Módulo Admin)
* Búsqueda de usuarios por correo electrónico.
* Administración de roles y transferencia de usuarios entre iglesias.

## Interfaz de Usuario y Temas
* **Modo Oscuro/Claro:** Implementado mediante `ThemeExtension` para tener consistencia en colores de texto, tarjetas e íconos.
* **Navegación:** Barra de navegación inferior personalizada (`CustomBottomNavBar`) y sistema de rutas centralizado.

---

## Configuración del Entorno de Desarrollo

### Requisitos
* Flutter SDK (Versión estable).
* Dart SDK.

### Configuración de API
El archivo de configuración de red se encuentra en `lib/core/network/api_conf.dart`. Es necesario definir la URL base del servidor:

```dart
class ApiConstants {
  static const String baseUrl = 'http://IP_DEL_SERVIDOR:3000/api/v1';
}