extends ObjectState

func _enter():
	var vel = host.get_vel()
	var new_facing = 1
	
	if fixed.lt(vel.x, "0.0"):
		new_facing = -1
	else:
		new_facing = 1
	
	host.set_facing(new_facing)
	host.get_node("Flip/Particles/ParticleEffect").stop_emitting()
