class_name HomingBullet extends TelegraphedBullet

var home_rate := 1.

func _physics_process(delta):
	if shot:
		aim_vec = aim_vec.move_toward(global_position.direction_to(Micro.player.global_position), delta*home_rate)
		aim_angle = aim_vec.angle()
		global_position += aim_vec * speed * delta
		speed += acceleration * delta
	else:
		global_position = get_aim_position()
	rotation = aim_angle - PI/2
