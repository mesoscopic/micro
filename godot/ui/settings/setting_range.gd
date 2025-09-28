class_name SettingRange extends Button

@export var setting_name: String
@export var setting_id: String
@export var min_bound: int
@export var max_bound: int
@export var step: int = 1
@export var unit: String
@export_multiline var description: String
var choice: int

signal show_description

func _ready() -> void:
	text = setting_name
	choice = Micro.get_setting(setting_id)
	$Choice.text = "%s %*s%s %s" % ["-" if choice > min_bound else "[", max(len(str(max_bound)), len(str(min_bound))), choice, unit, "+" if choice < max_bound else "]"]

func _on_focus_entered() -> void:
	modulate = Color.WHITE
	show_description.emit(description)

func _on_focus_exited() -> void:
	modulate = Color(0.6,0.6,0.6)

func _on_pressed() -> void:
	pass

func _input(_event) -> void:
	if !has_focus(): return
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_range_decrease") and choice > min_bound:
		choice = max(choice - step, min_bound)
		set_setting()
	elif Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_range_increase") and choice < max_bound:
		choice = min(choice + step, max_bound)
		set_setting()

func set_setting():
	$Choice.text = "%s %*s%s %s" % ["-" if choice > min_bound else "[", max(len(str(max_bound)), len(str(min_bound))), choice, unit, "+" if choice < max_bound else "]"]
	Micro.set_setting(setting_id, choice)

func _on_mouse_entered() -> void:
	grab_focus()
