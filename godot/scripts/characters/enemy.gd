extends Damageable

class_name Enemy

const DEATH_ANIMATION = preload("res://scenes/characters/EnemyDeathAnimation.tscn")

signal aggro
signal deaggro

@onready var aggro_methods: Array = find_children("*", "AggroMethod")
var is_aggro = false

func _ready():
	hurt.connect(_hurt)
	die.connect(_die)
	for method in aggro_methods:
		method.aggro_changed.connect(change_aggro)

func _die():
	var anim = DEATH_ANIMATION.instantiate()
	anim.global_position = global_position
	get_parent().add_child(anim)
	queue_free()

func _hurt():
	$HurtParticles.restart()

func _physics_process(_delta: float) -> void:
	tick()

func change_aggro(_method: AggroMethod):
	var should_aggro: bool = false
	for aggro_method in aggro_methods:
		if aggro_method.is_aggro:
			should_aggro = true
			break
	if should_aggro and !is_aggro:
		is_aggro = true
		aggro.emit()
	if !should_aggro and is_aggro:
		is_aggro = false
		deaggro.emit()
