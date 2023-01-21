extends Fighter

const MAX_ARMOR_PIPS = 1
const FLY_SPEED = "8"
const FLY_TICKS = 20
const GROUND_POUND_MIN_HEIGHT = -48
const LOIC_METER = 1000
const LOIC_GAIN = 7
const LOIC_GAIN_NO_ARMOR = 7

var armor_pips = 1
var landed_move = false
var flying_dir = null
var fly_ticks_left = 0
var fly_fx_started = false
var kill_process_super_level = 0
var start_fly = false
var can_ground_pound = false
var buffer_reset_ground_pound = false
var orbital_strike_out = false
var orbital_strike_projectile = null
var can_loic = true
var loic_meter = LOIC_METER
var got_hit = false
var armor_active = false
var buffer_armor = false
var can_unlock_gratuitous = true

onready var chainsaw_arm = $"%ChainsawArm"

onready var chainsaw_arm_ghosts = [

]

func _ready():
	chainsaw_arm.set_material(sprite.get_material())
	for ghost in chainsaw_arm_ghosts:
		ghost.set_material(sprite.get_material())

func init(pos=null):
	.init(pos)
	armor_pips = 1

func on_got_hit():
	if armor_active:
		got_hit = true
	else:
		if orbital_strike_projectile and orbital_strike_projectile in objs_map:
			objs_map[orbital_strike_projectile].disable()
			orbital_strike_out = false
			orbital_strike_projectile = null

func copy_to(f: BaseObj):
	.copy_to(f)
	f.armor_active = armor_active
	pass

func has_armor():
	return armor_active and !(current_state() is CharacterHurtState)

func incr_combo():
	if combo_count == 0:
		landed_move = true
	.incr_combo()
	if can_unlock_gratuitous and combo_moves_used.has("GroundSlam") and current_state().name != "GroundSlam":
		unlock_achievement("ACH_GRATUITOUS")
		can_unlock_gratuitous = false
		pass
	pass

func apply_grav():
	if flying_dir == null:
		.apply_grav()

func big_landing_effect():
	spawn_particle_effect_relative(preload("res://fx/LandingParticle.tscn"))
	play_sound("BigLanding")
	var camera = get_camera()
	if camera:
		camera.bump(Vector2.UP, 10, 20 / 60.0)

func tick():
	.tick()
	if got_hit:
		armor_pips = 0
		got_hit = false
		buffer_armor = false
		armor_active = false
#	if armor_active:
#		armor_pips = 0
	if landed_move:
		if not (current_state() is CharacterHurtState):
			armor_pips += 1
			if armor_pips > MAX_ARMOR_PIPS:
				armor_pips = MAX_ARMOR_PIPS
		landed_move = false
	if is_grounded():
		flying_dir = null
		if fly_fx_started:
			stop_fly_fx()
	if is_in_hurt_state():
		flying_dir = null
	if flying_dir != null and current_state().get("can_fly") != null and !current_state().can_fly:
		flying_dir = null
	if start_fly and flying_dir != null:
		fly_ticks_left = FLY_TICKS
		air_movements_left -= 1
		fly_fx_started = true
		start_fly = false
		start_fly_fx()
	if flying_dir:
		if !is_grounded():
			var fly_vel = fixed.normalized_vec_times(str(flying_dir.x), str(flying_dir.y), FLY_SPEED)
			set_vel(fly_vel.x, fixed.mul(fly_vel.y, "0.66"))
			fly_ticks_left -= 1
			if fly_ticks_left <= 0:
				flying_dir = null
				stop_fly_fx()
	if loic_meter < LOIC_METER:
		if armor_pips > 0:
			loic_meter += LOIC_GAIN
		else:
			loic_meter += LOIC_GAIN_NO_ARMOR
	if loic_meter >= LOIC_METER:
		if !can_loic:
			play_sound("LOICBeep")
		can_loic = true
		loic_meter = LOIC_METER
	else:
		can_loic = false
	
	if buffer_reset_ground_pound:
		buffer_reset_ground_pound = false
		can_ground_pound = false
	if is_grounded():
		buffer_reset_ground_pound = true

	if !can_ground_pound and get_pos().y < GROUND_POUND_MIN_HEIGHT and !is_in_hurt_state():
		can_ground_pound = true
		ground_pound_active_effect()


func ground_pound_active_effect():
	spawn_particle_effect_relative(preload("res://characters/robo/GroundPoundActiveEffect.tscn"), Vector2(0, -18))
	play_sound("GroundPoundBeep")
	pass
	
func start_fly_fx():
	$"%FlyFx1".start_emitting()
	$"%FlyFx2".start_emitting()

func stop_fly_fx():
	fly_fx_started = false
	$"%FlyFx1".stop_emitting()
	$"%FlyFx2".stop_emitting()

func process_extra(extra):
	.process_extra(extra)
	var can_fly = true
#	if current_state().get("can_fly") != null and current_state().can_fly == false:
#		can_fly = false
	if extra.has("fly_dir") and !is_grounded() and can_fly:
		if extra.has("fly_enabled") and extra.fly_enabled and air_movements_left > 0:
			var same_dir = flying_dir == null or (flying_dir.x == extra.fly_dir.x and flying_dir.y == extra.fly_dir.y)
			if flying_dir == null or !same_dir:
				start_fly = true
#			reset_momentum()
			flying_dir = extra.fly_dir
	if extra.has("armor_enabled") and armor_pips > 0:
		buffer_armor = extra.armor_enabled

func _on_state_exited(state):
	._on_state_exited(state)
	if buffer_armor:
		armor_active = true
		buffer_armor = false
		armor_pips = 0
	else:
		armor_active = false

func on_state_interruptable(state):
	.on_state_interruptable(state)
	armor_active = false
#
#func on_state_started(state):
#	.on_state_started(state)
#	flying_states_left -= 1
#	if flying_states_left == 0:
#		flying_dir = null
	


#func launched_by(hitbox):
#	if armor_pips > 0:
#		hitlag_ticks = hitbox.victim_hitlag + (COUNTER_HIT_ADDITIONAL_HITLAG_FRAMES if hitbox.counter_hit else 0)
#		hitlag_applied = hitlag_ticks
#		if hitbox.rumble:
#			rumble(hitbox.screenshake_amount, hitbox.victim_hitlag if hitbox.screenshake_frames < 0 else hitbox.screenshake_frames)
#
#		emit_signal("got_hit")
#		take_damage(hitbox.damage, hitbox.minimum_damage)
#		armor_pips -= 1
#	else:
#		.launched_by(hitbox)
