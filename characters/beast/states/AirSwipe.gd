extends BeastState

const HIT_LIFT = "-7"

func _on_hit_something(obj, hitbox):
	._on_hit_something(obj, hitbox)
	var vel = host.get_vel()
	host.set_vel(vel.x, HIT_LIFT)
