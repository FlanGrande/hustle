extends CharacterState

const MIN_SPEED_RATIO = "0.5"
var MAX_SPEED_RATIO = "1.25"

export  var dir_x = 1
export  var dash_speed = 100
export  var fric = "0.05"

export  var speed_limit = "30"

var dist_ratio = "1.0"

func _enter():
	if data:
		if data.has("Distance"):
			data = data.Distance

func _frame_1():
	if dir_x < 0:
		MAX_SPEED_RATIO = "1.0"
		host.reset_momentum()
	else :
		MAX_SPEED_RATIO = "1.25"
		dist_ratio = fixed.add(fixed.div(str(data.x), "100"), "0.0")
	var dash_force = str(dir_x * dash_speed)
	host.apply_force_relative(fixed.mul(dash_force, fixed.add(fixed.mul(dist_ratio, fixed.sub(MAX_SPEED_RATIO, MIN_SPEED_RATIO)), MIN_SPEED_RATIO)), "0")
	host.apply_grav()

func _tick():
	host.apply_x_fric(fric)
	host.apply_grav()
	host.apply_forces()
	host.limit_speed(speed_limit)
