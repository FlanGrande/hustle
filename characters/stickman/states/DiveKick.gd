extends CharacterState

const MOMENTUM_REDUCTION = "0.75"

export var move_x = 3
export var move_y = 3

export var x_modifier_amount = 2
export var y_modifier_amount = 2

export var grounded = false

var move_x_modifier = 0
var move_y_modifier = 0

var moving = false

onready var hitbox = $Hitbox

func _frame_0():
	if !(data is Dictionary):
		data = {
			x = 1,
			y = 1,
		}
	if !grounded:
		var vel = host.get_vel()
		var new_vel = fixed.mul(vel.x, MOMENTUM_REDUCTION)
		host.set_vel(new_vel, "0")
	else:
		anim_name = "DiveKick2"
		
		hitbox.y = -9
		
		hitbox.dir_y = "1.0"
		
		if data.y < 0:
			hitbox.dir_y = "-1.0"
			anim_name = "DiveKick2Up"
			hitbox.y -= 16
			
	moving = false
	move_x_modifier = abs(data.x) * x_modifier_amount
	move_y_modifier = data.y * y_modifier_amount

func _frame_4():
	if grounded:
		spawn_particle_relative(particle_scene, Vector2(), Vector2(0, -1))

func _frame_11():
	host.reset_momentum()
	host.apply_force_relative(move_x + move_x_modifier, move_y + move_y_modifier)

func _frame_12():
#	host.update_facing()
	moving = true
	
func _on_hit_something(obj, hitbox):
	._on_hit_something(obj, hitbox)
	if grounded:
#		host.reset_momentum()
		if data.y >= 0:
			host.set_vel(host.get_vel().x, "0")
		else:
			var move_y_amount = Utils.int_sign(data.y) * move_y + move_y_modifier
			move_y_amount = fixed.mul(str(move_y_amount), "0.6")
			host.set_vel(host.get_vel().x, move_y_amount)
		moving = false
		queue_state_change("Fall")
	pass

func _tick():
	if !grounded and current_tick == 3:
		if host.initiative:
			current_tick = 9

	if grounded and data.y < 0 and current_tick == 5:
		current_tick = 8

	var move_amount = "1.0"
	if data.y < 0:
		move_amount = "0.6"
	
	var move_x_amount = move_x + move_x_modifier
	var move_y_amount = Utils.int_sign(data.y) * move_y + move_y_modifier

	move_x_amount = fixed.round(fixed.mul(str(move_x_amount), move_amount))
	move_y_amount = fixed.round(fixed.mul(str(move_y_amount), move_amount))

	if moving:
		host.move_directly_relative(move_x_amount, move_y_amount)
	else:
		host.apply_forces()
	
#	print(move_x + move_x_modifier, move_y + move_y_modifier)
	
	
	if host.is_grounded() and current_tick > 5:
		host.reset_momentum()
		host.apply_force_relative((move_x + move_x_modifier) / 2, 0)
		return "Landing"
