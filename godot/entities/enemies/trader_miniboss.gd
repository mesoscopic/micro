extends Enemy

const BULLET = preload("res://bullets/TelegraphedBullet.tscn")
const SPAWNER = preload("res://bullets/SpawnerProjectile.tscn")
const BOMB = preload("res://bullets/Bomb.tscn")
const LASER = preload("res://bullets/Laser.tscn")
const HOMING_BULLET = preload("res://bullets/HomingBullet.tscn")

var phase: int = 0
var shots: int
var even_shot := false
var prepared_bullets: Array[TelegraphedBullet] = []
var spiral_angle: float = 0.
var bombs: Array[BombBullet] = []
var lasers: Array[LaserBullet] = []
var doing_homing_attack := false

func _ready() -> void:
	super()
	shots = (Micro.world.random.randi_range(3,5) if Micro.world.second_trader_miniboss else Micro.world.random.randi_range(1,3)) * 2
	if Micro.world.second_trader_miniboss:
		fund_drop += 50
		max_hp += 400
		hp += 400

func _physics_process(_delta: float) -> void:
	super(_delta)
	if $Shield.is_stopped():
		for bullet in prepared_bullets:
			bullet.aim(get_angle_to(Micro.player.global_position))

func _hurt(amount: int, direction: float) -> void:
	super(amount, direction)
	if phase == 0 and hp <= max_hp*0.75:
		phase += 1
		$Shield.start()
		$ShieldEffect.emitting = true
		invincible = true
		
	if phase == 1 and hp <= max_hp*0.5:
		phase += 1
		if Micro.world.second_trader_miniboss:
			spawn()
		else:
			$Shield.start()
			$ShieldEffect.emitting = true
			invincible = true
	if phase == 2 and hp <= max_hp*0.25:
		phase += 1
		spawn()

func spawn() -> void:
	var summon = preload("res://bullets/SpawnerProjectile.tscn").instantiate()
	summon.position = position
	summon.target = Micro.player.global_position
	summon.time = 3.
	summon.spawn = preload("res://entities/enemies/Turret.tscn")
	Micro.world.get_node("Bullets").add_child(summon)

func _die() -> void:
	var trader = preload("res://entities/Trader.tscn").instantiate()
	trader.position = position
	call_deferred("add_sibling", trader)
	super()
	for laser in lasers:
		laser.stop()
	Micro.world.second_trader_miniboss = true

func do_despawn() -> void:
	invincible = true
	$Attack.stop()
	for laser in lasers:
		laser.stop()
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($Render.material, "shader_parameter/health", 1., 0.5)
	await tween.finished
	despawn.emit()
	queue_free()

func fire() -> void:
	for bullet in prepared_bullets:
		bullet.fire()
	prepared_bullets = []
	if doing_homing_attack:
		doing_homing_attack = false
		$Attack.start(2.)
		return
	if !$Shield.is_stopped():
		for i in range(0,8):
			var bullet: TelegraphedBullet = BULLET.instantiate()
			bullet.shooter = self
			bullet.angle_offset = i*PI/3
			bullet.aim(spiral_angle)
			bullet.distance = 35
			bullet.speed = 80
			bullet.lifetime = 2.
			bullet.damage = 15
			Micro.world.get_node("Bullets").add_child(bullet)
			prepared_bullets.append(bullet)
		if Micro.world.second_trader_miniboss and $Shield.time_left <= 5.:
			spiral_angle -= PI/60
		else:
			spiral_angle += PI/60
		$Attack.start(0.1)
	elif shots > 0:
		# Normal attack
		shots -= 1
		if even_shot:
			for i in range(-3,3):
				var bullet: TelegraphedBullet = BULLET.instantiate()
				bullet.shooter = self
				bullet.angle_offset = i*PI/9 + PI/18
				bullet.aim(get_angle_to(Micro.player.global_position))
				bullet.distance = 35
				bullet.speed = 100
				bullet.lifetime = 2.
				bullet.damage = 15
				Micro.world.get_node("Bullets").add_child(bullet)
				prepared_bullets.append(bullet)
		else:
			for i in range(-2,3):
				var bullet: TelegraphedBullet = BULLET.instantiate()
				bullet.shooter = self
				bullet.angle_offset = i*PI/9
				bullet.aim(get_angle_to(Micro.player.global_position))
				bullet.distance = 35
				bullet.speed = 100
				bullet.lifetime = 2.
				bullet.damage = 15
				Micro.world.get_node("Bullets").add_child(bullet)
				prepared_bullets.append(bullet)
		even_shot = !even_shot
		$Attack.start(.5)
	else:
		# Special attack
		match randi_range(0,1):
			0:
				if hp <= max_hp*0.5:
					shots = (Micro.world.random.randi_range(3,5) if Micro.world.second_trader_miniboss else Micro.world.random.randi_range(1,3)) * 2
					for i in range(0,8):
						var bullet: TelegraphedBullet = BOMB.instantiate()
						bullet.shooter = self
						bullet.angle_offset = i*PI/4
						bullet.aim(0)
						bullet.distance = 40
						bullet.speed = 150
						bullet.scale = Vector2(2,2)
						bullet.lifetime = 1.
						bullet.damage = 30
						bullet.split_number = 8
						bullet.split_lifetime = 1.75
						Micro.world.get_node("Bullets").call_deferred("add_child", bullet)
						bombs.append(bullet)
					await Micro.wait(0.75)
					for b in bombs:
						b.fire()
					bombs = []
					$Attack.start(3.)
				else:
					shots = Micro.world.random.randi_range(1,3) * 2
					var laser = LASER.instantiate()
					laser.damage = 25
					laser.lifetime = 1.
					laser.rotation = get_angle_to(Micro.player.global_position)
					laser.position = position
					laser.length = 300
					Micro.world.get_node("Bullets").add_child(laser)
					lasers.append(laser)
					await Micro.wait(.5 if Micro.world.second_trader_miniboss else 1.)
					laser.fire()
					lasers = []
					fire()
					$Attack.start(1.)
			1:
				shots = (Micro.world.random.randi_range(3,5) if Micro.world.second_trader_miniboss else Micro.world.random.randi_range(1,3)) * 2
				for i in range(-2,3):
					var bullet: TelegraphedBullet = HOMING_BULLET.instantiate()
					bullet.shooter = self
					bullet.angle_offset = i*PI/9
					bullet.aim(get_angle_to(Micro.player.global_position))
					bullet.distance = 35
					bullet.speed = 50
					bullet.lifetime = 3.
					bullet.damage = 15
					bullet.scale = Vector2(1.5,1.5)
					Micro.world.get_node("Bullets").add_child(bullet)
					prepared_bullets.append(bullet)
				doing_homing_attack = true
				$Attack.start(.5)

func _on_shield_timeout() -> void:
	$ShieldEffect.emitting = false
	invincible = false
