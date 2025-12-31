extends MarginContainer

signal done

func _ready() -> void:
	for setting_button in $Panel/Margin/MainBox/Options.get_children():
		setting_button.show_description.connect(show_description)
	$Panel/Margin/MainBox/Options.get_child(1).grab_focus()

func _input(event) -> void:
	if event.is_action_pressed("open_menu_key") or event.is_action_pressed("open_menu_joy") or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		done.emit()

func show_description(description: String):
	$Panel/Margin/MainBox/Info/Margin/Description.text = description
