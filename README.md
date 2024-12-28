# Guified 🎨🔅

Guified is a lightweight GUI library for LÖVE (Love2D) that simplifies window management and UI element creation. With its easy-to-use features, Guified enables developers to craft intuitive and interactive graphical user interfaces without unnecessary complexity. 🚀 Whether you're building a small game or a large application, Guified provides the tools you need to streamline the process.

## Features ✨
- **Window Management:**
  - 📌 Set the game window to always stay on top of other windows, ensuring your application remains in focus during critical interactions.
- **UI Element Support:**
  - 🔘 Create fully customizable buttons that detect clicks and allow for versatile user interactions.
  - 🖍️ Design text boxes to display and update text dynamically at specified positions on the screen.
  - 🎨 Create flexible and colorful frames to visually group UI elements and improve layout design.
- **Dynamic Drawing and Updating:**
  - ♻️ Register UI elements to be dynamically drawn and updated, ensuring real-time responsiveness.
  - ▶️ Easily toggle the drawing and updating of elements on or off during runtime for better control.
- **Extensible Registry:**
  - 🪧 Extend the library by adding custom UI elements through the registry, making it adaptable to your specific needs.
- **Color Management:**
  - 🟨 Assign dynamic colors to UI elements with support for both RGB and alpha transparency values, enabling rich visual customizations.
  - 🔹 Adjust and experiment with colors seamlessly to enhance the visual appeal of your project.
- **Error Handling:**
  - ❌ Provides detailed error messages for missing elements or invalid window handles, reducing debugging time.
- **Version Information:**
  - 🔢 Built-in version tracking ensures you're always aware of the library's iteration and improvements.

## Setup
### 1) Clone the repo.
```bash
git clone https://github.com/zalanwastaken/guified.git guified
cd guified
```
### 2) Copy guified to your project folder
```bash
cp -r guified <YOUR PROJECT FOLDER'S PATH>
```
### 3) Include guified in main.lua of your project
```lua
local guified = require("libs/guified")
```
### Done! ✨ Enjoy creating with Guified! 😎

## Notes
1. Guified works best with LOVE 11.5, the latest stable version, ensuring compatibility and optimal performance.
2. ⚙️ Encountered bugs? Report them to help speed up development and improve the library for everyone.
3. ⛔ **DO NOT declare love.run in main.lua as Guified relies on its functionality.**
4. 🔢 Check out the examples folder to quickly familiarize yourself with Guified's capabilities and jumpstart your project.
5. ⚠ **Currently, there are no plans to support MacOS.**
6. ❄ **Features that use FFI are not supported on Linux due to compatibility limitations.**

# ✨ **PLEASE NOTE THAT GUIFIED IS IN VERY EARLY DEVELOPMENT, AND MANY BUILT-IN UI ELEMENTS ARE YET TO BE ADDED! Stay tuned for updates and new features!**
