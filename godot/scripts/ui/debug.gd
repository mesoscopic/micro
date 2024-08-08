extends Control

func _process(delta):
	$BottomLeft/FPS.text = "FPS: %s" % int(1/delta);
