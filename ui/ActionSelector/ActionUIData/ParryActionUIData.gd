extends ActionUIData

onready var melee_parry_timing = $"Melee Parry Timing"
onready var h_slider = $"Melee Parry Timing/HSlider"
onready var block_height = $"Block Height"

func init():
	block_height.set_height(true)
	on_button_selected()

func on_button_selected():
	var button = action_buttons.opponent_action_buttons.current_button
	if button:
		if button.get("earliest_hitbox") != null:
			h_slider.value = clamp(button.earliest_hitbox, 1, melee_parry_timing.max_value)
			if button.state and button.state.get("earliest_hitbox_node") != null:
				var hit_height = button.state.earliest_hitbox_node.hit_height
				block_height.set_height(hit_height != Hitbox.HitHeight.Low)
