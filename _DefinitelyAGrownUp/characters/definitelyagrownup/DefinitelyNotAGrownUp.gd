extends Fighter

const BABY_PROJECTILE_SCENE = preload("res://_DefinitelyAGrownUp/characters/definitelyagrownup/projectiles/BoomerangKidProjectile.tscn")

const SUPER_BABY_DRAIN = 2

var is_babyless = false
var is_baby_coming_back = false
var is_baby_exploding = false
var baby_projectile = null
var repelling_projectiles = false
var repelled_projectiles = []

var is_baby_coming_back_toggled = false

var is_in_super_baby_mode = false

func tick():
	.tick()
	
	#if is_babyless:
	#	change_stance_to("Babyless")
	
	if stance == "Babyless" and not sprite.animation.ends_with("BL"):
		if sprite.animation + "BL" in sprite.frames.get_animation_names():
			sprite.animation = sprite.animation + "BL"
	
	# TO DO: make sure repelled projectiles can keep hitting us
	if repelling_projectiles and current_state().state_name != "TwisterinoSlapperino":
		end_projectile_repelling()
	
	if is_in_super_baby_mode and baby_projectile:
		use_super_meter(SUPER_BABY_DRAIN)
		if super_meter == 0 and supers_available == 0:
			objs_map[baby_projectile].disable()

func throw_baby(x, y, data):
	var dir = xy_to_dir(data.x, data.y)
	var baby_boomerang_projectile_scene = spawn_object(BABY_PROJECTILE_SCENE, x, y, true, {"dir":dir})
	baby_projectile = baby_boomerang_projectile_scene.obj_name
	is_babyless = true

func copy_to(f:BaseObj):
	.copy_to(f)
	f.is_babyless = is_babyless
	f.is_baby_coming_back = is_baby_coming_back
	f.is_baby_exploding = is_baby_exploding
	f.baby_projectile = baby_projectile
	f.repelling_projectiles = repelling_projectiles
	f.is_baby_coming_back_toggled = is_baby_coming_back_toggled
	f.is_in_super_baby_mode = is_in_super_baby_mode

func start_projectile_repelling():
	repelling_projectiles = true
	repelled_projectiles = []
	damage_taken_modifier = "0.3"

func end_projectile_repelling():
	repelling_projectiles = false
	damage_taken_modifier = "1.0"
	
	for proj in repelled_projectiles:
		if proj:
			proj.refresh_hitboxes()
	
	repelled_projectiles = []
	print(repelled_projectiles)

func on_got_hit_by_projectile():
	if repelling_projectiles:
		var center = obj_local_center(self)
		
		for obj in objs_map.values():
			if obj is BaseObj and not obj == self:
				if obj is BaseProjectile:
					if not obj in repelled_projectiles:
						var projectile_pos = obj_local_center(obj)
						var new_vel = fixed.vec_sub(str(projectile_pos.x), str(projectile_pos.y), str(center.x), str(center.y))
						new_vel.x = fixed.mul(new_vel.x, "1.5")
						new_vel.y = fixed.mul(new_vel.y, "0.4")
						obj.set_vel(new_vel.x, new_vel.y)
						obj.damages_own_team = true
						if obj.current_state().get("num_hits") != null:
							obj.current_state().num_hits += 1
						repelled_projectiles.push_back(obj)
					else:
						if obj.current_state().get("num_hits") != null:
							obj.current_state().num_hits += 1

func can_baby_come_back():
	return is_babyless and not is_baby_coming_back and not is_in_super_baby_mode

func can_baby_explode():
	return is_babyless

func process_extra(extra):
	.process_extra(extra)
	
	if can_baby_come_back():
		if extra.has("comeback"):
			if baby_projectile and extra.comeback:
				is_baby_coming_back_toggled = true
				var baby = objs_map[baby_projectile]
				baby.set_is_coming_back(true)
	else:
		is_baby_coming_back_toggled = false
	
	if can_baby_explode():
		if extra.has("explode"):
			if baby_projectile and extra.explode:
				var baby = objs_map[baby_projectile]
				baby.explode()
