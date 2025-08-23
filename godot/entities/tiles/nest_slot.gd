class_name NestSlot extends Node2D

var upgrade: Upgrade

func _ready() -> void:
	if upgrade:
		upgrade.enable()
		$Render.material = upgrade.render

func put_upgrade(new_upgrade: Upgrade) -> void:
	if upgrade:
		upgrade.disable()
	upgrade = new_upgrade
	upgrade.enable()
	$Render.material = new_upgrade.render
	$PutParticles.emitting = true
	Micro.world.upgrade_purchased.emit()

func select() -> void:
	$Selection.show()

func deselect() -> void:
	$Selection.hide()
