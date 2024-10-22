### Player.gd
@icon("res://themes/editor_icons/player_icon.png")
class_name Player extends CharacterBody2D

# Notes: 
# 1. In group " Player "

# Variables 
@export var speed = 250
@export var camera_node: Camera2D 
@export var sfx_step_interval: float 
# For sfx purposes...
var time_elapsed: float

var inventory:Inventory = Inventory.new()

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer







# Script_Start
func _ready() -> void:
	# Send self to SceneManager
	#print("Player: Ready")
	scene_manager.player = self


func _physics_process(_delta: float) -> void:
	get_input()
	move_and_slide()
	walk_sound(_delta)


func _unhandled_input(_event: InputEvent) -> void:
	# Custom Funcs
	camera_zoom()
	quit_game()
	


func walk_sound(delta) -> void:
	
	var input_direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if input_direction != Vector2(0,0):
		time_elapsed += delta
		if time_elapsed > sfx_step_interval:
			if !audio_stream_player.playing:
				audio_stream_player.play()
	else:
		audio_stream_player.stop()
		time_elapsed = 0.0



func on_item_picked_up(item:Item):
	inventory.add_item(item)


func camera_zoom():
	
	if Input.is_action_just_pressed("zoom_in"):
		var tween = get_tree().create_tween()
		tween.tween_property(camera_node, "zoom", Vector2(0.5,0.5),0.5 )
		#camera_node.zoom += Vector2(0.5,0.5)
	
	elif Input.is_action_just_pressed("zoom_out"):
		var tween = get_tree().create_tween()
		tween.tween_property(camera_node, "zoom", Vector2(1,1),0.5 )
		camera_node.zoom -= Vector2(0.1,0.1)


func get_input():
	var input_direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = input_direction * speed


func quit_game()->void:
	# Shift + Esc. 
	if Input.is_action_just_released("quit_game"):
		get_tree().quit() 
