extends GenericTrader
class_name Trader

var trading: bool = false
var chosen: bool = false:
	set(chosen):
		chosen = chosen
		if chosen: $HappyParticles.emitting = true
var item: Upgrade

func _ready() -> void:
	if !item: refresh()
	Micro.world.refresh_trades.connect(refresh)

func should_stop() -> bool:
	return trading

func _on_trade_range_body_entered(_body: Node2D) -> void:
	trading = true
	Micro.player.add_trader(self)

func _on_trade_range_body_exited(_body: Node2D) -> void:
	trading = false
	chosen = false
	Micro.player.traders.erase(self)
	wander()

func refresh() -> void:
	var weights = RollWeights.new()
	weights.add_item(MultishotUpgrade, 1)
	weights.add_item(RecklessUpgrade, 3)
	weights.add_item(EvasionUpgrade, 2)
	weights.add_item(VolumeUpgrade, 2)
	weights.add_item(VitalityUpgrade, 4)
	item = Micro.roll(weights).new()
