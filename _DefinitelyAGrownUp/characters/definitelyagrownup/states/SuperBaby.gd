extends CharacterState

func _enter():
	if host.baby_projectile:
		var baby = host.objs_map[host.baby_projectile]
		host.is_in_super_baby_mode = true
		baby.enter_super_baby_mode()

func is_usable():
	return .is_usable() and host.baby_projectile and host.is_babyless and not host.is_baby_exploding and not host.is_baby_coming_back_toggled and not host.is_baby_coming_back and not host.is_in_super_baby_mode
