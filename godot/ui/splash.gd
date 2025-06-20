extends Control

signal finished

func _ready():
	$MarginContainer/VersionInformation.text = $MarginContainer/VersionInformation.text \
		.replace("<version>", ProjectSettings.get_setting("application/config/version")) \
		.replace("<version_description>", ProjectSettings.get_setting("application/config/version_description"))
	
	$MarginContainer/BuildInfo.text = $MarginContainer/BuildInfo.text \
		.replace("<status>", "Debug" if OS.is_debug_build() else "Release") \
		.replace("<os>", OS.get_name())

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		$AnimationPlayer.stop()
		finished.emit()
		queue_free()

func _on_finished(_anim_name):
	finished.emit()
	queue_free()
