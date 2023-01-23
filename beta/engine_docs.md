# Micro Engine

Imported from `engine/micro.mjs`, the engine, as part of the Crystal Clear update, runs most of Micro's very core code.

*Note: The Crystal Clear update is very much incomplete and things that are crossed out are intended behavior that has not yet been implemented.*

## Current API

### `Micro.menu`

`Micro.menu.build()` ~~constructs and~~ shows the menu.

`Micro.menu.load(slot)` loads the game ~~based on the world slot passed.~~

`Micro.menu.show(id, anim)` shows a screen in the menu, or hides the menu if `'game'` is passed. If `anim` is true, the transition fades over 1 second.

`Micro.menu.TAGS` is an enumeration of all existing tags and their corresponding images in the menu.