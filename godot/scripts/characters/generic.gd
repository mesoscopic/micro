extends Node2D
class_name Character

## The layer this character is in. Characters occlude those in lower layers.
@export_enum("Background tile", "Foreground tile", "Moving entity", "Item", "Player") var layer: int
## The size of this character in units. 20 units is 1 tile.
@export var size: int = 20
## The size of this character's light in units. 20 units is 1 tile.
@export var light: int = 0:
	set(new_light):
		light = new_light
		if light == 0:
			$Light/Area.set_deferred("disabled", true)
		else:
			$Light/Area.set_deferred("disabled", false)
			$Light/Area.set_scale(Vector2(light, light))
## The ShaderMaterial used to render this character.
@export var render: ShaderMaterial
## If this entity should always be faintly visible when on screen.
@export var always_visible: bool = false
## If the light emitted from this entity should be dimmer and more even.
@export var ambient_light: bool = false

var alpha_base: float = 1.0
var light_multiplier: float = 0.0

# add any logic common to all characters here
func _ready():
	if render: 
		$Render.material = render.duplicate();
		$Render.scale = Vector2(size, size);
	process_priority = layer
	$Occlusion/Area.shape.radius = float(size)/2.0
	if light == 0:
		$Light/Area.disabled = true
	else:
		$Light/Area.disabled = false
		$Light/Area.set_scale(Vector2(light, light))


func _physics_process(_delta):
	if $Render.material: $Render.material.set("shader_parameter/opacity", alpha_base * max(light_multiplier, 0.1 if always_visible else 0.))
	alpha_base = 1.0
	light_multiplier = float(light)/50. if light < 50 else 1.0
	if layer != 0:
		for area in $Occlusion.get_overlapping_areas():
			var c = area.get_parent()
			if c.layer < layer:
				var a: float = c.alpha_base
				var n: float = sqrt((global_position[0] - c.global_position[0])**2 + (global_position[1] - c.global_position[1])**2)/float(size)	
				if n < a: c.alpha_base = n
	if light > 0:
		for area in $Light.get_overlapping_areas():
			var c = area.get_parent()
			if c == self: continue
			var strength: float
			if ambient_light:
				strength = 0.3*smoothstep(1.0, 0.7, (abs(global_position[0]-c.global_position[0])+abs(global_position[1]-c.global_position[1]))/float(light))
			else:
				strength = 1.0-((abs(global_position[0]-c.global_position[0])+abs(global_position[1]-c.global_position[1]))/float(light))
			if strength > 0: c.light_multiplier = min(1.0, c.light_multiplier+strength)
