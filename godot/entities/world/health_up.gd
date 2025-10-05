extends Node2D

func _on_pickup_body_entered(body: Node2D) -> void:
	if body != Micro.player: return
	$Pickup.set_deferred("monitoring", false)
	Micro.player.movement_disabled = true
	$Pulse.emitting = false
	$Health.emitting = false
	var actual_max = Micro.player.max_hp
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).tween_property(Micro.player, "global_position", global_position, .15)
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).tween_property(Micro.player.get_node("Render"), "scale", Vector2(40, 40), 1.5)
	tween.parallel().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).tween_property(Micro.player, "max_hp", Micro.player.max_hp * 1.5, 1.5)
	tween.tween_interval(.5)
	await tween.finished
	if Micro.get_setting("photosensitive_mode") == 0: $Absorb.emitting = true
	while Micro.player.hp < Micro.player.max_hp:
		Micro.player.heal(1)
		await Micro.wait(.025)
	$Absorb.emitting = false
	await Micro.wait(.5)
	Micro.player.max_hp = actual_max + 20
	Micro.player.hp = Micro.player.max_hp
	$Render.hide()
	$Burst.restart()
	var tween_b := get_tree().create_tween()
	tween_b.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(Micro.player.get_node("Render"), "scale", Vector2(20, 20), .2)
	if Micro.get_setting("photosensitive_mode") == 0:
		tween_b.parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).tween_property($FinalPulse, "scale", Vector2(1000, 1000), .5)
		tween_b.parallel().tween_property($FinalPulse, "modulate", Color.TRANSPARENT, .5)
	await tween_b.finished
	Micro.player.movement_disabled = false
	await Micro.wait(3.)
	queue_free()
