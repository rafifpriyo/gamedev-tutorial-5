extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (int) var speed = 400
export (int) var speed_crouch = 200
export (int) var jump_speed = -600
export (int) var jump_speed_second = -400
export (int) var GRAVITY = 1200

const UP = Vector2(0, -1)

var velocity = Vector2()
var is_second_jump = false
var is_crouching = false

func get_input():
	velocity.x = 0
	if is_on_floor() and Input.is_action_just_pressed('ui_up'):
		velocity.y = jump_speed
		is_second_jump = false
	if not is_on_floor() and not is_second_jump and Input.is_action_just_pressed('ui_up'):
		velocity.y = jump_speed_second
		is_second_jump = true
	if is_on_floor() and Input.is_action_pressed('ui_down'):
		is_crouching = true
	else:
		is_crouching = false
	
	if Input.is_action_pressed('ui_right'):
		if is_crouching:
			velocity.x += speed_crouch
		else:
			velocity.x += speed
	
	if Input.is_action_pressed('ui_left'):
		if is_crouching:
			velocity.x -= speed_crouch
		else:
			velocity.x -= speed


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	velocity.y  += delta * GRAVITY
	get_input()
	velocity = move_and_slide(velocity, UP)
