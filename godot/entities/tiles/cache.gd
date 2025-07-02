extends Damageable

const fund_coin: PackedScene = preload("res://misc/effects/FundCoin.tscn")
const heal_ray: PackedScene = preload("res://misc/effects/HealRay.tscn")
const surprise: PackedScene = preload("res://entities/enemies/Surprise.tscn")



func _ready():
	$Render.material.set_shader_parameter("noise", load("res://assets/baked_noise/cache_variations/%s.png" % randi_range(1,16)))
	hurt.connect(_hurt)

func _hurt(_amount: int) -> void:
	$VisibleOnScreenEnabler2D.queue_free()
	$OpenParticles.emitting = true
	$CollisionShape2D.set_deferred("disabled", true)
	$Animations.play("open")
	var weights = RollWeights.new()
	weights.add_item("funds", 19)
	if Micro.player.hp < Micro.player.max_hp: weights.add_item("heal", 10)
	if global_position.length_squared() > 500000: weights.add_item("surprise", 1)
	do_reward(Micro.roll(weights))
	await Micro.wait(1.5)
	$Animations.play("burn")
	await Micro.wait(0.5)
	queue_free()

func do_reward(reward: String) -> void:
	if reward == "funds":
		for i in randi_range(2, 5):
			var coin := fund_coin.instantiate()
			coin.position = position
			coin.amount = 1
			coin.delay = randf_range(0.15, 0.4)
			add_sibling(coin)
	elif reward == "heal":
		var ray := heal_ray.instantiate()
		add_child(ray)
		ray.heal(Micro.player, 20., 1.)
	elif reward == "surprise":
		var enemy := surprise.instantiate()
		enemy.position = position
		await Micro.wait(0.25)
		call_deferred("add_sibling", enemy)
