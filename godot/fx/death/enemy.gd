class_name EnemyDeath extends Node2D

@export var fund_drop: int = 0
@export var orb_drop: int = 0
@export var enemy_scale := 20.
@export var extra_reward: Callable

const heal_orb: PackedScene = preload("res://misc/effects/HealOrb.tscn")

func _ready():
	$Render.scale = Vector2(enemy_scale,enemy_scale)
	while fund_drop > 0:
		var coin = Micro.new(&"micro:fund_coin")
		coin.position = position
		coin.amount = ceil(fund_drop/8.)
		coin.delay = randf_range(0., 0.25)
		add_sibling(coin)
		fund_drop -= ceil(fund_drop/8.)
	await Micro.wait(0.25)
	$FundParticles.emitting = false
	while orb_drop > 0:
		var orb := heal_orb.instantiate()
		orb.position = global_position
		orb.distance = randf_range(20.,50.)
		add_sibling(orb)
		orb_drop -= 1
	if extra_reward: await extra_reward.call(global_position)
	$ExplosionParticles.emitting = false
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).tween_property($Render, "scale", Vector2(enemy_scale*2,enemy_scale*2), .5)
	tween.parallel().tween_property($Render, "modulate", Color.TRANSPARENT, .5)
	tween.tween_interval(.5)
	tween.finished.connect(queue_free)
