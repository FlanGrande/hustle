extends ObjectState

export var _c_Projectile_Dir = 0
export var force_modifier = "1500.0"

export var lifetime = 99999
export var relative_data_dir = false
export var clash = true
export var num_hits = 1
export var fizzle_on_ground = true

var hit_something = false
var hit_something_tick = 0
var last_y_vel = "0"

func _enter():
	var dir = data["dir"]
	host.sprite.rotation = float(fixed.vec_to_angle(dir.x, dir.y))
	host.particles.rotation = float(fixed.vec_to_angle(dir.x, dir.y))

func _frame_0():
	var dir = data["dir"]
	host.sprite.rotation = float(fixed.vec_to_angle(dir.x, dir.y))
	hit_something = false
	hit_something_tick = 0
	host.set_grounded(false)
	var force = xy_to_dir(dir.x, dir.y, force_modifier)
	host.apply_force(force.x, force.y)

func _tick():
	var dir = data["dir"]
	var vel = host.get_vel()
	var pos = host.get_pos()
	host.update_grounded()
	
	if fizzle_on_ground and current_tick > 1 and !hit_something and host.is_grounded() or pos.x <= -host.stage_width or pos.x >= host.stage_width:
		fizzle()
		host.hurtbox.width = 0
		host.hurtbox.height = 0
		pass
	
	host.sprite.rotation = float(fixed.vec_to_angle(vel.x, vel.y))
	host.particles.rotation = float(fixed.vec_to_angle(vel.x, vel.y))
	#host.set_facing(fixed.sign(dir.x))
	
	#elif !hit_something:
	#	var dir = data["dir"]
	#	var dir_x = fixed.mul(dir.x, str(host.get_facing_int())) if relative_data_dir else dir.x
	#	var move_vec = fixed.normalized_vec_times(dir_x, str(dir.y), fixed.mul(fixed.vec_len(dir_x, str(dir.y)), move_speed))
#		print(fixed.vec_len(move_vec.x, move_vec.y))
	#	host.move_directly(move_vec.x, move_vec.y)
	#	host.sprite.rotation = float(fixed.vec_to_angle(dir.x, dir.y))
	#	host.particles.rotation = float(fixed.vec_to_angle(dir.x, dir.y))
	#	host.set_facing(fixed.sign(dir_x))

func fizzle():
	hit_something = true
	host.disable()
	terminate_hitboxes()
	hit_something_tick = current_tick

func _on_hit_something(obj, _hitbox):
	if clash:
		if obj is BaseProjectile:
			if !obj.deletes_other_projectiles:
				return
		num_hits -= 1
		if num_hits == 0:
			fizzle()
