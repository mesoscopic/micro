extends ChaserEnemy

func _ready():
	super()
	extra_reward = func(_pos): await Micro.wait(.5)

func _on_attack_body_entered(body: Node2D) -> void:
	if body is Damageable:
		body.damage(40)
		damage(20)
