extends Damageable

const fund_coin: PackedScene = preload("res://misc/effects/FundCoin.tscn")
const heal_ray: PackedScene = preload("res://misc/effects/HealRay.tscn")
const surprise: PackedScene = preload("res://entities/enemies/Surprise.tscn")
const heal_orb: PackedScene = preload("res://misc/effects/HealOrb.tscn")

func _ready():
	super()
	$Render.material.set_shader_parameter("noise", load("res://assets/baked_noise/cache_variations/%s.png" % randi_range(1,16)))
	hurt.connect(_hurt)

func _hurt(_amount: int, _direction: float) -> void:
	$VisibleOnScreenEnabler2D.queue_free()
	$OpenParticles.emitting = true
	$CollisionShape2D.set_deferred("disabled", true)
	get_tree().create_tween().tween_property($Render, "self_modulate", Color.WHITE, 0.5)
	var weights = RollWeights.new()
	match Micro.world.get_biome(Micro.world.tile_at(global_position)):
		Micro.world.Biome.LANDING:
			weights.add_item("funds", 1)
		_:
			weights.add_item("funds", 19)
			if Micro.player.hp < Micro.player.max_hp/2.: weights.add_item("heal", 10)
			weights.add_item("surprise", 1)
			if Micro.world.taxicab(global_position)/20. > 256:
				weights.add_item("big_funds", 2)
				weights.add_item("surprise", 2)
	do_reward(Micro.roll(weights))
	#await Micro.wait(1.5)
	#$Animations.play("burn")
	#await Micro.wait(0.5)
	#queue_free()

func do_reward(reward: String) -> void:
	if reward == "funds":
		for i in randi_range(2, 5):
			var coin := fund_coin.instantiate()
			coin.position = global_position
			coin.amount = 1
			coin.delay = randf_range(0.15, 0.4)
			Micro.world.get_node("Entities").add_child(coin)
	elif reward == "big_funds":
		for i in randi_range(5, 12):
			var coin := fund_coin.instantiate()
			coin.position = global_position
			coin.amount = 2
			coin.delay = randf_range(0.15, 0.4)
			Micro.world.get_node("Entities").add_child(coin)
	elif reward == "heal":
		for i in randi_range(4, 8):
			var orb := heal_orb.instantiate()
			orb.position = global_position
			orb.distance = randf_range(20.,50.)
			Micro.world.get_node("Entities").add_child(orb)
	elif reward == "surprise":
		var enemy := surprise.instantiate()
		enemy.position = global_position
		await Micro.wait(0.25)
		Micro.world.get_node("Entities").call_deferred("add_child", enemy)
