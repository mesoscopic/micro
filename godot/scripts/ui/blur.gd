extends Node2D

var amount: float = 0
var start_amount: float = 0
var target_amount: float = 0
var ms: int = 0
var final_ms: int = 0

func _process(delta):
	if ms < final_ms:
		ms += delta*1000
		amount = lerp(start_amount, target_amount, float(ms)/float(final_ms))
		$X/X.material.set_shader_parameter("AMOUNT", amount)
		$Y/Y.material.set_shader_parameter("AMOUNT", amount)

func blur(in_ms: int, new_amount: float):
	ms = 0
	start_amount = amount
	target_amount = new_amount
	final_ms = in_ms

func unblur(in_ms: int):
	ms = 0
	start_amount = amount
	target_amount = 0
	final_ms = in_ms
