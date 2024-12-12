extends BaseProjectile

class_name BaseBoomerangKidProjectile

# Comeback Options
export var _c_Comeback_Options = 0
export var retrieve_despawn_cooldown = 16
export var retrieve_despawn_distance = "24"
export var come_back_turn_speed = "5"
export var come_back_speed = "16"

export var base_baby_scale = 1.0
export var base_baby_damage_modifier = 1.0

export var super_baby_mode_transformation_ticks = 15
export var super_baby_scale = 2.0
export var super_baby_damage_modifier = 2.0

var is_super_baby = false

func explode():
	change_state("Explode")

func disable():
	.disable()
	creator.baby_projectile = null

func copy_to(f:BaseObj):
	.copy_to(f)
	f.scale.x = scale.x
	f.scale.y = scale.y
	f.is_super_baby = is_super_baby

func set_is_coming_back(new_value):
	creator.is_baby_coming_back = new_value
	
	if creator.is_baby_coming_back:
		if creator.baby_projectile:
			var baby = creator.objs_map[creator.baby_projectile]
			baby.refresh_hitboxes()
			baby.retrieve_despawn_cooldown = 0
			
			if current_state().state_name != "Default":
				change_state("Default")

func punch():
	if not creator.is_baby_coming_back_toggled and not creator.is_baby_exploding:
		change_state("Punch")

func kick(direction):
	if not creator.is_baby_coming_back_toggled and not creator.is_baby_exploding:
		change_state("Kick", {dir = direction})

func super_punch(direction):
	if not creator.is_baby_coming_back_toggled and not creator.is_baby_exploding and is_super_baby:
		change_state("SuperPunch", {dir = direction})

func fizzle():
	creator.change_stance_to("Normal")
	creator.is_babyless = false
	creator.is_baby_coming_back = false
	creator.is_baby_exploding = false
	creator.is_in_super_baby_mode = false
	is_super_baby = false
	disable()

func enter_super_baby_mode():
	is_super_baby = true
	scale.x = super_baby_scale
	scale.y = super_baby_scale

func exit_super_baby_mode():
	is_super_baby = false
	scale.x = base_baby_scale
	scale.y = base_baby_scale
