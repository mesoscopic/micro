extends Control


const PAUSE_MENU = preload("res://scenes/ui/PauseMenu.tscn")

var in_menu: bool = false
var in_game: bool = false

const START_MENU = preload("res://scenes/ui/StartRun.tscn")

func _ready():
	# Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	pass

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
	var start_time = Time.get_ticks_usec()
	var world = load("res://scenes/World.tscn").instantiate()
	Micro.world = world
	world.random.seed = world.world_seed
	$Game.add_child(world)
	await world.generate_world()
	print("Worldgen finished in %s microseconds" % (Time.get_ticks_usec()-start_time))
	await Micro.screen_wipe_in()
	in_game = true

func _on_death():
	Micro.world.free()
	Micro.world = null
	in_game = false
	get_tree().paused = false
	await Micro.screen_wipe_in()
	# death screen, stats, etc.
	var run_menu = START_MENU.instantiate()
	$UI.add_child(run_menu)
	run_menu.play.connect(_on_start_run)

func _input(_event):
	if Input.is_action_just_pressed("open_menu") and in_game and not get_tree().paused:
		var pause_menu = PAUSE_MENU.instantiate()
		$UI.add_child(pause_menu)
		get_tree().paused = true
		await pause_menu.finished
		await Micro.wait(0.1, true)
		get_tree().paused = false
	if Input.is_action_just_pressed("quick_settings") and in_game and !$UI.has_node("Settings"):
		Micro.settings(false)
