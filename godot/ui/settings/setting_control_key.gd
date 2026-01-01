class_name SettingControlKey extends Button

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
	$Key.hide()
	$Mouse.hide()

func _input(event: InputEvent) -> void:
	if !has_focus(): return
	if taking_input and !event.is_released() and (event is InputEventKey or event is InputEventMouseButton):
		get_viewport().set_input_as_handled()
		display_event(event)
		Micro.set_control(action, event)
		taking_input = false

func _on_mouse_entered() -> void:
	grab_focus()

func display_event(event: InputEvent) -> void:
	$Awaiting.hide()
	if event is InputEventKey:
		$Key.show()
		$Mouse.hide()
		var keycode := DisplayServer.keyboard_get_keycode_from_physical(event.physical_keycode)
		$Key/Name.text = "%s" % char(keycode) if (
			OS.is_keycode_unicode(keycode) and !char(keycode).strip_edges().is_empty()
		) else OS.get_keycode_string(keycode)
	if event is InputEventMouseButton:
		$Mouse.show()
		$Key.hide()
		$Mouse/Icon.text = char(0xf0010 + (event.button_index if event.button_index <= 7 else 0))
		$Mouse/Label.text = " Mouse %s" % event.button_index
