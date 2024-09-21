# Guified

Guified is a lightweight GUI library for LÖVE (Love2D) that simplifies window management and UI element creation. It allows developers to create interactive graphical user interfaces with ease.

## Features

- Lightweight GUI library for LÖVE (Love2D) game framework.
- **Window Management:**
  - Set the game window to always stay on top of other windows.
- **UI Element Support:**
  - Create customizable buttons with click detection.
  - Design text boxes for displaying text at specified positions.
- **Dynamic Drawing and Updating:**
  - Register elements to be drawn and updated dynamically.
  - Toggle drawing and updating on or off during runtime.
- **Extensible Registry:**
  - Easily extend the library with new UI elements through the registry.
- **Error Handling:**
  - Provides error messages for missing elements or window handles.
- **Version Information:**
  - Includes version tracking (`__VER__ = "INF-DEV"`).

## Setup
### 1) Clone the repo.
```BASH
git clone --url here-- guified
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
### Doen ! have fun using guified !

## Notes
1) Guified works best with LOVE 11.5
2) Please report bugs to help speed up developement
3) **DO NOT declare love.run in main.lua as Guified uses it**

# **PLEASE NOTE THAT GUIFIED IS IN VERY EARLY DEVELOPEMENT AND DOES NOT HAVE MANY UI ELEMENTS !**
