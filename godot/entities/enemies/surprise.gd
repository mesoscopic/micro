extends ChaserEnemy

func _ready():
	super()

func _on_attack_body_entered(body: Node2D) -> void:
	if body is Damageable:
		body.damage(30)
		fund_drop = 0
		damage(20)
