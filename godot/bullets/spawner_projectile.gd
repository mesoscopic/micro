extends Node2D

var spawn: PackedScene
var target: Vector2
var time: float

var spiral_radius: float = 30.
var spiral_angle: float = 0.

func _ready() -> void:
	create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).tween_property(self, "global_position", target, time)
	create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC).tween_property(self, "spiral_radius", 0., time)
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).tween_property(self, "spiral_angle", 4.*time*PI, time)
	$Expiry.start(time)

func _process(_delta: float) -> void:
	$Bubbles.position = Vector2(spiral_radius*cos(spiral_angle), spiral_radius*sin(spiral_angle))

func _on_expiry_timeout() -> void:
	var enemy = spawn.instantiate()
	enemy.position = position
	Micro.world.get_node("Entities").add_child(enemy)
	$Bubbles.emitting = false
	$ExplosionParticles.emitting = true
	await Micro.wait(1.)
	queue_free()
