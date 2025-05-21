extends Camera2D

var hurt_effect: bool = false

func hurt(amount: float) -> void:
	$Overlays/HurtEffect.material.set("shader_parameter/progress", amount)
	$Overlays/HurtEffect.show()
	hurt_effect = true

func _process(delta: float) -> void:
	if hurt_effect:
		$Overlays/HurtEffect.material.set("shader_parameter/progress", $Overlays/HurtEffect.material.get("shader_parameter/progress")/pow(2., delta*10.))
		if $Overlays/HurtEffect.material.get("shader_parameter/progress") < 0.005:
			$Overlays/HurtEffect.hide()
			hurt_effect = false
