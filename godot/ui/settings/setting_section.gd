class_name SettingSection extends PanelContainer

var description := "Section"

@warning_ignore("unused_signal")
signal show_description

@export var title: String

func _ready() -> void:
	$SectionTitle.text = title
