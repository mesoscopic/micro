class_name EnemyDeath extends Node2D

@export var reward: int = 0
@export var enemy_scale := 20.
@export var extra_reward: Callable

func _ready():
	$Render.scale = Vector2(enemy_scale,enemy_scale)
	while reward > 0:
		var coin := Micro.new(&"micro:coin")
		coin.position = position
		coin.amount = ceil(reward/8.)
		coin.delay = randf_range(0., 0.25)
		add_sibling(coin)
		reward -= ceil(reward/8.)
	await Micro.wait(0.25)
	if extra_reward: await extra_reward.call(global_position)
	$ExplosionParticles.emitting = false
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).tween_property($Render, "scale", Vector2(enemy_scale*2,enemy_scale*2), .5)
	tween.parallel().tween_property($Render, "modulate", Color.TRANSPARENT, .5)
	tween.tween_interval(.5)
	tween.finished.connect(queue_free)
