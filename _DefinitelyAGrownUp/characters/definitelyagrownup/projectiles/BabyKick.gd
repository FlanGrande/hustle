extends ObjectState

onready var hitbox = $Hitbox

func _enter():
	var vel = host.get_vel()
	
	host.get_node("Flip/Particles/ParticleEffect").stop_emitting()
	
	if data and data.has("dir"):
		host.set_facing(int(data.get("dir")))
	else:
		host.set_facing(1)
