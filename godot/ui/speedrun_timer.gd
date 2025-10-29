extends Control

var start_time: int = -1
var end_time: int = -1

func _process(_delta: float):
	if start_time == -1: return
	if end_time == -1:
		$Label.text = format_time(Time.get_ticks_msec()-start_time)
	else:
		$Label.text = format_time(end_time-start_time)

func format_time(t: int):
	return "%s:%02d.%03d" % [int(t/60000.), int(t%60000/1000.), t%1000]
