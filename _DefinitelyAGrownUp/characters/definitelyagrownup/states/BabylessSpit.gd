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
	var projectile_x = 0
	var projectile_y = 0
	
	if data:
		dir = xy_to_dir(data.x, data.y)
	
	# TO DO: We could finesse the positions based on the selected dir
	if baby.is_grounded():
		projectile_y = -12
	
	if dir.x != "0":
		baby.set_facing(1 if fixed.gt(dir.x, "0") else - 1)
	
	projectile_spawned = true
	baby.spawn_object(projectile, projectile_x, projectile_y, true, {"dir": dir})

func is_usable():
	return .is_usable() and host.baby_projectile and host.is_babyless and not host.is_baby_exploding 
