# Guified

Guified is a lightweight GUI library for LÖVE (Love2D) that simplifies window management and UI element creation. It allows developers to create interactive graphical user interfaces with ease.

## Features
- **Window Management:**
  - Set the game window to always stay on top of other windows.
- **UI Element Support:**
  - Create customizable buttons with click detection.
  - Design text boxes for displaying text at specified positions.
  - Create colored frames for UI elements.
- **Dynamic Drawing and Updating:**
  - Register elements to be drawn and updated dynamically.
  - Toggle drawing and updating on or off during runtime.
- **Extensible Registry:**
  - Easily extend the library with new UI elements through the registry.
- **Color Management:**
  - Set colors for UI elements dynamically.
  - Supports RGB and alpha values for color customization.
- **Error Handling:**
  - Provides error messages for missing elements or window handles.
- **Version Information:**
  - Includes version tracking (__VER__ = "INF-DEV").
## Setup
### 1) Clone the repo.
```BASH
git clone https://github.com/zalanwastaken/guified.git guified
cd guified
```
### 2) Copy guified to you project folder
```BASH
cp -r guified <YOUR PROJECT FOLDER'S PATH>
```
### 3) Include guified in main.lua of your project
```LUA
local guified = require("libs/guified")
```
### Done ! have fun using guified !

## Notes
1) Guified works best with LOVE 11.5
2) Please report bugs to help speed up developement
3) **DO NOT declare love.run in main.lua as Guified uses it**
4) The examples folder conatins some examples to help you get started
5) **There are no current plans to support MacOS**
6) **FEATURES THAT USE FFI WILL NOT WORK ON LINUX**

# **PLEASE NOTE THAT GUIFIED IS IN VERY EARLY DEVELOPEMENT AND DOES NOT HAVE MANY INBUILT UI ELEMENTS !**
