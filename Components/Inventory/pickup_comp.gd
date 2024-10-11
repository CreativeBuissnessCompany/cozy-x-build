# pickup_comp.gd
class_name PickupComp
extends Node2D


# Variable
@export var item:Item:
	set(value):
		item = value

var instance: Node2D
var ITEM_TYPE_SEED: int = 1






func _ready() -> void:
	print(item.name," is Ready.... ")
	instance = item.scene.instantiate()
	
	# Set offset if SEED type of item 
	if item.item_type == ITEM_TYPE_SEED:
		#print(item.item_type)
		instance.global_position += Vector2(0,-15) 
	
	
	add_child(instance)

func _on_area_2d_body_entered(body: Player) -> void:
	
	if body is Player: 
		#print_debug("Got an %s!" % item.name)
		body.on_item_picked_up(item)
		self.queue_free()
	else:
		return
	
