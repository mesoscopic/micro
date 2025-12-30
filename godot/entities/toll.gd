class_name Toll extends Node2D

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
var balance: int = 0

func pay(amount: int) -> void:
	balance += amount
	Micro.show_trade_information(self)
	if balance == cost:
		Micro.hide_trading()
		Micro.player.movement_disabled = true
		balance = 0
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
	if balance > 0:
		return_funds()
	Micro.player.tolls.erase(self)

func set_chosen(to: bool) -> void:
	if !is_chosen and to:
		chosen.emit()
	if is_chosen and !to:
		unchosen.emit()
	is_chosen = to

func return_funds() -> void:
	while balance > 0:
		var coin = Micro.new(&"micro:fund_coin")
		coin.position = position
		var coin_amount: int = ceil(balance/8.)
		coin.amount = coin_amount
		balance -= coin_amount
		add_sibling(coin)
