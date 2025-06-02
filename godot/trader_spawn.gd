extends Node2D

const TRADER = preload("res://scenes/characters/Trader.tscn")

func _ready() -> void:
	#var light_anim = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).tween_property($Character, "light", 80, 0.5)
	await Micro.wait(0.5) #await light_anim.finished
	var charge_anim = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).tween_property(self, "position", position+position.normalized()*60., 1.)
	await charge_anim.finished
	$SpeedParticles.emitting = true
	var move_anim = create_tween().tween_property(self, "position", position.normalized()*160., (position.length()-160.)/500.)
	await move_anim.finished
	$SpeedParticles.emitting = false
	var trader = TRADER.instantiate()
	trader.position = position
	add_sibling(trader)
	Micro.world.refresh_trades.emit()
	$Render.hide()
	await Micro.wait(1.)
	queue_free()
