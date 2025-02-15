# 🎮 Proyecto de Roblox

Este repositorio contiene código escrito en **Lua**, utilizado en juegos de **Roblox**. Aunque no es necesario ejecutar este código en **Roblox Studio**, este documento explica cómo está organizado y qué hace cada parte.

---

## 📂 Estructura del Proyecto

### 📁 **ServerScriptService** (Scripts del servidor)
Contiene la lógica principal del juego que se ejecuta en el servidor.
- **Control_Dinero.lua** → Gestiona la economía del juego, permitiendo añadir o restar dinero a los jugadores.
- **NivelesTarjeta.lua** → Modulo que define y almacena los diferentes tipos de tarjetas de acceso y sus niveles de autorización.
- **Sistema_Equipamiento.lua** → Permite a los jugadores equiparse con diferentes trajes y herramientas segun el equipo al que pertenezcan.
- **Tags_Y_Cuerpo_jugador.lua** → Añade etiquetas a los jugadores, mostrando su nombre y el grupo al que pertenecen.

### 📁 **StarterPlayerService** (Scripts del jugador)
Scripts que afectan solo al jugador y no al servidor.
#### 📁 StarterPlayerScriptsService
- **Core_General.lua** → Actúa como el núcleo del sistema, coordinando la comunicación entre los módulos y ejecutando funciones clave.
- **Datos_Compartidos.lua** → Módulo que almacena variables globales y proporciona métodos para obtener (get) y guardar (put) valores.
- **Dinero.lua** → Modulo que maneja transacciones monetarias del jugador, permitiendo obtener y modificar su dinero.
- **Encriptamiento.lua** → Modulo que se encarga de encriptar y desencriptar los nombres de algunos jugadores
- **Habilidades_SCP.lua** → Modulo para manejar las habilidades de algunos jugadores en equipos especiales.
- **Kill_Notification.lua** → Modulo que muestra notificaciones cuando un jugador es eliminado.
- **Panel_Selector_Trajes.lua** → Modulo que gestiona una interfaz para que los jugadores elijan y cambien su tipo de traje.
- **Salud.lua** → Modulo que administra el estado de salud del jugador y lo muestra en una interfaz.
- **Visiones_Especiales.lua** → Implementa modos de visión especial como visión nocturna o térmica.

### 📁 **ReplicatedStorageService\OpcionesEquipo**
Módulos reutilizables para la configuración del juego.
- **ConfigTeams.lua** → Modulo de configuracion donde se especifican atributos de los diferentes equipos, como nombre, salario que ganaran, descripcion de su equipo, trajes y divisiones que tiene el team, etc...

---

## 🛠️ ¿Cómo Funciona Este Código?

El código está programado en **Lua**, el lenguaje que usa Roblox. Cada script tiene una función específica dentro del juego:

1. **El Servidor** gestiona el dinero, equipamiento y etiquetas de los jugadores.
2. **Los Módulos** permiten una estructura limpia y organizada, facilitando la comunicación entre sistemas.
3. **Core_General** actúa como el "cerebro" del sistema, coordinando la interacción entre los módulos.
4. **El Cliente** interactúa con los módulos para mostrar información y ejecutar funciones como habilidades y selecciones de trajes.

---

