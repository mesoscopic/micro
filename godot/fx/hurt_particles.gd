@tool
class_name Hurt extends GPUParticles2D

@export_tool_button("Test Hurt")
var test_hurt := func ():
	hurt(10, PI/3)

func hurt(times: int, angle: float):
	for i in range(times):
		var direction = Vector2.from_angle(angle + randf_range(-PI/6,PI/6))
		emit_particle(Transform2D.IDENTITY, direction*randf_range(60,120), Color.WHITE, Color.WHITE, EmitFlags.EMIT_FLAG_VELOCITY)
