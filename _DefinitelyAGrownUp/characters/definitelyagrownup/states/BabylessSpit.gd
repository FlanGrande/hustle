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
	var baby = host.objs_map[host.baby_projectile]
	
	if data:
		dir = xy_to_dir(data.x, data.y)
	
	projectile_spawned = true
	baby.spawn_object(projectile, 0, 0, true, {"dir": dir})
	# TO DO: Change spawn origin if the baby is standing and later on if it's on super mode

func is_usable():
	return .is_usable() and host.baby_projectile and host.is_babyless and not host.is_baby_exploding 
