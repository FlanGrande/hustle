extends CharacterState

export var projectile_x = 18
export var projectile_y = -26

func _frame_7():
	host.throw_baby(projectile_x, projectile_y, data)
