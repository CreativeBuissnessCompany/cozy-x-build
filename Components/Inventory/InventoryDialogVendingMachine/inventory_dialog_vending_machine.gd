class_name InventoryDialogVendingMachine
extends PanelContainer


@export var item_slot_scene:PackedScene

@onready var grid_container: GridContainer = %GridContainer
# Name ...
@onready var item_desc_label: RichTextLabel = %ItemDescRichTextLabel



func _ready() -> void:
	pass


# What node is using this? Player.gd ... 
func open(inventory:Inventory):
	
	self.visible = !self.visible
	
	
	for child in grid_container.get_children():
		child.queue_free()
	
	for item in inventory.get_items():
		var slot: ItemSlotVending = item_slot_scene.instantiate()
		grid_container.add_child(slot)
		slot.display(item)
		# Connect Slot
		slot.on_item_button_pressed.connect(_on_item_button_pressed)
		# Fill Data
		slot.item_description = item.description
		slot.item_name = item.name



# ALERT ALERT ALERT ALERT ALERT ALERT ALERT ALERT ALERT

func _on_item_button_pressed(item_name,item_description,animated_sprite_2d):
		print_debug("Received " + item_name )
		# Center
		var centered_name = "[center]%s[/center]" % item_name
		item_desc_label.text = centered_name
		
		# Stop Other Slot Animations
		var slot_array = grid_container.get_children()
		for slot in slot_array:
			slot.animated_sprite_2d.animation = "Default"
		
		
		# Set Animation
		animated_sprite_2d.animation = "Selected"
		pass
