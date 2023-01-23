# Micro Documentation

Documentation of common "APIs" in Micro's code

## Cutscenes

To start a cutscene, run

```javascript
world.cutscene = true;
```

Now, all controls will be redirected to the cutscene rather than triggering normal actions.
Next, we must handle these controls (even if we won't use them for anything).

```javascript
world.cutsceneControls = (control) => {
  //code to handle a key pressed
};
```

The `control` parameter is a number that specifies what button was pressed.

### Control IDs

| Number | Key         |
| ------ | ----------- |
| 0      | Left Arrow  |
| 1      | Right Arrow |
| 2      | Up Arrow    |
| 3      | Down Arrow  |
| 4      | Space       |
| 5      | Number 0    |
| 6      | Number 1    |
| 7      | Number 2    |
| 8      | Number 3    |
| 9      | Number 4    |
| 10     | Number 5    |
| 11     | Number 6    |
| 12     | Number 7    |
| 13     | Number 8    |
| 14     | Number 9    |
| 15     | Reset (r)   |

### Showing a cutscene

To show a cutscene,

```javascript
$("#current-cutscene").html('<use href="#mycutscene">');
$("#cutscene-overlay").show();
```

This shows a cutscene that is defined in a `symbol` element inside the defs of the `cutscene-overlay` SVG by ID.

### Stopping a cutscene

Obviously, to stop a cutscene, we reverse our previous steps:

```javascript
world.cutscene = false;
$('#cutscene-overlay').hide();
```

## Combat

As of Micro 0.0.2.10, combat is one unified API. First,

```javascript
import initCombat from "./combat.mjs";
```

Next, `initCombat` is called with the world and an object, following this schema:

```json
{
  "enemyHealth": Number, //The amount of health the enemy has, in quarter-circles
  "enemyDamage": Number, //The amount of damage the enemy deals
  "enemySpeed": Number, //The interval, in milliseconds, between enemy attacks
  "winAtHealth": Number, //An optional number used by the Warp Quest to win a combat when enemy health is reduced beyond here instead of 0.
  "win": Function, //A function to be called on winning the combat
  "lose": Function, //A function to be called on losing the combat
  "loot": Boolean, //Whether the enemy has loot
  "lootTable": LootTable, //See the Loot Tables section for details
  "lootRolls": Number, //How many items are rolled from the loot table
  "handleLoot": Function //An optional function to describe how to handle the loot. See below.
}
```

Notes:

The win and lose functions do not imply hiding or changing of the cutscene, loss of items, etc, these must be defined within those functions

The handleLoot function is called for each item in the drawn loot. If the function returns nothing or is left undefined, normal
handling is used for that item (it is added to the player's inventory). If the function returns true, it tells the API it has
already handled the item specially and normal handling should not be used.

## Loot Tables

Loot tables are used to determine rewards from combat. Quite simply, they are arrays of objects, like this:

```json
[
  {
    "item": String, //The character representing the item
    "weight": Number //The relative chance for the item to be drawn (i.e. the amount of the item in the total 'bucket', the more there are, the greater chance it is drawn)
  }
]
```

## Dialogue

Micro 0.0.2.11 added a dialogue animation API. This section describes its usage.

### The Dialogue Object

As with combat, one object is passed into the dialogue function, containing all the needed data.
We will go through each part of this object in detail later, but here is the schema:

```json
{
  "length": Number, //How long the dialogue animation lasts
  "finish": Function, //A function to be run when the animation finishes
  "characters": [ //Characters referenced in actions
    {
      "elem": jQuery, //The jQuery element of the sprite of this character
      "speech": jQuery //The jQuery element of the speech box of this character
    }
  ],
  "timeline": { //An animation timeline. Keys are to the tenth of a second (more accurate times will not be run)
    "<key>": [ //For example, '2.5' is run two and a half seconds into the animation. This is a list of actions to run
      { //An action to be run at that time
        "type": String //The type of action to be run
        //Further parameters depend on type.
      }
    ]
  }
}
```

### Characters

The `characters` array describes the characters that will be referenced in actions by its index in the array.
They have an `elem` for their primary sprite (i.e. a text box with '◈' for the player)
and a `speech` for their speech box (usually above the sprite, and used in `speak` actions)

### Actions

Actions are run at points on the timeline, as seen above. Depending on the `type` of action, more parameters are needed.

For `move`:

```json
{
  "type": "move",
  "target": Number, //The index of the character to move
  "toX": Number, //X SVG coordinate of new position
  "toY": Number, //Y SVG coordinate of new position
  "time": Number, //How long in milliseconds the animation takes
  "speechAlsoMoves": Boolean //Whether the speech box moves accordingly
}
```

For `speak`:

```json
{
  "type": "speak",
  "target": Number, //The index of the character that speaks
  "text": String, //What the character says: renders in their speech box. Question marks are obfuscated.
  "time": Number //How long, in milliseconds, this text is kept on-screen
}
```

For `fade`:

```json
{
  "type": "fade",
  "target": Number, //The index of the character that fades
  "opacity": Number, //Between 0 and 1, the new opacity of the character
  "time": Number, //Time in milliseconds the transition takes
  "speechAlsoFades": Boolean //Whether the speech box fades with the character
}
```

For `scale`:

```json
{
  "type": "scale",
  "target": Number, //The index of the character to scale
  "scale": Number, //The font-size to scale to
  "time": Number //How long in milliseconds the resizing takes
}
```

For `shake`:

```json
{
  "type": "shake",
  "target": Number, //The index of the character to shake
  "character": Boolean, //Whether the sprite shakes
  "speech": Boolean, //Whether the speech box shakes
  "amount": Number, //"amount" to shake (no particular unit)
  "time": Number //Time in milliseconds to shake for
}
```

For `js`:

```json
{
  "type": "js",
  "run": Function //Runs a JavaScript function at this point in time
}
```

## `commonfunctions.mjs`

`modules/commonfunctions.mjs` exports an object that defines common functions used in Micro code. They are the following:

### `util.animateAttr(element, attribute, endAmount, duration, callback)`

The parameters are self-explanatory. This animates a numerical attribute (i.e. in SVG).
It is used internally by the dialogue animation API.

### `util.loot(table, rolls)`

Processes a loot table (see Loot Tables section). The number of 'rolls' is how many items will be drawn.

### `util.numberToCircles(number)`

Converts a number to quarter-circles (i.e. 7 is ●◕)

### `util.numberToTriangles(number)`

Converts a number to triangles (i.e. 7 is ►►►►►►►)

### `util.numberToCooldown(number)`

Simply converts a number to a cooldown time used in combat. (i.e. 7 is ▨▨▨▨▨▨▨)

NOTE: while in combat, these are used in intervals of 100 milliseconds for dodging and 500 milliseconds for healing cooldowns, **if you write numberToCooldown(100) you will get 100 squares.**

These situations call it like `util.numberToCooldown(dodgeCooldown/100)`.

### `util.replaceTile(x, y, char, world)`

Replaces a tile in the `world` at `x`, `y` with `char` on both the map and gameworld.

### `util.stringReplaceAt(string, index, replacement)`

Replaces a certain character in a string with a `replacement`. Used internally by `util.replaceTile`

## Music

Music was added in the Hustle and Bustle update, in beta 0.0.3.1.

To use music, first

```javascript
import music from './music.mjs'
```

Then, you can use `music.soundtracks.mycoolsoundtrack.start()` to start playing a soundtrack. The others will automatically stop playing.

To define a soundtrack, go into `modules/music.mjs` and follow this format: 

```javascript
window.music.soundtracks.mycoolsoundtrack = new Soundtrack([
  //Song Name One
  new Howl({
    src: ['https://cdn.glitch.global/e78bfab2-2ff2-4853-bc78-2a1f4fd1f0ab/some_song_url.mp3']
  }),
  //Song Name Two
  new Howl({
    src: ['https://cdn.glitch.global/e78bfab2-2ff2-4853-bc78-2a1f4fd1f0ab/some_song_url.mp3']
  })
]);
```

You will notice Micro uses the Howler.js library.

### Sequencing

If you want a vibe to be continued, use the next function.

Let's say a soundtrack is playing during a cutscene, and after the cutscene you want it to keep playing until it ends, and then play another soundtrack.

To do that, call `music.soundtracks.mycoolsoundtrack.next('myothersoundtrack')`.

`music.soundtracks.myothersoundtrack` will be started after the current song in `mycoolsoundtrack` finishes.