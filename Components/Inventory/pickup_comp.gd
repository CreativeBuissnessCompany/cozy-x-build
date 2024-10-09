# pickup_comp.gd
class_name PickupComp
extends Node2D


# Variable
@export var item:Item:
	set(value):
		item = value
		print(" Settin and Gettin")
		print(item.name)
		#if instance != null:
			#instance.queue_free()
			#instance = item.scene.instantiate()
			#add_child(instance)
			#print("Set Activated")

var instance: Node2D


func _ready() -> void:
	print(" Pickup is Ready.... ")
	instance = item.scene.instantiate()
	add_child(instance)



func _on_area_2d_body_entered(body: Player) -> void:
	
	if body is Player: 
		#print_debug("Got an %s!" % item.name)
		body.on_item_picked_up(item)
		self.queue_free()
	else:
		return
	
