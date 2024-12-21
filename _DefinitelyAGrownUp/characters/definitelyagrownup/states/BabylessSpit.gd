extends CharacterState

const STARTUP_LAG = 3

export(PackedScene) var projectile
var projectile_x = 0
var projectile_y = 0

var speed_modifier
var startup_lag = 0

var projectile_spawned = false

var dir

func _enter():
	startup_lag = STARTUP_LAG
	projectile_spawned = false

func _frame_0():
	var baby_position = host.objs_map[host.baby_projectile].get_pos()
	projectile_x = baby_position.x
	projectile_y = baby_position.y
	
	if data:
		dir = xy_to_dir(data.x, data.y)
	
	projectile_spawned = true
	var object = host.spawn_object(projectile, projectile_x, projectile_y, true, {"dir": dir})

# TO DO: is usable
