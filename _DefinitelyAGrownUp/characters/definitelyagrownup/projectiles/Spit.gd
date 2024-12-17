extends BaseProjectile

# TO DO: Not used yet
var dir_x = "0"
var dir_y = "0"

func _ready():
	state_variables.append_array(
		["dir_x", "dir_y"]
	)

func hit_by(hitbox):
	.hit_by(hitbox)
	var host = obj_from_name(hitbox.host)
	if host:
		if host.is_in_group("Fighter"):
			disable()
