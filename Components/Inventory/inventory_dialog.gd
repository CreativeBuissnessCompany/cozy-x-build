class_name InventoryDialog
extends PanelContainer


@export var item_slot_scene:PackedScene

@onready var grid_container: GridContainer = %GridContainer
@onready var item_desc_label: RichTextLabel = %ItemDescRichTextLabel


# What node is using this? Player.gd ... 
func open(inventory:Inventory):
	
	self.visible = !self.visible
	
	
	for child in grid_container.get_children():
		child.queue_free()
	
	for item in inventory.get_items():
		var slot = item_slot_scene.instantiate()
		grid_container.add_child(slot)
		slot.display(item)
	



func _on_close_button_pressed() -> void:
	hide()
