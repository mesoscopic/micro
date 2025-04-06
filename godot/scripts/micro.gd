extends Node

# The Micro singleton

const SETTINGS = preload("res://scenes/ui/Settings.tscn")
var menu: Node
var player: Player
var world: World

const TRADE_COIN = preload("res://scenes/fx/TradeCoin.tscn")

var loaded_settings = {
	"photosensitive_mode": false
}

signal refresh_trades

func screen_wipe_out():
	var SCREEN_WIPE_ANIMATOR = get_tree().current_scene.get_node("ScreenWipe/ScreenWipeAnimation")
	SCREEN_WIPE_ANIMATOR.play("wipe_out")
	await SCREEN_WIPE_ANIMATOR.animation_finished

func screen_wipe_in():
	var SCREEN_WIPE_ANIMATOR = get_tree().current_scene.get_node("ScreenWipe/ScreenWipeAnimation")
	SCREEN_WIPE_ANIMATOR.play("wipe_in")
	await SCREEN_WIPE_ANIMATOR.animation_finished
	SCREEN_WIPE_ANIMATOR.play("RESET")
	get_tree().current_scene.get_node("ScreenWipe/StatusMessage").text = ""

func _input(event):
	if event.is_action_pressed("debug_overlay"):
		var overlay: Control = get_tree().current_scene.get_node("UI/DebugOverlay")
		overlay.visible = !overlay.visible

func settings(modal: bool):
	if is_instance_valid(menu): return
	menu = SETTINGS.instantiate()
	get_tree().current_scene.find_child("UI").add_child(menu)
	if modal: menu.be_modal()
	await menu.done

func wait(time: float, override_pause: bool = false):
	await get_tree().create_timer(time, override_pause).timeout

func worldgen_status(status: String) -> void:
	get_tree().current_scene.get_node("ScreenWipe/StatusMessage").text = status

func show_trade_information(trader: Trader):
	var overlay = get_tree().current_scene.get_node("UI/TradeOverlay")
	overlay.get_node("HBoxContainer/Trader/VBoxContainer/ItemDisplay").material = trader.item.render
	overlay.get_node("HBoxContainer/Trader/VBoxContainer/MarginContainer/HBoxContainer/Cost").text = "%s" % trader.item.cost
	overlay.get_node("HBoxContainer/MarginContainer/VBoxContainer/Title").text = trader.item.title
	overlay.get_node("HBoxContainer/MarginContainer/VBoxContainer/Description").text = trader.item.description
	if !overlay.visible:
		overlay.get_node("Animations").play("show")
	else:
		overlay.get_node("Animations").play("keep_shown")

func hide_trading():
	get_tree().current_scene.get_node("UI/TradeOverlay/Animations").play("hide")

func attempt_trade(trader: Trader):
	var overlay = get_tree().current_scene.get_node("UI/TradeOverlay")
	var item = trader.item
	if Micro.player.funds < item.cost:
		overlay.get_node("Animations").play("cannot_afford")
	else:
		overlay.get_node("Animations").play("hide")
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
		await wait(1.)
		refresh_trades.emit()
		var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(Micro.player.get_node("Camera"), "global_position", Vector2.ZERO, 0.5)
		get_tree().current_scene.get_node("Game/World/Structures/SpawnNest").activate()
		await wait(.5)
		get_tree().current_scene.get_node("Game/World/Structures/SpawnNest").purchased_upgrade = item

func end_trade():
	await wait(1.)
	show_trade_information(Micro.player.chosen_trader)
	Micro.player.movement_disabled = false
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(Micro.player.get_node("Camera"), "position", Vector2.ZERO, 0.5)
	get_tree().current_scene.get_node("Game/World/Structures/SpawnNest").deactivate()

func roll(weights: RollWeights) -> Variant:
	var random: RandomNumberGenerator
	if Micro.world:
		random = Micro.world.random
	else:
		random = RandomNumberGenerator.new()
	
	var choice: int = randi_range(1, weights.weights_sum)
	return weights.get_item(choice)
