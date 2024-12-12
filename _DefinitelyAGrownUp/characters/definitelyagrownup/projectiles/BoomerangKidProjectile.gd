extends ObjectState

class_name BoomerangKidProjectile

export var _c_Projectile_Options = 0
export var movement_speed = "16"
export var boomerang_max_distance = "500"
export var lifetime = 99999
export var relative_data_dir = false
export var clash = true
export var num_hits = 1

var move_vec
var hit_something = false
var hit_something_tick = 0

func _enter():
	host.get_node("Flip/Particles/ParticleEffect").start_emitting()

func _frame_0():
	if data and data.has("dir"):
		var dir = data["dir"]
		move_vec = fixed.vec_mul(str(dir.x), str(dir.y), movement_speed)
		host.set_vel(move_vec.x, move_vec.y)
	
	host.set_grounded(false)
	hit_something = false
	hit_something_tick = 0

func _tick():
	var vel = host.get_vel()
	var global_pos = host.get_pos()
	var target = host.obj_local_center(host.creator)
	var current = fixed.normalized_vec(vel.x, vel.y)
	var target_direction = fixed.normalized_vec(str(target.x), str(target.y))
	host.update_grounded()
	
	if host.is_grounded() and not host.creator.is_baby_coming_back:
		host.change_state("Standing")
	
	if current_tick > lifetime:
		fizzle()
		host.hurtbox.width = 0
		host.hurtbox.height = 0
	
	if not hit_something:
		if not fixed.eq(vel.x, "0"):
			host.set_facing(1 if fixed.gt(vel.x, "0") else - 1)
		
		if host.creator.is_baby_coming_back:
			move_vec = fixed.vec_mul(target_direction.x, target_direction.y, host.come_back_speed)
			host.set_vel(move_vec.x, move_vec.y)
		
		host.apply_forces()
		host.update_data()
		
		var distance_from_projectile_to_target = fixed.vec_len(str(target.x), str(target.y))
		if fixed.lt(distance_from_projectile_to_target, host.retrieve_despawn_distance) and current_tick >= host.retrieve_despawn_cooldown:
			fizzle();
		
		if fixed.gt(distance_from_projectile_to_target, boomerang_max_distance) and not host.creator.is_baby_coming_back and not host.creator.is_in_super_baby_mode:
			host.set_is_coming_back(true)
		
		if global_pos.x <= - host.stage_width or global_pos.x >= host.stage_width:
			host.explode()
		
		if global_pos.y <= - host.ceiling_height:
			host.explode()

func fizzle():
	host.fizzle()
	terminate_hitboxes()
	hit_something = true
	hit_something_tick = current_tick

func _on_hit_something(obj, _hitbox):
	if clash:
		if obj is BaseProjectile:
			if not obj.deletes_other_projectiles:
				return 
		num_hits -= 1
		if num_hits == 0:
			fizzle()
