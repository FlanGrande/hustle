extends BeastState

func _frame_0():
#	host.disable_collisions()
	host.colliding_with_opponent = false
	pass

func _frame_10():
	host.colliding_with_opponent = true
	pass