extends EnemyDeath

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
	$ExplosionParticles.emitting = false
	$Render.hide()
	$Boom.restart()
	await Micro.wait(0.25)
	$ExplosionParticles.emitting = false
	
	if Micro.get_setting("photosensitive_mode") == 0:
		var tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).tween_property($FinalPulse, "scale", Vector2(1000, 1000), .5)
		tween.parallel().tween_property($FinalPulse, "modulate", Color.TRANSPARENT, .5)
	if extra_reward: await extra_reward.call(global_position)
	await Micro.wait(2.)
	queue_free()
