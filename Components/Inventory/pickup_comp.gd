# pickup_comp.gd
extends Node2D


# Variable
@export var item:Item



func _ready() -> void:
	
	var instance = item.scene.instantiate()
	add_child(instance)



func _on_area_2d_body_entered(body: Player) -> void:
	
	if body is Player: 
		#print_debug("Got an %s!" % item.name)
		body.on_item_picked_up(item)
		self.queue_free()
	else:
		return
	
