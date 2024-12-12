extends CharacterState

export var distance_factor = "0.05"
var catching_up = false

func _frame_6():
	host.reset_momentum()
	
	if host.baby_projectile:
		var baby_projectile_obj = host.objs_map[host.baby_projectile]
		var target = host.obj_local_center(baby_projectile_obj)
		var desired = fixed.normalized_vec(str(target.x), str(target.y))
		var distance = fixed.vec_len(str(target.x), str(target.y))
		var force_x = fixed.mul(desired.x, fixed.mul(distance, distance_factor))
		var force_y = fixed.mul(desired.y, fixed.mul(distance, distance_factor))
		
		host.colliding_with_opponent = false
		host.apply_force_relative(fixed.mul(force_x, str(host.get_facing_int())), force_y)
		host.update_data()

func is_usable():
	return .is_usable() and host.baby_projectile and host.is_babyless and not host.is_baby_exploding
