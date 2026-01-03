extends Control

var active := false
var time := 0.

func _process(delta: float):
	if active:
		time += delta
	$Label.text = "%s:%02d.%03d" % [int(time/60.), int(fmod(time,60.)), fmod(time,1.)*1000]

func reset():
	time = 0
	$Label.hide()
func stop():
	active = false
func start():
	active = true
	$Label.show()
