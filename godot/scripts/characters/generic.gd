extends Node2D
class_name Character

@export_enum("Background tile", "Foreground tile", "Moving entity", "Particle", "Player") var layer: int
@export var size: int = 20
@export var light: int = 0
@export var render: ShaderMaterial
@export var always_visible: bool = false

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
		$Light/Area.apply_scale(Vector2(light, light))


func _physics_process(_delta):
	alpha_base = 1.0
	light_multiplier = 0.0 if light == 0 else 1.0
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
			var strength = 1.0-((abs(global_position[0]-c.global_position[0])+abs(global_position[1]-c.global_position[1]))/float(light))
			if strength > 0: c.light_multiplier = min(1.0, c.light_multiplier+strength)

func _process(_delta):
	if $Render.material: $Render.material.set("shader_parameter/opacity", alpha_base * max(light_multiplier, 0.1 if always_visible else 0.))
