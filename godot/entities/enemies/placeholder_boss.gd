extends Enemy

func _die():
	super()
	Micro.world.bosses_down += 1
