# vending_machine.gd
extends Interactable




# @exports ....
# Resource holding Inventory
@export var vending_inventory: InventoryResource







func _unhandled_key_input(_event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("interact"):
		if self.area_2d.overlaps_body(player):
			
			# Goes to UIRoot.gd in Universe.tscn
			Signalbus.open_object_with_inventory.emit(vending_inventory)
		else:
			return
			#print(" Vending Machine Thinks You want to interact with it! ")


func _on_area_2d_body_entered(body: Node2D) -> void:
	
	
	if body is Player:
		player = body
	
