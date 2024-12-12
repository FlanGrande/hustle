extends ObjectState

func _enter():
	host.get_node("Flip/Particles/ParticleEffect").stop_emitting()
	host.creator.is_baby_coming_back = false
	host.creator.is_baby_exploding = true
	host.reset_momentum()

func _frame_1():
	var camera = host.get_camera()
	if camera:
		camera.bump(Vector2(), 10, 10 / 60.0)

func _tick():
	if current_tick == 15:
		host.fizzle()
