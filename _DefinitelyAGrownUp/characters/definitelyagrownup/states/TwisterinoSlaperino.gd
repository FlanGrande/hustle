extends CharacterState

onready var hitbox = $Hitbox

# TO DO: slider? Wheel?
# TO DO: Babyless mode with smaller hitbox and babyless, maybe the baby goes jumps bit too

export var force_y = "0.0"
export var twist_upwards_momentum_factor = "-0.008"
export var twist_upwards_momentum_ticks = 12

export var base_hitbox_height = 22
export var base_hitbox_y = -22

export var babyless_hitbox_height = 16
export var babyless_hitbox_y = -16

var current_ticks = 0
var got_hit = false

func _enter():
	force_y = "0.0"
	current_ticks = 0
	got_hit = false
	hitbox.hitstun_ticks = 20
	host.end_projectile_repelling()

func _tick():
	var dir_x = "1.0"
	var force_x = fixed.mul("0.5", dir_x)
	force_y = fixed.add(force_y, twist_upwards_momentum_factor)
	
	if not host.is_babyless:
		hitbox.height = base_hitbox_height
		hitbox.y = base_hitbox_y
	else:
		hitbox.height = babyless_hitbox_height
		hitbox.y = babyless_hitbox_y
	
	if current_ticks < twist_upwards_momentum_ticks:
		host.apply_force_relative(force_x, force_y)
		#host.apply_forces()
	
	host.colliding_with_opponent = false
	host.update_data()
	current_ticks += 1

func _frame_7():
	host.start_projectile_repelling()

func _frame_10():
	if not got_hit:
		host.has_hyper_armor = true

func _frame_42():
	host.has_hyper_armor = false
	host.end_projectile_repelling()

func on_got_hit():
	hitbox.hitstun_ticks = 25
	got_hit = true
	feinting = false
	host.feinting = false
