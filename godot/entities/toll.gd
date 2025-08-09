class_name Toll extends Node

const TRADE_COIN = preload("res://misc/effects/TradeCoin.tscn")

@export var cost: int = 0
@export var title := ""
@export var description := ""
@export var render: ShaderMaterial
@export var enabled := true

signal paid
signal enter_range
signal leave_range
signal chosen
signal unchosen
var is_chosen := false

func pay() -> void:
	Micro.player.movement_disabled = true
	var amount := cost
	while amount > 0:
		var coin := TRADE_COIN.instantiate()
		coin.position = Micro.player.position
		var coin_amount: int = ceil(amount/8.)
		coin.amount = coin_amount
		Micro.player.funds -= coin_amount
		Micro.player.get_node("FundsDisplay/HBoxContainer/Label").text = "%s" % Micro.player.funds
		coin.target = self
		Micro.player.add_sibling(coin)
		amount -= ceil(amount/8.)
		await Micro.wait(0.05)
	paid.emit()

func set_for_upgrade(upgrade: Upgrade):
	cost = upgrade.cost
	title = upgrade.title
	description = upgrade.description
	render = upgrade.render

func _on_range_entered(body: Node2D) -> void:
	if !enabled or body != Micro.player: return
	enter_range.emit()
	Micro.player.add_toll(self)

func _on_range_left(body: Node2D) -> void:
	if !enabled or body != Micro.player: return
	leave_range.emit()
	set_chosen(false)
	Micro.player.tolls.erase(self)

func set_chosen(to: bool) -> void:
	if !is_chosen and to:
		chosen.emit()
	if is_chosen and !to:
		unchosen.emit()
	is_chosen = to
