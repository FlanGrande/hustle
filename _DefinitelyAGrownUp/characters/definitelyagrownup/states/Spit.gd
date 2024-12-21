extends CharacterState

const MOMENTUM_REDUCTION_X = "0.75"
const MOMENTUM_REDUCTION_Y = "0.75"

const GROUNDED_SPEED = "7.5"
const AERIAL_SPEED = "7"

const STARTUP_LAG = 3

export(PackedScene) var projectile
export var projectile_x = 16
export var projectile_y = -16
export var speed_modifier_amount = "2.0"
export var push_back_amount = "-2.0"

var speed_modifier
var startup_lag = 0

var projectile_spawned = false

var dir

func _enter():
	startup_lag = STARTUP_LAG

func _frame_0():
	var vel = host.get_vel()
	var new_vel_x = fixed.mul(vel.x, MOMENTUM_REDUCTION_X)
	var new_vel_y = fixed.mul(vel.y, MOMENTUM_REDUCTION_Y)
	host.set_vel(new_vel_x, new_vel_y)
	
	if data:
		dir = xy_to_dir(data.x, data.y)
	
	projectile_spawned = false

func _frame_5():
	projectile_spawned = true
	var object = host.spawn_object(projectile, projectile_x, projectile_y, true, {"dir": dir})

#func process_projectile(obj):
#	var force = xy_to_dir(data.x, data.y, GROUNDED_SPEED)
#	obj.set_grounded(false)
#	obj.apply_force(force.x, force.y)

# TO DO: is usable
