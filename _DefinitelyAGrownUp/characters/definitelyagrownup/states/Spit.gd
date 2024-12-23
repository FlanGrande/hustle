extends CharacterState

const STARTUP_LAG = 3

export(PackedScene) var projectile
export var projectile_x = 16
export var projectile_y = -16

var speed_modifier
var startup_lag = 0

var projectile_spawned = false

var dir

func _enter():
	startup_lag = STARTUP_LAG

func _frame_0():
	var vel = host.get_vel()
	
	if data:
		dir = xy_to_dir(data.x, data.y)
	
	projectile_spawned = false

func _frame_5():
	projectile_spawned = true
	var object = host.spawn_object(projectile, projectile_x, projectile_y, true, {"dir": dir})

# TO DO: is usable
