extends Node2D

var tween: Tween
var purchased_upgrade: Upgrade
var selected_slot: NestSlot:
	set(slot):
		selected_slot = slot
		for s in $Slots.get_children():
			s.deselect()
		if selected_slot:
			selected_slot.select()
var aim_angle := 0.

func _ready() -> void:
	Micro.world.purchase_upgrade.connect(prepare_upgrade)

func _process(_delta) -> void:
	if purchased_upgrade:
		selected_slot = $Slots.get_child(floor(aim_input()/(PI/4.)))
		$SelectionParticles.rotation = selected_slot.position.angle()

func prepare_upgrade(item: Upgrade):
	await Micro.wait(0.5)
	purchased_upgrade = item
	selected_slot = $Slots.get_child(floor(aim_input()/(PI/4.)))
	$SelectionParticles.emitting = true

func _on_home_zone_entered(_body: Node2D) -> void:
	for i in ceil((Micro.player.max_hp - Micro.player.hp)/5.*randf_range(1.,2.)):
		var orb := Micro.new(&"micro:heal_orb")
		orb.position = position
		orb.distance = randf_range(40.,80.)
		Micro.world.get_node("Entities").add_child(orb)

func _input(event: InputEvent) -> void:
	if purchased_upgrade and event.is_action("shoot"):
		selected_slot.put_upgrade(purchased_upgrade)
		purchased_upgrade = null
		selected_slot = null
		$SelectionParticles.emitting = false
	if event is InputEventMouseMotion:
		aim_angle = get_local_mouse_position().angle()

func aim_input() -> float:
	var swap := bool(Micro.get_setting("swap_joysticks"))
	var joy_angle := Input.get_vector(
		"move_left_joy" if swap else "aim_left",
		"move_right_joy" if swap else "aim_right",
		"move_up_joy" if swap else "aim_up",
		"move_down_joy" if swap else "aim_down"
	).angle()
	if joy_angle != 0.: aim_angle = joy_angle
	return aim_angle
