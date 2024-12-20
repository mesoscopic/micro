extends Control

signal done

func _ready():
	$Menu/TabContainer.get_tab_control($Menu/TabContainer.current_tab).get_child(0).get_child(0).grab_focus()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		done.emit()
	elif event.is_action_pressed("ui_left"):
		$Menu/TabContainer.select_previous_available()
		$Menu/TabContainer.get_tab_control($Menu/TabContainer.current_tab).get_child(0).get_child(0).grab_focus()
	elif event.is_action_pressed("ui_right"):
		$Menu/TabContainer.select_next_available()
		$Menu/TabContainer.get_tab_control($Menu/TabContainer.current_tab).get_child(0).get_child(0).grab_focus()
