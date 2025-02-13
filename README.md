# 🎮 Proyecto de Código para Roblox

Este repositorio contiene código escrito en **Lua**, utilizado en juegos de **Roblox**. Aunque no es necesario ejecutar este código en **Roblox Studio**, este documento explica cómo está organizado y qué hace cada parte.  

---

## 📂 Estructura del Proyecto  

El código está dividido en diferentes carpetas según su función en el juego:  

- **`Scripts/ServerScripts`** → Contiene la lógica principal del juego que se ejecuta en el servidor.  
  - 📌 **Ejemplo:** Gestión de partidas, control de enemigos, almacenamiento de datos.  

- **`Scripts/ClientScripts`** → Son los scripts que afectan solo al jugador y su pantalla.  
  - 📌 **Ejemplo:** Animaciones, efectos visuales, interfaz de usuario.  

- **`Scripts/ModuleScripts`** → Son pequeños módulos de código que se pueden reutilizar en varias partes del juego.  
  - 📌 **Ejemplo:** Funciones matemáticas, configuraciones globales, utilidades de red.  

- **`Scripts/StarterGui`** → Contiene scripts que controlan la interfaz del jugador (menús, botones, etc.).  
  - 📌 **Ejemplo:** Pantalla de inicio, tienda del juego, ajustes.  

- **`Assets/`** → Recursos como imágenes, sonidos y modelos 3D utilizados en el juego.  

- **`Docs/`** → Documentación técnica y explicaciones sobre cómo funciona el código.  

---

## 🛠️ ¿Cómo Funciona Este Código?  

El código está programado en **Lua**, el lenguaje que usa Roblox. Cada script tiene una función específica dentro del juego:  

🔹 **Ejemplo de un Script del Servidor** (control de enemigos):  
```lua
local Enemigo = {}
Enemigo.Vida = 100

function Enemigo.RecibirDaño(cantidad)
    Enemigo.Vida = Enemigo.Vida - cantidad
    if Enemigo.Vida <= 0 then
        print("El enemigo ha sido derrotado.")
    end
end
