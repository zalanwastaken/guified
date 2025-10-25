```
 ▗▄▄▖█  ▐▌▄ ▗▞▀▀▘▄ ▗▞▀▚▖   ▐▌    ▗▄▄▖ ▗▞▀▚▖   ■  ▗▞▀▜▌
▐▌   ▀▄▄▞▘▄ ▐▌   ▄ ▐▛▀▀▘   ▐▌    ▐▌ ▐▌▐▛▀▀▘▗▄▟▙▄▖▝▚▄▟▌
▐▌▝▜▌     █ ▐▛▀▘ █ ▝▚▄▄▖▗▞▀▜▌    ▐▛▀▚▖▝▚▄▄▖  ▐▌       
▝▚▄▞▘     █ ▐▌   █      ▝▚▄▟▌    ▐▙▄▞▘       ▐▌       
                                             ▐▌
```
###### The 2000+ lines of code so you only have to write 100

Guified is a GUI library/framework(depends on how you use it) for LÖVE (Love2D) that simplifies window management and UI element creation. With its easy-to-use features, Guified enables developers to craft intuitive and interactive graphical user interfaces without unnecessary complexity. 🚀 Whether you're building a small game or a large application, Guified provides the tools you need to streamline the process.

### Why Guified? 🤷
Because devs don’t need babysitters. Guified is built on power without bloat — a toolkit that gives you a registry, error handling, and control when you want it, without ever boxing you in. No forced patterns, no training wheels. Just more in less, so you can bend it to your will and ship what you want.

### What is Guified? 🤷
Guified is a dev-first library/framework that makes doing more with LOVE2D stupidly simple. From UI/UX to full apps, it gives you powerful tools that stay out of your way. It’s flexible, fast, and designed with one rule: power to devs.

## Features ✨
- **Window Management:**
  - 📌 Set the game window to always stay on top of other windows, ensuring your application remains in focus during critical interactions.
- **UI Element Support:**
  - 🔘 Create fully customizable buttons that detect clicks and allow for versatile user interactions.
  - 🖍️ Design text boxes to display and update text dynamically at specified positions on the screen.
  - 🎨 Create flexible and colorful frames to visually group UI elements and improve layout design.
  - **And More**
- **Dynamic Drawing and Updating:**
  - ♻️ Easily register UI elements to be dynamically drawn and updated, ensuring real-time responsiveness.
  - ▶️ Easily toggle the drawing and updating of elements on or off during runtime for better control.
- **Extensible Registry:**
  - 🪧 Extend the library by adding custom UI elements through the registry, making it adaptable to your specific needs.
  - Make custom elements and easily register them using the registry :-
  ```lua
    local element = {
      name = "name" -- required
      draw = function() -- required
      end,
      update = function(dt) -- optional
      end,
      keypressed = function(key) -- optional
      end,
      textinput = function(key) -- optional
      end
    }
    guified.registry.register(element)
  ```
- **Color Management:**
  - 🟨 Assign dynamic colors to UI elements with support for both RGB and alpha transparency values, enabling rich visual customizations.
  - 🔹 Adjust and experiment with colors seamlessly to enhance the visual appeal of your project.
- **Error Handling:**
  - ❌ Provides detailed error messages for missing elements or invalid window handles, reducing debugging time.
  - Custom error handler implimented by Guified.
- **Version Information:**
  - 🔢 Built-in version tracking ensures you're always aware of the library's iteration and improvements.
- **😊 Choose what you need:**
  - ❌ Simply remove the files whose features you dont use gufied will adapt.
  - Eg. Dont use modules ? ```rm -rf modules/```. Dont use FFI features ? ```rm -rf os_interop.lua```.
- **🫵 Guified adapts to you**
  - Dont wanna use registry ? Use elements with love2d functions :-
    ```lua
      local element -- your element
      function love.update(dt)
        element.update()
      end
      function love.draw()
        element.draw()
      end
    ```
- **📜 Debug**
  - Guified comes pre-packaged with a [logger](https://github.com/Nykenik24/love2d-tools) making debugging easy.
- **🔫 No Dependency hunting**
  - Guified come pre-packaged with its dependencies so no dependency hunting. More time you can spend coding !
- **🧩 Modules**
  - Guified comes with many modules. Making it easy to create things like frames, tweens.
  - Only load what you need. Guified wont make you load all the modules only load what you need
  ```lua
    local module = require("guified.modules.modulename")
  ```
- **➕ ExtCalls**
  - Guified depends on love.run but now you can modify it easily and still not break guified !
  - `guified.extcalls` provide easy to use functions that handle things like draw calls, update calls etc. 
- **🤷 Not satisfied ?**
  - Guified is still in beta so there is still more to come along

## Setup
### 1) Clone the repo.
```bash
git clone https://github.com/zalanwastaken/guified.git guified
cd guified
```
### 2) Copy guified to your project folder
```bash
cp -r guified <your project folder>
```
### 3) Include guified in main.lua of your project
```lua
local guified = require(<path to guified>)
```
### Done! ✨ Enjoy creating with Guified! 😎

## Latest Guified version
Latest Guified version is currently B-2.0.3 "Repressed Memory Edition".<br>
This version supports the following Love2d version(These versions are tested with Guifed other versions might also run Guified fine):-
- 11.5 (Mysterious Mysteries)
  - Windows ✅ Full support
  - Linux ✅ Without FFI
  - MacOS ❌ No support. Bugs on MacOS wont be fixed(Guified might still run. MacOS is not blocked)[COMING SOON IN B-2.1.0]
- 11.4 (Mysterious Mysteries)
  - Windows ✅ Full support
  - Linux ✅ Without FFI
  - MacOS ❌ No support. Bugs on MacOS wont be fixed(Guified might still run. MacOS is not blocked)[COMING SOON IN B-2.1.0]

## 📍 Roadmap  

### ✅ **Current Features**  
✔ **UI Elements:** Buttons, frames, text boxes, etc.  
✔ **Dynamic Registry System:** Easily register and manage UI components.  
✔ **Minimal Boilerplate:** Write less code, do more.  
✔ **Custom Error Handling:** No more cryptic errors.  
✔ **Debugging Tools:** Built-in logger for easy debugging.    

### 🚀 **Planned Features**  
🔹 **State Management (like React useState, but for LÖVE)**  
🔹 **Scene Management (UI "sets" to switch views easily)**  
🔹 **Callback System for UI Events**  
🔹 **Better Input Handling (keyboard, mouse, and maybe gamepad support?)**  
🔹 **Performance Optimizations & Code Cleanup**  
🔹 **More UI Components (Dropdowns, Sliders, etc.)**  
🔹 **Make a studio for LOVE2D using Guified** <br>
🔹 **Modular Design: Use only the features you need.**

### 🔮 **Future Goals**  
✨ Make Guified the **go-to UI framework for LÖVE**(TRY)<br>
✨ Support **legacy LÖVE versions for no reason at all**<br>

### 🎯 **Side Quests (Ongoing Tasks)**
🔸 Ensure removing unused modules doesn’t break everything.<br>
🔸 Improve documentation so new users don’t suffer.<br>
🔸 Test Guified on different LÖVE versions (including ancient ones for no reason).<br>
🔸 Find and fix the weirdest possible edge cases.<br>

## Notes
1. ⚙️ Encountered bugs? Report them to help speed up development and improve the library for everyone.
2. 🔢 Check out the examples folder to quickly familiarize yourself with Guified's capabilities and jumpstart your project.
3. ❄ **Features that use FFI are not supported on Linux due to FFI features using os dependent code**
