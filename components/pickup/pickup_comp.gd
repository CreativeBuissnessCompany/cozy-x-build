# pickup_comp.gd
class_name PickupComp
extends Node2D


# Variables
@export var item:Item:
	set(value):
		item = value

var ITEM_TYPE_SEED: int = 1
var ITEM_TYPE_RESIZE: int = 2
var animated_sprite2d := AnimatedSprite2D.new()





# Script_Start
func _ready() -> void:
	#print(item.name," is Ready.... ")
	
	var sprite_frame: SpriteFrames = item.sprite_frame
	
	# Set offset if SEED type of item 
	if item.item_type == ITEM_TYPE_SEED:
		
		#animated_sprite2d.global_position += Vector2(0,-15) 
		pass
		
	if item.item_type == ITEM_TYPE_RESIZE:
		self.scale = Vector2(0.5,0.5)
		pass
	
	
	# NOTE New ......Testing....
	if item.sprite_frame:
		animated_sprite2d.sprite_frames = item.sprite_frame
	
	add_child(animated_sprite2d)





func _on_area_2d_body_entered(body: Player) -> void:
	
	if body is Player: 
		#print_debug("Got an %s!" % item.name)
		body.on_item_picked_up(item)
		self.queue_free()
	else:
		return
	
