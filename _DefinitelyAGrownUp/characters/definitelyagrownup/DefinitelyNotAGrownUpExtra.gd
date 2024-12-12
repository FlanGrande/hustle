extends PlayerExtra

onready var comeback_button = $"%ComebackButton"
onready var explode_button = $"%ExplodeButton"


func _ready():
	comeback_button.connect("toggled", self, "_on_comeback_button_toggled")
	explode_button.connect("toggled", self, "_on_explode_button_toggled")

func on_data_changed():
	pass

func _on_comeback_button_toggled(on):
	if on:
		comeback_button.set_pressed_no_signal(true)
	else:
		comeback_button.set_pressed_no_signal(false)
	
	emit_signal("data_changed")

func _on_explode_button_toggled(on):
	if on:
		explode_button.set_pressed_no_signal(true)
	else:
		explode_button.set_pressed_no_signal(false)
	
	emit_signal("data_changed")

func reset():
	comeback_button.set_pressed_no_signal(false)
	explode_button.set_pressed_no_signal(false)
	pass

func show_options():
	comeback_button.hide()
	explode_button.hide()

	if fighter.can_baby_come_back():
		comeback_button.show()
		
	if fighter.can_baby_explode():
		explode_button.show()

func get_extra():
	var extra = {
		"comeback": comeback_button.pressed,
		"explode": explode_button.pressed
	}
	
	return extra
