extends CharacterBody2D

class_name Damageable

@export var max_hp := 100
@export var hp := 100
@export var invulnerability_time := .2
@export var invincible: bool = false
@export var deplete_hp: bool = true
var itimer: Timer

signal hurt
signal die

func _ready() -> void:
	itimer = Timer.new()
	itimer.one_shot = true
	add_child(itimer)

func tick():
	$Render.set_instance_shader_parameter("health", float(hp)/float(max_hp))
	$Render.set_instance_shader_parameter("damaged", !itimer.is_stopped() or invincible)

func damage(amount: int, bypass_itime := false, direction := randf_range(0,2*PI)):
	if invincible or Micro.player.movement_disabled or (!itimer.is_stopped() and !bypass_itime): return
	if deplete_hp: hp -= amount
	if invulnerability_time > .0 and !bypass_itime: itimer.start(invulnerability_time)
	if hp <= 0:
		invincible = true
		die.emit()
	else:
		hurt.emit(amount, direction)

func heal(amount: int):
	hp = min(max_hp, hp + amount)

func set_hp(amount: int):
	hp = amount
