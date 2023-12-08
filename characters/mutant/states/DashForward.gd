extends "res://characters/states/Dash.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func spawn_dash_particle():
	if !same_as_last_state:
		.spawn_dash_particle()

func spawn_enter_particle():
	if !same_as_last_state:
		.spawn_enter_particle()

func play_enter_sfx():
	if !same_as_last_state:
		.play_enter_sfx()

# Called when the node enters the scene tree for the first time.
func _enter():
	._enter()
	if !host.sprite.is_connected("frame_changed", self, "on_sprite_frame_changed"):
		host.sprite.connect("frame_changed", self, "on_sprite_frame_changed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_sprite_frame_changed():
	if !active:
		return
	if host.sprite.frame == 2 or host.sprite.frame == 5:
		host.play_sound("Walk1")
	if host.sprite.frame == 3 or host.sprite.frame == 0:
		host.play_sound("Walk2")