extends Enemy

const BULLET = preload("res://scenes/bullets/EnemyBullet.tscn")
const SPAWNER = preload("res://scenes/bullets/SpawnerProjectile.tscn")
var next_phase_hp: int
var phase: int = 1

var circle_density: int = 4
var spiral: bool = false
var spiral_angle: float = 0.

func _ready() -> void:
	DEATH_ANIMATION = preload("res://scenes/fx/TraderMinibossDeathAnimation.tscn")
	super()
	fund_drop += 10 * Micro.world.trader_minibosses_fought
	max_hp += 150 * Micro.world.trader_minibosses_fought
	hp += 150 * Micro.world.trader_minibosses_fought
	next_phase_hp = max_hp - 150
	phase_setup()

func _hurt(amount: int) -> void:
	super(amount)
	if phase == 3:
		_on_fire()
	if hp <= next_phase_hp and next_phase_hp > 0:
		next_phase_hp -= 150
		phase += 1
		phase_setup()

func _die() -> void:
	super()
	Micro.world.trader_minibosses_fought += 1

func do_despawn() -> void:
	invincible = true
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Character, "light", 0, 0.5)
	tween.parallel().tween_property($Character/Render.material, "shader_parameter/health", 1., 0.5)
	await tween.finished
	despawn.emit()
	queue_free()

func phase_setup():
	match phase:
		1:
			$FireRate.start(0.5)
		2:
			$FireRate.start(1.8)
			for i in range(0,4):
				var angle = PI/4.*(2*i+1)
				var bullet = SPAWNER.instantiate()
				bullet.position = position
				bullet.target = global_position + Vector2.from_angle(angle)*140.
				bullet.time = 1.+i/2.
				bullet.spawn = preload("res://scenes/characters/enemies/Turret.tscn")
				add_sibling(bullet)
		3:
			$FireRate.stop()
			for i in range(0,2):
				var angle := randf()*2.*PI
				var bullet = SPAWNER.instantiate()
				bullet.position = position
				bullet.target = global_position + Vector2.from_angle(angle)*100.
				bullet.time = 2.*i
				bullet.spawn = preload("res://scenes/characters/enemies/Teleporter.tscn")
				add_sibling(bullet)
		4:
			circle_density = 6
			spiral = true
			$FireRate.start(0.5)
		5:
			circle_density = 4
			spiral = false
			$FireRate.start(1.)
			for i in range(0,3):
				var angle := 2*i+1
				var bullet = SPAWNER.instantiate()
				bullet.position = position
				bullet.target = global_position + Vector2.from_angle(angle)*140.
				bullet.time = i
				bullet.spawn = preload("res://scenes/characters/enemies/AdvancedShooter.tscn")
				add_sibling(bullet)

func _on_fire() -> void:
	var aim := (spiral_angle if spiral else randf())
	if spiral: spiral_angle += PI/18.
	for i in range(0,circle_density*2):
		var angle = aim+PI/circle_density*i
		var bullet = BULLET.instantiate()
		bullet.global_position = global_position
		bullet.velocity = Vector2.from_angle(angle) * 50.
		bullet.lifetime = 5.
		bullet.damage = 6
		get_tree().current_scene.get_node("Game/World").call_deferred("add_child", bullet)
