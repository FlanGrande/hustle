extends PlayerExtra

var current_dir = null

func _ready():
	$"%FlyDir".connect("data_changed", self, "emit_signal", ["data_changed"])
	$"%FlyEnabled".connect("pressed", self, "emit_signal", ["data_changed"])

func get_extra():
	current_dir = $"%FlyDir".get_dir()
	return {
		"fly_dir": $"%FlyDir".get_data(),
		"fly_enabled": $"%FlyEnabled".pressed
	}

func show_options():
	$"%FlyDir".hide()
	$"%FlyEnabled".hide()
	$"%FlyDir".set_dir("Neutral")
	$"%FlyDir".facing = fighter.get_opponent_dir()
	$"%FlyDir".init()
	if current_dir:
		$"%FlyDir".set_dir(current_dir)
#	$"%FlyEnabled".set_pressed_no_signal(false)
	if fighter.is_grounded():
		$"%FlyDir".hide()
		$"%FlyEnabled".hide()
	else:
		if fighter.air_movements_left > 0:
			$"%FlyDir".show()
			$"%FlyEnabled".show()
			$"%FlyEnabled".set_pressed_no_signal(fighter.fly_ticks_left > 0)
	return

func reset():
#	if current_dir:
#		$"%FlyDir".set_dir(current_dir)
#	$"%FlyEnabled".set_pressed_no_signal(false)
	pass