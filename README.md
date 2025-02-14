# 🎮 Proyecto de Código para Roblox

Este repositorio contiene código escrito en **Lua**, utilizado en juegos de **Roblox**. Aunque no es necesario ejecutar este código en **Roblox Studio**, este documento explica cómo está organizado y qué hace cada parte.

---

## 📂 Estructura del Proyecto

### 📁 **ServerScriptService** (Scripts del servidor)
Contiene la lógica principal del juego que se ejecuta en el servidor.
- **Control_Dinero.lua** → Gestiona la economía del juego, permitiendo añadir o restar dinero a los jugadores.
- **NivelesTarjeta.lua** → Define y almacena los diferentes tipos de tarjetas de acceso y sus niveles de autorización.
- **Sistema_Equipamiento.lua** → Permite a los jugadores equiparse con diferentes trajes y manejar sus funcionalidades.
- **Tags_Y_Cuerpo_jugador.lua** → Añade etiquetas a los jugadores, mostrando su nombre y el grupo al que pertenecen.

### 📁 **StarterPlayerService** (Scripts del jugador)
Scripts que afectan solo al jugador y su pantalla.
#### 📁 StarterPlayerScriptsService
- **Core_General.lua** → Actúa como el núcleo del sistema, coordinando la comunicación entre los módulos y ejecutando funciones clave.
- **Datos_Compartidos.lua** → Módulo que almacena variables globales y proporciona métodos para obtener (get) y guardar (put) valores.
- **Dinero.lua** → Maneja las transacciones monetarias del jugador, permitiendo obtener y modificar su saldo.
- **Encriptamiento.lua** → Se encarga de cifrar y descifrar datos sensibles para mayor seguridad.
- **Habilidades_SCP.lua** → Gestiona habilidades especiales dentro del juego, como invisibilidad o supervelocidad.
- **Kill_Notification.lua** → Muestra notificaciones cuando un jugador es eliminado.
- **Panel_Selector_Trajes.lua** → Proporciona una interfaz para que los jugadores elijan y cambien sus trajes.
- **Salud.lua** → Administra el estado de salud de los jugadores, controlando el daño y la curación.
- **Visiones_Especiales.lua** → Implementa modos de visión como visión nocturna o térmica.

### 📁 **ReplicatedStorageService\OpcionesEquipo**
Módulos reutilizables para la configuración del juego.
- **ConfigTeams.lua** → Configura los equipos dentro del juego, asignando jugadores a diferentes grupos.

---

## 🛠️ ¿Cómo Funciona Este Código?

El código está programado en **Lua**, el lenguaje que usa Roblox. Cada script tiene una función específica dentro del juego:

1. **El Servidor** gestiona el dinero, equipamiento y etiquetas de los jugadores.
2. **Los Módulos** permiten una estructura limpia y organizada, facilitando la comunicación entre sistemas.
3. **Core_General** actúa como el "cerebro" del sistema, coordinando la interacción entre los módulos.
4. **El Cliente** interactúa con los módulos para mostrar información y ejecutar funciones como habilidades y selecciones de trajes.

---

