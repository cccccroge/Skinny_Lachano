extends KinematicBody2D

signal vel_changed

export(int) var SPEED
export(int) var LOWEST_SPEED
export(float) var BONE_RATIO_CAUSE_SPEED_DROP
export(float) var ANIM_SPEED_RATIO

onready var anim := $AnimatedSprite
onready var statuses := $MainStatuses

var key_rec := {}
var vel := Vector2()

func _init():
	create_key_records()

func _ready():
	change_animation_to("front_idle", vel)
	change_move_anim_speed(SPEED * ANIM_SPEED_RATIO)
	
func _unhandled_input(event):
	if !event.is_action_type():
		return
	record_key_records(event)

func _physics_process(_delta):
	var prev_vel := vel
	vel = cal_velocity()
	var _vel := move_and_slide(vel)
	
	if vel == prev_vel:
		return
	emit_signal("vel_changed", vel)
	trigger_healing_mech(vel, prev_vel)
	change_animation_by_vel(vel)
	change_move_anim_speed(vel.length() * ANIM_SPEED_RATIO)

func create_key_records():
	for action in InputMap.get_actions():
		if action.find("char_") == 0:
			key_rec[action] = false

func record_key_records(event: InputEvent):
	for key in key_rec:
		if event.is_action_pressed(key):
			key_rec[key] = true
		elif event.is_action_released(key):
			key_rec[key] = false

func change_animation_to(anim_name: String, velocity: Vector2):
	anim.play(anim_name)
	anim.flip_h = (velocity.x < 0 and velocity.y == 0)

func change_move_anim_speed(speed: float):
	anim.frames.set_animation_speed("side_move", speed)
	anim.frames.set_animation_speed("front_move", speed)
	anim.frames.set_animation_speed("behind_move", speed)

func cal_velocity() -> Vector2:
	var dir := Vector2(0, 0)
	if key_rec["char_up"]:
		dir.y -= 1
	if key_rec["char_down"]:
		dir.y += 1
	if key_rec["char_left"]:
		dir.x -= 1
	if key_rec["char_right"]:
		dir.x += 1
		
	var factor := get_speed_factor_from_bone()
	return dir.normalized() * SPEED * factor

func get_speed_factor_from_bone() -> float:
	var r = statuses.status["bone"] / statuses.max_status["bone"]
	if r > BONE_RATIO_CAUSE_SPEED_DROP:
		return 1.0
	else:
		var base_factor = LOWEST_SPEED / float(SPEED)
		var remain = (1 - base_factor) * (r / BONE_RATIO_CAUSE_SPEED_DROP)
		return base_factor + remain

func trigger_healing_mech(velocity: Vector2, prev_vel: Vector2):
	if prev_vel.length() != 0 and velocity.length() == 0:
		statuses.start_heal_timer()
	elif prev_vel.length() == 0 and velocity.length() != 0:
		statuses.stop_heal_timer()
		statuses.stop_healing()

func change_animation_by_vel(velocity: Vector2):
	if velocity.length() == 0:
		if anim.animation != "front_idle":
			change_animation_to("front_idle", velocity)
	else:
		if velocity.x > 0 and velocity.y == 0:
			change_animation_to("side_move", velocity)
		elif velocity.x < 0 and velocity.y == 0:
			change_animation_to("side_move", velocity)
		elif velocity.y > 0 and velocity.x == 0:
			change_animation_to("front_move", velocity)
		elif velocity.y < 0 and velocity.x == 0:
			change_animation_to("behind_move", velocity)
