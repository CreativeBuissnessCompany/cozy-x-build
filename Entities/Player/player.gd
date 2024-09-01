### Player.gd
class_name Player

extends CharacterBody2D

# Notes: 
# 1. In group " Player "


# Variables 
@export var speed = 250
@export var camera_node: Camera2D 


var inventory:Inventory = Inventory.new()




func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()

func _input(event: InputEvent) -> void:
	
	camera_zoom()



func on_item_picked_up(item:Item):
	inventory.add_item(item)
	


func camera_zoom():
	
	if Input.is_action_just_pressed("zoom_in"):
		camera_node.zoom += Vector2(0.5,0.5)
	
	elif Input.is_action_just_pressed("zoom_out"):
		camera_node.zoom -= Vector2(0.1,0.1)


func get_input():
	var input_direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = input_direction * speed
