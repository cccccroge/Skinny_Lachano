extends KinematicBody2D

# Nodes
onready var anim = get_node("AnimatedSprite")

# External Variables
export(int) var BASE_SPEED
export(int) var SPEED

# Operational Variables
var dir = Vector2()
var vel = Vector2()
var key_rec = { "DOWN":false, "UP":false, "LEFT":false, "RIGHT":false }

# Overriding Functions
func _ready():
	# init animation
	change_animation_to("front_idle")
	anim.flip_h = false
	# init speed
	change_moving_speed(SPEED)
	
	set_process(true)
	set_process_input(true)

func _input(event):
	if event.is_action_type():
		if event.is_action_pressed("Down"):
			key_rec["DOWN"] = true
		elif event.is_action_released("Down"):
			key_rec["DOWN"] = false
		if event.is_action_pressed("Up"):
			key_rec["UP"] = true
		elif event.is_action_released("Up"):
			key_rec["UP"] = false
		if event.is_action_pressed("Left"):
			key_rec["LEFT"] = true
		elif event.is_action_released("Left"):
			key_rec["LEFT"] = false
		if event.is_action_pressed("Right"):
			key_rec["RIGHT"] = true
		elif event.is_action_released("Right"):
			key_rec["RIGHT"] = false

func _process(delta):
	dir = Vector2(0, 0)
	if key_rec["UP"] == true:
		dir.y -= 1
	if key_rec["DOWN"] == true:
		dir.y += 1
	if key_rec["LEFT"] == true:
		dir.x -= 1
	if key_rec["RIGHT"] == true:
		dir.x += 1 
	vel = dir.normalized() * SPEED
	
	# change position by velocity
	self.position += vel * delta
	
	# change animation by velocity
	if vel.length() == 0 and anim.animation != "front_idle":
		change_animation_to("front_idle")
		anim.flip_h = false
	elif vel.length() != 0:
		if vel.x > 0 and vel.y == 0:
			change_animation_to("side_move")
			anim.flip_h = false
		elif vel.x < 0 and vel.y == 0:
			change_animation_to("side_move")
			anim.flip_h = true
		elif vel.y > 0 and vel.x == 0:
			change_animation_to("front_move")
			anim.flip_h = false
		elif vel.y < 0 and vel.x == 0:
			change_animation_to("behind_move")
			anim.flip_h = false
	

# Custom Functions
func change_animation_to(name):
	anim.play(name)

func change_moving_speed(speed):
	anim.frames.set_animation_speed("side_move", SPEED / BASE_SPEED * 60)
	anim.frames.set_animation_speed("front_move", SPEED / BASE_SPEED * 60)
	anim.frames.set_animation_speed("behind_move", SPEED / BASE_SPEED * 60)

