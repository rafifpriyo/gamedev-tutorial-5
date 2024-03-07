extends Area2D

onready var _walk_sprite = $AnimatedSprite
onready var _player = self.get_parent().get_node("Player")
var animation_name = 'idle'
var animation_direction = 'right'
var contact_with_player = false

func compare_player_position(player_position):
	if (player_position.x > self.global_position.x):
		animation_direction = 'right'
	elif (player_position.x < self.global_position.x):
		animation_direction = 'left'

func get_animation():
	if _player in self.get_overlapping_bodies():
		contact_with_player = true
		_player.props["contact_with_npc"] = true
	else:
		contact_with_player = false
		_player.props["contact_with_npc"] = false
	if contact_with_player:
		if animation_direction == 'right':
			_walk_sprite.play("talk_right")
		elif animation_direction == 'left':
			_walk_sprite.play("talk_left")
	else:
		if animation_direction == 'right':
			_walk_sprite.play("idle_right")
		elif animation_direction == 'left':
			_walk_sprite.play("idle_left")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var player_position = _player.global_position
	compare_player_position(player_position)
	get_animation()
