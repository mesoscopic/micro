extends StaticBody2D

var upgrade: Upgrade

func put_upgrade(new_upgrade: Upgrade) -> void:
	if upgrade:
		upgrade.disable()
	upgrade = new_upgrade
	upgrade.enable()
	$Render.material = new_upgrade.render
	$PutParticles.emitting = true
	await Micro.wait(1.)
	get_parent().deactivate()

func _on_mouse_entered() -> void:
	if get_parent().purchased_upgrade:
		$Selection.show()
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_mouse_exited() -> void:
	$Selection.hide()
	if get_parent().purchased_upgrade:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if get_parent().purchased_upgrade and event.is_action("shoot"):
		put_upgrade(get_parent().purchased_upgrade)
		get_parent().purchased_upgrade = null
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
