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
		$Display/Label.text = "Button %s" % event.button_index
	if event is InputEventJoypadMotion:
		$Display.show()
		$Display/Label.text = "Axis %s %s" % [event.axis, sign(event.axis_value)]
