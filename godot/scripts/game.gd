extends Node2D

class_name World

var random: RandomNumberGenerator = RandomNumberGenerator.new()
var world_seed: int = randi()

var bosses_active: int = 0
var trader_minibosses_fought: int = 0

func world_enemy(taxicab_distance: float) -> Enemy:
	var enemies: RollWeights = RollWeights.new()
	enemies.add_item(preload("res://scenes/characters/enemies/BasicShooter.tscn"), 4)
	enemies.add_item(preload("res://scenes/characters/enemies/AdvancedShooter.tscn"), 2)
	if taxicab_distance >= 100:
		enemies.add_item(preload("res://scenes/characters/enemies/AdvancedShooter.tscn"), 2)
		enemies.add_item(preload("res://scenes/characters/enemies/Turret.tscn"), 2)
		enemies.add_item(preload("res://scenes/characters/enemies/Teleporter.tscn"), 1)
	if taxicab_distance >= 120:
		enemies.add_item(preload("res://scenes/characters/enemies/Surpriser.tscn"), 1)
	return Micro.roll(enemies).instantiate()

func spawn_attempt() -> void:
	if bosses_active > 0:
		print("a boss is active!")
		return # World enemies shouldn't spawn during boss fights
	var player_pos: Vector2 = Micro.player.position / 20.
	var taxicab_distance: float = abs(player_pos.x) + abs(player_pos.y)
	if taxicab_distance < 30: return # Make sure the player is far enough from spawn
	elif taxicab_distance < 60 and randi_range(1,2) != 1: return # 1 in 2 chance to spawn if <80 tiles from spawn
	elif taxicab_distance < 100 and randi_range(1,3) == 1: return # 2 in 3 chance to spawn if >80 and <160 tiles from spawn
	# Otherwise, spawn is guaranteed
	var enemy := world_enemy(taxicab_distance)
	# Spawn the enemy 20 tiles away from the player.
	# If you're closer to spawn, enemies will tend to come from the opposite direction to spawn.
	var angle_randomization = taxicab_distance / 60.
	var tile: Vector2 = (player_pos + Vector2.from_angle(player_pos.angle_to_point(Vector2.ZERO)+PI+randf_range(-angle_randomization,angle_randomization)) * 20.)
	enemy.position = tile * 20.
	$Structures.add_child(enemy)

func get_trader(from: Vector2):
	var animation = preload("res://scenes/fx/TraderSpawn.tscn").instantiate()
	animation.position = from
	$Structures.call_deferred("add_child", animation)

const TRADE_COIN = preload("res://scenes/fx/TradeCoin.tscn")
signal refresh_trades
signal purchase_upgrade(item: Upgrade)

func trade(trader: Trader, item: Upgrade):
	Micro.player.funds -= item.cost
	Micro.player.get_node("FundsDisplay/HBoxContainer/Label").text = "%s" % Micro.player.funds
	Micro.player.movement_disabled = true
	var amount = item.cost
	while amount > 0:
		var coin := TRADE_COIN.instantiate()
		coin.position = Micro.player.position
		coin.amount = ceil(amount/8.)
		coin.target = trader
		Micro.player.add_sibling(coin)
		amount -= ceil(amount/8.)
	await Micro.wait(1.)
	refresh_trades.emit()
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(Micro.player.get_node("Camera"), "global_position", Vector2.ZERO, 0.5)
	purchase_upgrade.emit(item)

func end_trade():
	await Micro.wait(1.)
	Micro.show_trade_information(Micro.player.chosen_trader)
	Micro.player.movement_disabled = false
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(Micro.player.get_node("Camera"), "position", Vector2.ZERO, 0.5)

# --------------
# World gen code
# --------------

func generate_world():
	var start = Time.get_ticks_usec()
	Micro.worldgen_status("Placing arenas...")
	place(0, Vector2i(50, 50))
	place(0, Vector2i(50, -50))
	place(0, Vector2i(-50, -50))
	place(0, Vector2i(-50, 50))
	Micro.worldgen_status("Placing caches...")
	for i in 200:
		var pos = Vector2(randfn(0., 3.), randfn(0., 3.)) * 20.
		pos += pos.normalized()*18
		while $Structures/Tiles.get_cell_alternative_tile(pos) > 0:
			pos = Vector2(randfn(0., 3.), randfn(0., 3.)) * 20.
			pos += pos.normalized()*18
		$Structures/Tiles.set_cell(pos, 0, Vector2i.ZERO, 4)
	print("world gen took %s microseconds" % (Time.get_ticks_usec()-start))

func place(id: int, pos: Vector2i):
	var pattern: TileMapPattern = $Structures/Tiles.tile_set.get_pattern(id)
	$Structures/Tiles.set_pattern(pos-pattern.get_size()/2, pattern)
