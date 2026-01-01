extends Node2D

@export var distance: float
@export var amount := 5
var seeking := false
var tween: Tween

func _ready() -> void:
	var scale_variation = randf_range(-1., 1.);
	scale = Vector2(1.+(amount+scale_variation)*.2, 1.+(amount+scale_variation)*.2)
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", position+Vector2.from_angle(randf_range(0.,2.*PI))*distance, 0.5)
	tween.tween_callback(func ():
		$TravelParticles.emitting = false
		seeking = true
	)
	$Render.set_instance_shader_parameter("offset", randf_range(0., 5.))

func _physics_process(delta: float) -> void:
	if seeking:
		if position.distance_squared_to(Micro.player.position) < 40.:
			Micro.player.heal(amount)
			burst()
		elif position.distance_squared_to(Micro.player.position) < 14400.:
			var difference := (Micro.player.position - position)
			var travel := difference.normalized() * delta * 115200./difference.length_squared()
			if difference.length_squared() < travel.length_squared():
				position += difference
			else:
				position += travel

func burst() -> void:
	seeking = false
	$Render.hide()
	$HealParticles.restart()
	$Lifetime.stop()
	$Warning.stop()
	await Micro.wait(0.25)
	queue_free()

func warning() -> void:
	$Warning.start()
	$WarningParticles.emitting = true
