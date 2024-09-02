class_name InventoryDialog
extends PanelContainer


@export var item_slot_scene:PackedScene

@onready var grid_container: GridContainer = %GridContainer
@onready var item_desc_label: RichTextLabel = %ItemDescRichTextLabel



func _ready() -> void:
	pass


# What node is using this? Player.gd ... 
func open(inventory:Inventory):
	
	self.visible = !self.visible
	
	
	for child in grid_container.get_children():
		child.queue_free()
	
	for item in inventory.get_items():
		var slot: ItemSlot = item_slot_scene.instantiate()
		grid_container.add_child(slot)
		slot.display(item)
		# Connect Slot
		slot.on_item_button_pressed.connect(_on_item_button_pressed)
		# Fill Data
		slot.item_description = item.description




func _on_item_button_pressed(item_description):
		print_debug("Received " + item_description )
		item_desc_label.text = item_description
		pass


func _on_close_button_pressed() -> void:
	hide()
