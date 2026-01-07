extends MarginContainer

var focused_setting: Control
@onready var scroll := $Panel/Margin/MainBox/Scroll
@onready var settings_list := $Panel/Margin/MainBox/Scroll/Options
@onready var item_count := settings_list.get_child_count()
var section_indices: Array[int] = []

const scroll_margin := 125

signal done

func _ready() -> void:
	for setting_button in settings_list.get_children():
		setting_button.show_description.connect(show_description)
		setting_button.focus_entered.connect(func (): focus(setting_button))
	settings_list.get_child(1).grab_focus()
	settings_list.get_child(1).focus_neighbor_top = settings_list.get_child(item_count-1).get_path()
	settings_list.get_child(item_count-1).focus_neighbor_bottom = settings_list.get_child(1).get_path()
	for i in item_count:
		if settings_list.get_child(i) is SettingSection:
			section_indices.append(i)
	

func _input(event) -> void:
	if Micro.closes_menu(event):
		get_viewport().set_input_as_handled()
		done.emit()
	if event.is_action_pressed("ui_next_section", true):
		var i: int = focused_setting.get_index()
		while i not in section_indices:
			i = wrap(i+1, 0, item_count)
		settings_list.get_child(i+1).grab_focus()
	if event.is_action_pressed("ui_prev_section", true):
		var i: int = wrap(focused_setting.get_index() - 2, 0, item_count)
		while i not in section_indices:
			i = wrap(i-1, 0, item_count)
		settings_list.get_child(i+1).grab_focus()

func show_description(description: String):
	$Panel/Margin/MainBox/Info/Margin/Description.text = description

func focus(setting: Control):
	focused_setting = setting
	if setting.position.y - scroll_margin <= scroll.scroll_vertical:
		scroll.scroll_vertical = clamp(setting.position.y - scroll_margin, 0, scroll.size.y)
	elif setting.position.y + scroll_margin >= scroll.scroll_vertical + scroll.size.y:
		scroll.scroll_vertical = clamp(setting.position.y + scroll_margin - scroll.size.y, 0, scroll.size.y)
