extends Enemy

func _ready():
	super()
	aggro.connect(_aggro)
	deaggro.connect(_deaggro)

func _aggro() -> void:
	$RetargetTimer.start()
	target_player()

func _deaggro() -> void:
	$RetargetTimer.stop()
	wander()


func _on_attack_body_entered(body: Node2D) -> void:
	if body is Damageable:
		body.damage(30)
		fund_drop = 0
		damage(20)
