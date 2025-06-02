extends GenericTrader
class_name WildTrader

var stop := false

var ANIMATION = preload("res://scenes/fx/TraderSpawn.tscn")

func should_stop() -> bool:
	return stop

func _on_collect_area_body_entered(body: Node2D) -> void:
	if body != Micro.player: return
	$CollectArea.set_deferred("monitoring", false)
	$TraderParticles.emitting = true
	stop = true
	await Micro.wait(1.)
	await Micro.world.get_trader(global_position).ready
	await Micro.wait(.5)
	$Render.hide()
	await Micro.wait(.5)
	queue_free()
