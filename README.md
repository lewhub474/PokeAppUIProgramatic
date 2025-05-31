# PokeAppUIKIT
Pokedéx diseñado en UI Programática 

# PokeAppUIKit

**PokeAppUIKit** es una aplicación iOS desarrollada en UIKit con vistas programaticas que permite visualizar una Pokédex de los primeros 151 Pokémon. La app ofrece funcionalidades como búsqueda, vista de detalle, y la posibilidad de marcar Pokémon como favoritos con persistencia local.

---

## 📱 Requisitos de ejecución

> ⚠️ **IMPORTANTE:** Esta aplicación debe probarse en un **iPhone real** y **no en el simulador**.

### ¿Por qué no usar simulador?

El servicio de imágenes (endpoint) que utiliza la app presenta inconsistencias cuando se hacen múltiples cargas consecutivas desde el simulador, posiblemente por temas de **cache interna o firmas de seguridad**.  
Aunque el código contiene métodos para limpiar la cache, **estos no surten efecto en simulador**.

✅ En dispositivos reales con **iOS 18 o superior**, **el problema no se presenta**.

---

## 🏗️ Tecnologías y arquitectura

- **Lenguaje:** Swift
- **UI:** UIKit (vistas programáticas)
- **Arquitectura:** MVVM con separación en capas:
  - `Domain`, `UseCases`, `Repositories`, `DTOs`, `ViewModels`, `Views`
- **Persistencia:** [RealmSwift](https://realm.io/docs/swift/latest/)
  - Se usa para almacenar los Pokémon marcados como favoritos.
- **Red:** `URLSession` con capa de red genérica para consumo de la [PokeAPI](https://pokeapi.co/)
- **Almacenamiento local:** Soporte offline con persistencia de los Pokémon favoritos.
- **Manejo de errores:** Manejados mediante enums personalizados con mensajes amigables y fallbacks seguros.
- **Tests:** Se incluyen pruebas unitarias para la capa de persistencia (Realm), validando la correcta carga y almacenamiento de datos.

---

## 🧪 Funcionalidades principales

- ✅ **Pantalla inicial** con los 151 primeros Pokémon.
- 🔍 **Buscador** por nombre en tiempo real.
- 📄 **Detalle del Pokémon:** muestra imagen, tipo, estadísticas, evoluciones y habilidades.
- ⭐ **Favoritos:** los usuarios pueden marcar/desmarcar Pokémon como favoritos.
- 💾 **Persistencia local:** los favoritos se almacenan usando Realm.
- 🧪 **Unit Tests:** se incluyen pruebas sobre la capa de persistencia.

---

## 🧭 Navegación

La aplicación cuenta con un `TabBarController` con dos secciones:

1. **Pokémon List View** – Lista general de Pokémon desde la API.
2. **Favorites View** – Lista persistente de Pokémon marcados como favoritos.

---

## 🚀 Cómo correr la app

1. Clona este repositorio:
   ```bash
   git clone https://github.com/lewhub474/PokeAppUIKit.git
