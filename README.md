```
 $$$$$$\            $$\  $$$$$$\  $$\                 $$\        $$$$$$\            $$\ $$\                           $$$\   
$$  __$$\           \__|$$  __$$\ \__|                $$ |      $$  __$$\           $$ |$$ |                           \$$\  
$$ /  \__|$$\   $$\ $$\ $$ /  \__|$$\  $$$$$$\   $$$$$$$ |      $$ /  $$ | $$$$$$\  $$ |$$$$$$$\   $$$$$$\        $$\   \$$\ 
$$ |$$$$\ $$ |  $$ |$$ |$$$$\     $$ |$$  __$$\ $$  __$$ |      $$$$$$$$ |$$  __$$\ $$ |$$  __$$\  \____$$\       \__|   $$ |
$$ |\_$$ |$$ |  $$ |$$ |$$  _|    $$ |$$$$$$$$ |$$ /  $$ |      $$  __$$ |$$ /  $$ |$$ |$$ |  $$ | $$$$$$$ |             $$ |
$$ |  $$ |$$ |  $$ |$$ |$$ |      $$ |$$   ____|$$ |  $$ |      $$ |  $$ |$$ |  $$ |$$ |$$ |  $$ |$$  __$$ |      $$\   $$  |
\$$$$$$  |\$$$$$$  |$$ |$$ |      $$ |\$$$$$$$\ \$$$$$$$ |      $$ |  $$ |$$$$$$$  |$$ |$$ |  $$ |\$$$$$$$ |      \__|$$$  / 
 \______/  \______/ \__|\__|      \__| \_______| \_______|      \__|  \__|$$  ____/ \__|\__|  \__| \_______|          \___/  
                                                                          $$ |                                               
                                                                          $$ |                                               
                                                                          \__|                                               
```

Guified is a ~~lightweight~~ GUI library for LÖVE (Love2D) that simplifies window management and UI element creation. With its easy-to-use features, Guified enables developers to craft intuitive and interactive graphical user interfaces without unnecessary complexity. 🚀 Whether you're building a small game or a large application, Guified provides the tools you need to streamline the process.

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
```
### 2) Copy guified to your project folder
```bash
cp -r guified <your project folder>
```
### 3) Include guified in main.lua of your project
```lua
local guified = require(<path to guified>)
```
### 4) Setup ENV variable(Optional but highly recommended if you want to use modules)
```bash
export GUIFIEDROOTFOLDER=<Same as the require path in main.lua>
```
### Done! ✨ Enjoy creating with Guified! 😎

## Notes
1. Guified works best with LOVE 11.5, the latest stable version, ensuring compatibility and optimal performance.
2. ⚙️ Encountered bugs? Report them to help speed up development and improve the library for everyone.
3. 🔢 Check out the examples folder to quickly familiarize yourself with Guified's capabilities and jumpstart your project.
4. ⚠ **Currently, there are no plans to support MacOS.**
5. ❄ **Features that use FFI are not supported on Linux due to compatibility limitations.**
