extends Node2D

var fund_drop: int = 0
var enemy_scale = 20.

const fund_coin: PackedScene = preload("res://misc/effects/FundCoin.tscn")

func _ready():
	$Render.scale = Vector2(enemy_scale,enemy_scale)
	while fund_drop > 0:
		var coin := fund_coin.instantiate()
		coin.position = position
		coin.amount = ceil(fund_drop/8.)
		coin.delay = randf_range(0., 0.25)
		add_sibling(coin)
		fund_drop -= ceil(fund_drop/8.)
		await Micro.wait(0.1)
	$ExplosionParticles.emitting = false
	$FundParticles.emitting = false
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).tween_property($Render, "scale", Vector2(enemy_scale*2,enemy_scale*2), .5)
	tween.parallel().tween_property($Render, "modulate", Color.TRANSPARENT, .5)
	tween.tween_interval(.5)
	tween.finished.connect(queue_free)
