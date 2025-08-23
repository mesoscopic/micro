class_name NestSlot extends Node2D

var upgrade: Upgrade

func put_upgrade(new_upgrade: Upgrade) -> void:
	if upgrade:
		upgrade.disable()
		Upgrade.remove(upgrade.title)
	upgrade = new_upgrade
	upgrade.enable()
	Upgrade.add(upgrade.title)
	$Render.material = new_upgrade.render
	$PutParticles.emitting = true
	Micro.world.upgrade_purchased.emit()

func select() -> void:
	$Selection.show()

func deselect() -> void:
	$Selection.hide()
