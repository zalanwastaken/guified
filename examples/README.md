# Guified Library Documentation 📚
#### NOTE: This doc only contains info about the core guified functions(A-1.2.2) not the modules


## Setup 😺

1) Install some tools for initial setup
```BASH
  sudo apt install unzip wget
```
OR
```BASH
  sudo pacman -S unzip wget
```

2) Start by downloading a release version of Guified
```BASH
  wget https://github.com/zalanwastaken/guified/releases/download/A-1.2.2/A-1.2.2.zip
```

3) Extract the downloaded archive
```BASH
  unzip A-1.2.2.zip
```

4) Move Guified into your project's lib folder
```BASH
  mv A-1.2.2 <your projects's folder>
```

5) Include Guified in main.lua of your folder
```LUA
  local guified = require("libs.guified")
```

Done !🚀

## Basic `Hello World` example
```LUA
  local guified = require("guified")

  --* create a text element
  local text = guified.registry.elements.text:new(0, 0, "Hello world !")

  --* register it
  --* if we dont register the element it will not be drawn or updated
  --* drawing is handled by guified automatically
  guified.registry.register(text)
```
### Check other examples in the examples folder !

## GUI Elements 🖼️

### guified.registry.elements.button\:new(argx, argy, w, h, argtext) 🔘

Creates a new button element.

- **Parameters**:
  - `argx`, `argy`: Position of the button
  - `w`, `h`: Width and height of the button
  - `argtext`: Text to display on the button
- **Return**: button element

### guified.registry.elements.text\:new(argx, argy, text) 🗒

Creates a new text element.

- **Parameters**:
  - `argx`, `argy`: Position of the text
  - `text`: Initial text to display
- **Return**: text element

### guified.registry.elements.box\:new(x, y, w, h, mode, clr) 📦

Creates a new box element.

- **Parameters**:
  - `x`, `y`: Position of the box
  - `w`, `h`: Width and height of the box
  - `mode`: Drawing mode ("fill" or "line")
  - `clr`: Color of the box (optional, defaults to white)
- **Return**: box element

### guified.registry.elements.image\:new(x, y, image) 🖼️

Creates a new image element.

- **Parameters**:
  - `x`, `y`: Position of the image
  - `image`: LÖVE image object to display
- **Return**: image element

### guified.registry.elements.textinput\:new(argx, argy, w, h, placeholder, active) 🗒

Creates a new textinput element.

- **Parameters**:
  - `x`, `y`: Position of the element
  - `w`, `h`: Dimensions of the element
  - `placeholder` : The placeholder text (optional)
  - `active` : Is the element active by default (optional)
- **Return**: textinput element


## Registry Management 📋

### guified.registry.register(element, id\_length) ➕

Registers a GUI element for drawing and updating.

- **Parameters**:
  - `element`: The element to register
  - `id_length`: Length of the generated ID (optional)
- **Return**: ID of the registered element

### guified.registry.remove(element) ➖

Removes a registered GUI element.

- **Parameters**:
  - `element`: The element to remove (or its ID as a string)

## Window Management 🫐

### guified.setWindowToBeOnTop() 📌

Sets the window to always be on top of other windows.

## Draw and Update Control 🎨

### guified.toggleDraw() 🔄

Toggles the drawing of GUI elements on/off.

### guified.toggleUpdate() 🔄

Toggles the updating of GUI elements on/off.

### guified.getDrawStatus() 🟢

Returns the current draw status.

- **Return**: boolean

### guified.getUpdateStatus() 🟢

Returns the current update status.

- **Return**: boolean

## Utility Functions 🛠️

### guified.getIdTable() 🆔

Returns the table containing all registered element IDs.

- **Return**: table of element IDs

### guified.getFontSize() 🔤

Returns the current font size used for text rendering.

- **Return**: number

### guified.setFontSize(size) 🔤

Sets the font size for text rendering.

- **Parameters**:
  - `size`: The new font size to set

### guified.setTextInput(enable)

Enables or disables text input.

- **Parameters**:
  - `enable`: A boolean to enable (`true`) or disable (`false`) text input

### guified.getRegistry() 🔗

Returns the internal registry used by guified.

- **Return**: The registry table containing all registered elements

## Version Information ℹ️

### guified.**VER** 🏷️

A string containing the current version of the Guified library.

# Please open a issue if there are problems in this doc !
