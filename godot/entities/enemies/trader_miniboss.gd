extends Enemy

const BULLET = preload("res://bullets/TelegraphedBullet.tscn")
const SPAWNER = preload("res://bullets/SpawnerProjectile.tscn")
const LASER = preload("res://bullets/Laser.tscn")
const BOMB = preload("res://bullets/Bomb.tscn")
const HOMING_BULLET = preload("res://bullets/HomingBullet.tscn")

var shots: int
var even_shot := false
var prepared_bullets: Array[TelegraphedBullet] = []
var spiral_angle: float = 0.
var lasers: Array[LaserBullet] = []
var bombs: Array[BombBullet] = []
var doing_homing_attack := false
var special: int = 0

func _ready() -> void:
	super()
	extra_reward = func(pos):
		var trader = preload("res://entities/Trader.tscn").instantiate()
		trader.position = pos
		Micro.world.get_node("Entities").call_deferred("add_child", trader)
		trader.collect()
		await Micro.wait(1.)
	shots = (3 if Micro.world.second_trader_miniboss else 6)
	if Micro.world.second_trader_miniboss:
		fund_drop += 50
		max_hp += 400
		hp += 400

func _physics_process(_delta: float) -> void:
	super(_delta)
	for bullet in prepared_bullets:
		bullet.aim(get_angle_to(Micro.player.global_position))

func spawn() -> void:
	var summon = preload("res://bullets/SpawnerProjectile.tscn").instantiate()
	summon.position = position
	summon.target = Micro.player.global_position
	summon.time = 3.
	summon.spawn = preload("res://entities/enemies/Turret.tscn")
	Micro.world.get_node("Bullets").add_child(summon)

func _die() -> void:
	super()
	for laser in lasers:
		if laser: laser.stop()
	for bomb in bombs:
		if bomb: bomb.fire()
	Micro.world.second_trader_miniboss = true

func do_despawn() -> void:
	invincible = true
	$Attack.stop()
	for laser in lasers:
		if laser: laser.stop()
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
		$Attack.start(1.)
		return
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
				bullet.damage = 10
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
				bullet.damage = 10
				Micro.world.get_node("Bullets").add_child(bullet)
				prepared_bullets.append(bullet)
		even_shot = !even_shot
		$Attack.start(.5)
	else:
		# Special attack
		match special:
			0:
				# lasers
				if hp <= max_hp*0.5:
					shots = Micro.world.random.randi_range(1,3)
					for i in range(-2, 3):
						var laser = LASER.instantiate()
						laser.damage = 20
						laser.lifetime = 1.
						laser.rotation = get_angle_to(Micro.player.global_position) + i*PI/8
						laser.position = position
						laser.length = 200
						Micro.world.get_node("Bullets").add_child(laser)
						lasers.append(laser)
					await Micro.wait(.5 if Micro.world.second_trader_miniboss else 1.)
					for laser in lasers:
						if laser: laser.fire()
					lasers = []
					$Attack.start(1.5)
				else:
					shots = Micro.world.random.randi_range(2,5)
					var laser = LASER.instantiate()
					laser.damage = 20
					laser.lifetime = 1.
					laser.rotation = get_angle_to(Micro.player.global_position)
					laser.position = position
					laser.length = 200
					Micro.world.get_node("Bullets").add_child(laser)
					lasers.append(laser)
					await Micro.wait(.5 if Micro.world.second_trader_miniboss else 1.)
					if laser: laser.fire()
					lasers = []
					$Attack.start(1.)
			1:
				# homing
				shots = Micro.world.random.randi_range(4,6)
				for i in range(-2,3):
					var bullet: TelegraphedBullet = HOMING_BULLET.instantiate()
					bullet.shooter = self
					bullet.angle_offset = i*PI/6
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
			2:
				# bombs
				if hp <= max_hp*0.5:
					shots = (Micro.world.random.randi_range(2,4) if Micro.world.second_trader_miniboss else Micro.world.random.randi_range(4,6))
					for i in range(0,4):
						var bomb: BombBullet = BOMB.instantiate()
						var aim := Vector2.from_angle(PI/2.*i)
						bomb.position = position + aim*140.
						bomb.origin = global_position + aim*35.
						bomb.spin = randf_range(0.,2.*PI)
						bomb.split_speed = 150.
						bomb.split_lifetime = 1.5
						bombs.append(bomb)
						Micro.world.get_node("Bullets").add_child(bomb)
					await Micro.wait(1. if Micro.world.second_trader_miniboss else 1.5)
					for bomb in bombs:
						bomb.fire()
					bombs = []
					$Attack.start(1.)
				else:
					shots = Micro.world.random.randi_range(2,3)
					for i in 4:
						var bomb: BombBullet = BOMB.instantiate()
						bomb.position = Micro.player.position
						bomb.origin = global_position.move_toward(Micro.player.position, 35)
						bomb.split_number = 6 if Micro.world.second_trader_miniboss else 4
						bomb.spin = randf_range(0., 2.*PI)
						bomb.fire_in(1.)
						Micro.world.get_node("Bullets").add_child(bomb)
						await Micro.wait(.5)
					$Attack.start(1.)
		special = (special + 1) % 3

func _on_shield_timeout() -> void:
	$ShieldEffect.emitting = false
	invincible = false
