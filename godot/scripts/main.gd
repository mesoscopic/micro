extends Control

const START_MENU = preload("res://scenes/ui/StartRun.tscn")
const WORLD = preload("res://scenes/World.tscn")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(_delta):
	pass

func _on_splash_finished():
	# check if there is a save file
	# if no
	var run_menu = START_MENU.instantiate()
	$UI.add_child(run_menu)
	run_menu.play.connect(_on_start_run)
	# if yes screen wipe into paused game

func _on_start_run():
	$UI.remove_child($UI.get_node("StartRun"))
	$Game.add_child(WORLD.instantiate())
	await Micro.screen_wipe_in()
	pass
