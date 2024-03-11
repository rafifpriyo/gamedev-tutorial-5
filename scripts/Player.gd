extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var _walk_sprite = $AnimatedSprite
onready var _sound_effect = $AudioStreamPlayer2D
var animation_name = 'idle'
var animation_direction = 'right'
var sound_name = 'idle'
var sound_playing = false
var props: Dictionary = {
	"contact_with_npc": false
}

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
		if animation_direction == 'right':
			_walk_sprite.play("jump_right")
		elif animation_direction == 'left':
			_walk_sprite.play("jump_left")
		animation_name = 'jump'
		
		velocity.y = jump_speed
		is_second_jump = false
	elif is_on_floor() and animation_name == 'jump':
		animation_name = 'idle'
		if animation_direction == 'right':
			_walk_sprite.play("idle_right")
		elif animation_direction == 'left':
			_walk_sprite.play("idle_left")
	
	if not is_on_floor() and not is_second_jump and Input.is_action_just_pressed('ui_up'):
		velocity.y = jump_speed_second
		is_second_jump = true
	
	if is_on_floor() and Input.is_action_pressed('ui_down'):
		if animation_direction == 'right':
			_walk_sprite.play("crouch_right")
		elif animation_direction == 'left':
			_walk_sprite.play("crouch_left")
		animation_name = 'crouch'
		is_crouching = true
	elif animation_name == 'crouch':
		animation_name = 'idle'
		if animation_direction == 'right':
			_walk_sprite.play("idle_right")
		elif animation_direction == 'left':
			_walk_sprite.play("idle_left")
		is_crouching = false
	
	if Input.is_action_pressed('ui_right'):
		if not animation_name == 'jump' and not animation_name == 'crouch':
			_walk_sprite.play("walk_right")
			animation_name = 'walk_right'
			sound_name = 'walk'
		elif animation_name == 'jump':
			_walk_sprite.play("jump_right")
		animation_direction = 'right'
		if is_crouching:
			velocity.x += speed_crouch
		else:
			velocity.x += speed
	elif animation_name == 'walk_right':
		animation_name = 'idle'
		sound_name = 'walk'
		_walk_sprite.play('idle_right')
	
	if Input.is_action_pressed('ui_left'):
		if not animation_name == 'jump' and not animation_name == 'crouch':
			_walk_sprite.play("walk_left")
			animation_name = 'walk_left'
			sound_name = 'walk'
		elif animation_name == 'jump':
			_walk_sprite.play("jump_left")
		animation_direction = 'left'
		if is_crouching:
			velocity.x -= speed_crouch
		else:
			velocity.x -= speed
	elif animation_name == 'walk_left':
		animation_name = 'idle'
		_walk_sprite.play('idle_left')
		
	if sound_name == 'walk' and not (animation_name == 'walk_left' or animation_name == 'walk_right'):
		_sound_effect.stop()
		sound_playing = false
		sound_name = 'idle'
	elif sound_name == 'walk' and not sound_playing:
		_sound_effect.stream = load(str("res://assets/Sound/" + "Walk" + ".wav"))
		_sound_effect.play()
		sound_playing = true
		
	if props["contact_with_npc"] and animation_name == 'idle':
		if animation_direction == 'right':
			_walk_sprite.play("talk_right")
		elif animation_direction == 'left':
			_walk_sprite.play("talk_left")
	elif animation_name == 'idle':
		if animation_direction == 'right':
			_walk_sprite.play("idle_right")
		elif animation_direction == 'left':
			_walk_sprite.play("idle_left")


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
