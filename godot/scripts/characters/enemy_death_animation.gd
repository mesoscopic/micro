extends Node2D

var fund_drop: int = 0

const fund_coin: PackedScene = preload("res://scenes/fx/FundCoin.tscn")

func _ready():
	$ExplosionParticles.emitting = true
	$Ring.emitting = true
	while fund_drop > 0:
		var coin := fund_coin.instantiate()
		coin.position = position
		coin.amount = ceil(fund_drop/8.)
		coin.delay = randf_range(0., 0.25)
		add_sibling(coin)
		fund_drop -= ceil(fund_drop/8.)

func _on_timer_timeout() -> void:
	queue_free()
