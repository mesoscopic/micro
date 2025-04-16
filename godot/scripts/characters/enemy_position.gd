extends Node2D

@export var enemy: PackedScene
@export var spawn_radius: float
@export var hit_only: bool = false
var active := false

func _ready() -> void:
	if hit_only: $SpawnRange.monitoring = false
	$SpawnRange.scale = Vector2(spawn_radius, spawn_radius)

func _on_spawn_range_body_entered(body: Node2D) -> void:
	if active or body != Micro.player: return
	active = true
	create_tween().tween_property($Character, "light", 50, 0.25)
	$SpawnParticles.emitting = true
	await Micro.wait(1.)
	$SpawnParticles.emitting = false
	$ExplosionParticles.emitting = true
	$Character.hide()
	$Character.light = 0
	var spawned_enemy = enemy.instantiate()
	spawned_enemy.position = position
	add_sibling(spawned_enemy)
	spawned_enemy.die.connect(queue_free)
	spawned_enemy.despawn.connect(reactivate)

func reactivate() -> void:
	active = false
	$Character.show()

func _on_hit(_area: Area2D) -> void:
	if active: return
	active = true
	$ExplosionParticles.emitting = true
	$Character.hide()
	$Character.light = 0
	var spawned_enemy = enemy.instantiate()
	spawned_enemy.position = position
	call_deferred("add_sibling", spawned_enemy)
	spawned_enemy.die.connect(queue_free)
	spawned_enemy.despawn.connect(reactivate)
