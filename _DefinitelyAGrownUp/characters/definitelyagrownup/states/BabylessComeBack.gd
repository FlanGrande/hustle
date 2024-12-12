extends CharacterState

func _enter():
	if host.baby_projectile:
		var baby = host.objs_map[host.baby_projectile]
		baby.set_is_coming_back(true)

func is_usable():
	if host.baby_projectile:
		var baby_projectile_obj = host.objs_map[host.baby_projectile]
		return baby_projectile_obj != null and not baby_projectile_obj.coming_back
	else:
		return false
