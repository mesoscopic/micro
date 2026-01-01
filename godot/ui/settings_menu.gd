extends MarginContainer

var focused_setting: Control
@onready var setting_count := $Panel/Margin/MainBox/Options.get_child_count()
var section_indices: Array[int] = []

signal done

func _ready() -> void:
	for setting_button in $Panel/Margin/MainBox/Options.get_children():
		setting_button.show_description.connect(show_description)
		setting_button.focus_entered.connect(func (): focused_setting = setting_button)
	$Panel/Margin/MainBox/Options.get_child(1).grab_focus()
	for i in setting_count:
		if $Panel/Margin/MainBox/Options.get_child(i) is SettingSection:
			section_indices.append(i)

func _input(event) -> void:
	if event.is_action_pressed("open_menu_key") or event.is_action_pressed("open_menu_joy") or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		done.emit()
	if event.is_action_pressed("ui_next_section", true):
		var i: int = focused_setting.get_index()
		while i not in section_indices:
			i = wrap(i+1, 0, setting_count)
		$Panel/Margin/MainBox/Options.get_child(i+1).grab_focus()
	if event.is_action_pressed("ui_prev_section", true):
		var i: int = wrap(focused_setting.get_index() - 2, 0, setting_count)
		while i not in section_indices:
			i = wrap(i-1, 0, setting_count)
		$Panel/Margin/MainBox/Options.get_child(i+1).grab_focus()

func show_description(description: String):
	$Panel/Margin/MainBox/Info/Margin/Description.text = description
