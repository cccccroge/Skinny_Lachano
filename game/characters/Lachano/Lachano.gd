extends KinematicBody2D

export(int) var SPEED
export(float) var ANIM_SPEED_RATIO

onready var anim := get_node("AnimatedSprite")
onready var ANIM_SPEED = SPEED * ANIM_SPEED_RATIO
var key_rec := {}

func _init():
	create_key_records()

func _ready():
	change_animation_to("front_idle", Vector2())
	change_anim_speed(ANIM_SPEED)

func _unhandled_input(event):
	if !event.is_action_type():
		return
	record_key_records(event)

func _physics_process(_delta):
	var vel := cal_velocity()
	move_and_slide(vel)
	change_animation_by_vel(vel)

func create_key_records():
	for action in InputMap.get_actions():
		if action.find("char_") == 0:
			key_rec[action] = false

func record_key_records(event):
	for key in key_rec:
		if event.is_action_pressed(key):
			key_rec[key] = true
		elif event.is_action_released(key):
			key_rec[key] = false

func change_animation_to(anim_name, velocity):
	anim.play(anim_name)
	anim.flip_h = (velocity.x < 0 and velocity.y == 0)

func change_anim_speed(speed):
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
	return dir.normalized() * SPEED

func change_animation_by_vel(vel):
	if vel.length() == 0:
		if anim.animation != "front_idle":
			change_animation_to("front_idle", vel)
	else:
		if vel.x > 0 and vel.y == 0:
			change_animation_to("side_move", vel)
		elif vel.x < 0 and vel.y == 0:
			change_animation_to("side_move", vel)
		elif vel.y > 0 and vel.x == 0:
			change_animation_to("front_move", vel)
		elif vel.y < 0 and vel.x == 0:
			change_animation_to("behind_move", vel)
