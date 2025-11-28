

[![Flutter](https://img.shields.io/badge/Flutter-3.35.3-blue?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.2-blue?logo=dart&logoColor=white)](https://dart.dev)
[![FVM](https://img.shields.io/badge/FVM-Used-orange)](https://fvm.app)

Aplicación desarrollada con **Flutter**. Este proyecto sigue una arquitectura modular y utiliza las mejores prácticas de la comunidad para asegurar **escalabilidad** y **mantenibilidad**.

---

## ✨ Características Principales

- **Navegación Declarativa:** Uso de `go_router` para un enrutamiento robusto y basado en URLs.  
- **Gestión de Estado Centralizada:** Uso de `provider` para manejar el estado de la aplicación de manera eficiente y reactiva.  
- **Conectividad de Red:** Implementación de peticiones HTTP para interactuar con servicios web externos.  

---

## 🛠️ Stack Tecnológico

| Tecnología       | Versión         | Propósito                                      |
|-----------------|----------------|-----------------------------------------------|
| Flutter SDK      | 3.35.3 (Estable) | Framework principal de UI.                    |
| Dart SDK (DVM)   | 3.9.2           | Entorno de ejecución y lenguaje de programación. |
| FVM              | Utilizado       | Herramienta de gestión de versiones de Flutter. |

---

## 📦 Dependencias Clave

- `provider`: Gestor de estado simple y potente.  
- `go_router`: Biblioteca de enrutamiento y navegación.  
- `http`: Para la comunicación con APIs REST.  
- `shared_prefrences`: Guardar carrito en SharedPreferences.  

---

## ⚙️ Configuración y Ejecución Local

### 1. Requisitos Previos
Instala [FVM](https://fvm.app/) globalmente, ya que el proyecto está bloqueado a una versión específica de Flutter.

### 2. Configurar Flutter, descargar dependencias y ejecutar la app

Sigue estos pasos **en orden** dentro del proyecto:

```bash
# 1️⃣ Instalar la versión de Flutter especificada (3.35.3)
fvm install 3.35.3

# 2️⃣ Seleccionar esta versión como la versión local del proyecto
fvm use 3.35.3

# 3️⃣ Descargar todas las dependencias
fvm flutter pub get

# 4️⃣ Ejecutar la aplicación en un emulador o dispositivo conectado
fvm flutter run

