class_name HomingBullet extends TelegraphedBullet

func _physics_process(delta):
	if shot:
		aim_vec = aim_vec.move_toward(global_position.direction_to(Micro.player.global_position), delta)
		aim_angle = aim_vec.angle()
		global_position += aim_vec * speed * delta
	else:
		global_position = get_aim_position()
	rotation = aim_angle - PI/2
