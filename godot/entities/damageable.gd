extends CharacterBody2D

class_name Damageable

@export var max_hp := 100
@export var hp := 100
@export var invincible: bool = false
var ticks_since_damage = 4

signal hurt
signal die

func tick():
	ticks_since_damage += 1
	if ticks_since_damage == 3:
		$Render.material.set("shader_parameter/health", 0)
	if ticks_since_damage == 2 || ticks_since_damage == 4:
		$Render.material.set("shader_parameter/health", float(hp)/float(max_hp))

func damage(amount: int):
	if invincible: return
	hp -= amount
	$Render.material.set("shader_parameter/health", 0)
	ticks_since_damage = 0
	if hp <= 0:
		invincible = true
		die.emit()
	else:
		hurt.emit(amount)

func heal(amount: int):
	hp = min(max_hp, hp + amount)
	$Render.material.set("shader_parameter/health", float(hp)/float(max_hp))

func set_hp(amount: int):
	hp = amount
	$Render.material.set("shader_parameter/health", float(hp)/float(max_hp))
