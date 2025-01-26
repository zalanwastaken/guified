# Guified Library Documentation 📚
#### NOTE: This doc only contains info about the core guified functions(A-1.2.0) not the modules
## GUI Elements 🖼️

### guified.registry.elements.button\:new(argx, argy, w, h, argtext) 🔘

Creates a new button element.

- **Parameters**:
  - `argx`, `argy`: Position of the button
  - `w`, `h`: Width and height of the button
  - `argtext`: Text to display on the button
- **Return**: button element

### guified.registry.elements.textBox\:new(argx, argy, text) 🗒

Creates a new text box element.

- **Parameters**:
  - `argx`, `argy`: Position of the text box
  - `text`: Initial text to display
- **Return**: textBox element

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

## Registry Management 📋

### guified.registry.register(element, id\_length, noerr) ➕

Registers a GUI element for drawing and updating.

- **Parameters**:
  - `element`: The element to register
  - `id_length`: Length of the generated ID (optional)
  - `noerr`: If true, suppresses errors (optional)
- **Return**: ID of the registered element

### guified.registry.remove(element, noerr) ➖

Removes a registered GUI element.

- **Parameters**:
  - `element`: The element to remove (or its ID as a string)
  - `noerr`: If true, suppresses errors (optional)
- **Return**: boolean (if `noerr` is true)

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

