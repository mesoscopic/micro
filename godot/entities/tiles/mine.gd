class_name Mine extends Damageable

func _ready():
	super()
	hurt.connect(_hurt)

func _physics_process(_delta):
	tick()

func _hurt(_amount, _direction):
	$Flash.restart()
	invincible = true
	$Render.set_instance_shader_parameter("recharging", true)
	$Charging.emitting = true
	$Recharge.start()
	
	for angle in Vector3(PI/float(6), 2.*PI, 2.*PI/float(6)):
		var bullet: MineBullet = preload("res://bullets/MineBullet.tscn").instantiate()
		bullet.velocity = Vector2.from_angle(angle) * 150
		bullet.position = global_position
		bullet.damage = 10
		bullet.lifetime = 2
		Micro.world.get_node("Bullets").call_deferred("add_child", bullet)

func _on_recharge_timeout() -> void:
	invincible = false
	$Render.set_instance_shader_parameter("recharging", false)
	$Charging.emitting = false
	$Charged.restart()
