class_name SettingControlJoy extends Button

@export var setting_name: String
@export var action: StringName
@export_multiline var description: String

var taking_input := false

signal show_description

func _ready() -> void:
	text = setting_name
	display_event(Micro.get_control(action))

func _on_focus_entered() -> void:
	modulate = Color.WHITE
	show_description.emit(description)

func _on_focus_exited() -> void:
	modulate = Color(0.6,0.6,0.6)
	if taking_input:
		taking_input = false
		display_event(Micro.get_control(action))

func _on_pressed() -> void:
	taking_input = true
	$Awaiting.show()
	$Display.hide()

func _input(event: InputEvent) -> void:
	if !has_focus(): return
	if taking_input and !event.is_released() and (event is InputEventJoypadButton or event is InputEventJoypadMotion):
		get_viewport().set_input_as_handled()
		display_event(event)
		Micro.set_control(action, event)
		taking_input = false

func _on_mouse_entered() -> void:
	grab_focus()

func display_event(event: InputEvent) -> void:
	$Awaiting.hide()
	if event is InputEventJoypadButton:
		$Display.show()
		$Display/Icon.text = char(0xf0030 + ((event.button_index + 1) if event.button_index <= 14 else 0))
		$Display/Label.text = " Button %s" % event.button_index
	if event is InputEventJoypadMotion:
		$Display.show()
		var c := 0
		match (event.axis+1) * int(sign(event.axis_value)):
			1: c = 1
			-1: c = 2
			2: c = 3
			-2: c = 4
			3: c = 5
			-3: c = 6
			4: c = 7
			-4: c = 8
			5: c = 9
			6: c = 10
		$Display/Icon.text = char(0xf0020 + c)
		$Display/Label.text = " Axis %s: %s" % [event.axis, int(sign(event.axis_value))]
