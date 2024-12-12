extends CharacterState

func _frame_1():
	if host.baby_projectile:
		var baby = host.objs_map[host.baby_projectile]
		baby.explode()
