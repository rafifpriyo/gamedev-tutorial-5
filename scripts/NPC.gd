extends Area2D

onready var _walk_sprite = $AnimatedSprite
onready var _sound_effect = $AudioStreamPlayer2D
onready var _player = self.get_parent().get_node("Player")
var animation_name = 'idle'
var animation_direction = 'right'
var contact_with_player = false
var sound_playing = false

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
		
		if not sound_playing:
			_sound_effect.stream = load(str("res://assets/Sound/" + "Preview (Female)" + ".ogg"))
			_sound_effect.play()
			sound_playing = true
	else:
		if animation_direction == 'right':
			_walk_sprite.play("idle_right")
		elif animation_direction == 'left':
			_walk_sprite.play("idle_left")
			
		if sound_playing:
			_sound_effect.stop()
			sound_playing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var player_position = _player.global_position
	compare_player_position(player_position)
	get_animation()
