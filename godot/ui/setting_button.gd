class_name SettingButton extends Button

@export var setting_name: String
@export var setting_id: String
@export var choices: Array[String]
@export_multiline var description: String
var choice: int

signal show_description

func _ready() -> void:
	text = setting_name
	choice = Micro.get_setting(setting_id)
	$Choice.text = "< %s >" % choices[choice]

func _on_focus_entered() -> void:
	modulate = Color.WHITE
	show_description.emit(description)

func _on_focus_exited() -> void:
	modulate = Color(0.6,0.6,0.6)

func _on_pressed() -> void:
	choice = wrap(choice + 1, 0, len(choices))
	set_setting()

func _input(event) -> void:
	if !has_focus(): return
	if event.is_action_pressed("ui_left"):
		choice = wrap(choice - 1, 0, len(choices))
		set_setting()
	elif event.is_action_pressed("ui_right"):
		choice = wrap(choice + 1, 0, len(choices))
		set_setting()

func set_setting():
	$Choice.text = "< %s >" % choices[choice]
	Micro.set_setting(setting_id, choice)
