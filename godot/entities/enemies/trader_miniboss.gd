extends Enemy

const BULLET = preload("res://bullets/TelegraphedBullet.tscn")
const SPAWNER = preload("res://bullets/SpawnerProjectile.tscn")
const LASER = preload("res://bullets/Laser.tscn")
const BOMB = preload("res://bullets/Bomb.tscn")
const HOMING_BULLET = preload("res://bullets/HomingBullet.tscn")

var active := false

var shots: int
var even_shot := false
var prepared_bullets: Array[TelegraphedBullet] = []
var spiral_angle: float = 0.
var lasers: Array[LaserBullet] = []
var doing_homing_attack := false
var special: int = 0

@export var shake_noise: FastNoiseLite
var shake_time := 0.

func _hurt(_amount: int, _direction: float) -> void:
	if !active:
		hp = max_hp
		if global_position.distance_squared_to(Micro.player.position) < 25600:
			active = true
			$Attack.start(0.25)
			$ActivateParticles.restart()

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
		fund_drop += 100
		max_hp += 200
		hp += 200

func _physics_process(_delta: float) -> void:
	super(_delta)
	if active:
		for bullet in prepared_bullets:
			bullet.aim(get_angle_to(Micro.player.global_position))

func _process(delta: float) -> void:
	shake_time += delta
	var shake := Vector2(shake_noise.get_noise_2d(shake_time, 0.), shake_noise.get_noise_2d(0., shake_time))
	if active:
		$Render.position = shake*(8.-5.*hp/max_hp)
	else:
		$Render.position = Vector2.ZERO

func _die() -> void:
	invincible = true
	$Attack.stop()
	active = false
	$Render/AuraEffect.emitting = false
	for laser in lasers:
		if laser: laser.stop()
	await Micro.wait(0.5)
	Micro.world.second_trader_miniboss = true
	super()

func fire() -> void:
	for bullet in prepared_bullets:
		bullet.fire()
	prepared_bullets = []
	if shots > 0:
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
		$Attack.start(.25+hp/float(max_hp)/2.)
	else:
		# Special attack
		match special:
			0:
				# lasers
				shots = Micro.world.random.randi_range(1,3)
				for i in range(-1, 2):
					var laser = LASER.instantiate()
					laser.damage = 15
					laser.lifetime = 1.
					laser.rotation = get_angle_to(Micro.player.global_position) + i*PI/(8. if Micro.world.second_trader_miniboss else 6.)
					laser.position = position
					var space_state = get_world_2d().direct_space_state
					var direction = Vector2.from_angle(laser.rotation) * 300. + global_position
					var query = PhysicsRayQueryParameters2D.create(global_position, direction)
					query.collision_mask = 17
					query.exclude = [Micro.player]
					var result = space_state.intersect_ray(query)
					
					if result:
						laser.length = global_position.distance_to(result.position)
					else:
						laser.length = 300.
					Micro.world.get_node("Bullets").add_child(laser)
					lasers.append(laser)
				await Micro.wait(.5+hp/float(max_hp))
				if check_line_of_sight(): return
				for laser in lasers:
					if laser: laser.fire()
				lasers = []
				$Attack.start(1.)
			1 when Micro.world.second_trader_miniboss:
				# surprises
				shots = Micro.world.random.randi_range(4,6)
				for i in range(3):
					var bullet: Spawner = SPAWNER.instantiate()
					bullet.position = global_position
					bullet.spawn = preload("res://entities/enemies/Surprise.tscn")
					bullet.target = global_position + Vector2(Micro.world.random.randf_range(-100, 100),Micro.world.random.randf_range(-100, 100))
					bullet.time = 1.
					Micro.world.get_node("Bullets").add_child(bullet)
					await Micro.wait(hp/float(max_hp))
				$Attack.start(1.5)
			1:
				# homing
				shots = Micro.world.random.randi_range(4,6)
				for i in range(-2,3):
					var bullet: TelegraphedBullet = HOMING_BULLET.instantiate()
					bullet.shooter = self
					bullet.angle_offset = i*PI/8
					bullet.aim(get_angle_to(Micro.player.global_position))
					bullet.distance = 35
					bullet.speed = 150.
					bullet.acceleration = -50.
					bullet.home_rate = 0.5
					bullet.lifetime = 3.
					bullet.damage = 15
					bullet.scale = Vector2(1.5,1.5)
					Micro.world.get_node("Bullets").add_child(bullet)
					prepared_bullets.append(bullet)
				doing_homing_attack = true
				await Micro.wait(.5)
				if check_line_of_sight(): return
				for bullet in prepared_bullets:
					if bullet: bullet.fire()
				prepared_bullets = []
				$Attack.start(1.)
			2:
				# bombs
				shots = Micro.world.random.randi_range(2,3)
				for i in 4:
					if check_line_of_sight(): return
					var bomb: BombBullet = BOMB.instantiate()
					bomb.position = Micro.player.position
					bomb.origin = global_position.move_toward(Micro.player.position, 35)
					bomb.split_number = 6 if Micro.world.second_trader_miniboss else 4
					bomb.spin = randf_range(0., 2.*PI)
					bomb.fire_in(.5+hp/float(max_hp))
					Micro.world.get_node("Bullets").add_child(bomb)
					await Micro.wait(.5)
				$Attack.start(.5+hp/float(max_hp))
		special = (special + 1) % 3
	check_line_of_sight()

func check_line_of_sight() -> bool:
	var query = PhysicsRayQueryParameters2D.create(global_position, Micro.player.position, 17)
	var result := get_world_2d().direct_space_state.intersect_ray(query)
	if !result.is_empty() and result.collider != Micro.player:
		$Attack.stop()
		active = false
		hp = max_hp
		for laser in lasers:
			if laser: laser.stop()
		for bullet in prepared_bullets:
			if bullet: bullet._on_expire()
		prepared_bullets = []
		lasers = []
		return true
	return false
