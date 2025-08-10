extends Node2D

func _ready():
	$Guide.rotation = get_angle_to(Vector2.ZERO)
	$Trail.rotation = get_angle_to(Vector2.ZERO)

func _on_toll_chosen() -> void:
	$Guide.emitting = true

func _on_toll_unchosen() -> void:
	$Guide.emitting = false

func _on_toll_paid() -> void:
	await Micro.wait(1.)
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).tween_property(Micro.player, "global_position", global_position, 1.)
	await tween.finished
	Micro.player.get_node("Render").hide()
	$Boom.restart()
	$Trail.restart()
	await Micro.wait(1.)
	await Micro.screen_wipe_out()
	Micro.player.get_node("Render").show()
	Micro.player.position = Vector2.ZERO
	Micro.screen_wipe_in()
	Micro.player.movement_disabled = false
