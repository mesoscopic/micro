extends Control

signal done

var modal = false

const tabs = [
	{
		"title": "General"
	},
	{
		"title": "Visual"
	}
]

func _ready() -> void:
	$TabContainer.remove_theme_stylebox_override("panel")
	for i in tabs.size():
		var tab_def = tabs[i]
		var tab = TabBar.new();
		tab.name = ("[%s] " % (i+1)) + tab_def.title;
		tab.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$TabContainer.add_child(tab)
		pass

func be_modal():
	modal = true
	$TabContainer.mouse_filter = MouseFilter.MOUSE_FILTER_STOP
	$TabContainer.add_theme_stylebox_override("panel", $TabContainer.get_theme().get_stylebox("tabbar_background", "TabContainer"))

func save_and_exit():
	done.emit()
	queue_free()

func _input(event: InputEvent) -> void:
	for i in tabs.size():
		if event.is_action("tab_%s"%(i+1)) and event.is_pressed():
			$TabContainer.current_tab = i
	if (event.is_action("ui_cancel") or (!modal and event.is_action("quick_settings"))) and event.is_pressed():
		save_and_exit()
