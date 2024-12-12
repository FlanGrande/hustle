extends ObjectState

export var hitbox_vel_threshold = "4.5"

func _enter():
	host.get_node("Flip/Particles/ParticleEffect").stop_emitting()
	host.creator.is_baby_coming_back = false

func _tick():
	var vel = host.get_vel()
	var vel_len = fixed.vec_len(vel.x, vel.y)
	
	if fixed.lt(vel_len, hitbox_vel_threshold):
		terminate_hitboxes()
	

#func _exit():
#	host.set_pos(original_pos.x, original_pos.y)
