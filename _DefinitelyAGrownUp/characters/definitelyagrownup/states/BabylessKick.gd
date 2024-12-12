extends CharacterState

var direction = "1.0"

func _enter():
	if host.baby_projectile:
		var baby = host.objs_map[host.baby_projectile]
		
		if data and data.has("x"):
			if data.x < 0:
				direction = "-1.0"
			else:
				direction = "1.0"
		
		baby.kick(direction)

func is_usable():
	return .is_usable() and host.baby_projectile and host.is_babyless and not host.is_baby_exploding and not host.is_in_super_baby_mode
