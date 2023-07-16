# Micro Engine Docs
Documents the APIs exposed by the Micro engine (`engine/main.mjs`).

## `Micro.controls`

**`Micro.controls.init()`**
Initiates controls detection.

## `Micro.menu`

**`boolean Micro.menu.active`**

**`Micro.menu.init()`** Assigns handlers to menu buttons.

## `Micro.modules`

**`MicroModule[] Micro.modules.installed`**
An array of installed modules.

**`MicroModule[] Micro.modules.loaded`**
An array of loaded modules.

**`Micro.modules.install(string|File source)`**
Installs a module from either a url or a File object.

**`Micro.modules.resolveSource(string|File source)`**
Used by the `install` function to turn a string or file into a full URL for use by dynamic import.

**`Micro.modules.load(string|File source)`**
Loads an installed module based on its source.