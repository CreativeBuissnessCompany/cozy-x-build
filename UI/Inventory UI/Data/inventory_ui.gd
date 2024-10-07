class_name InventoryUI
extends Control  # Sept 15, Used to be panel container


# Variables
@export var item_slot_scene:PackedScene

@onready var grid_container: GridContainer = %GridContainer
@onready var item_desc_label: RichTextLabel = %ItemDescRichTextLabel

# For Signals, And Stopping user Input
var ui_open: bool = false:
	set(value):
		ui_open = value
		Signalbus.ui_open.emit()
		#print(" Emitting From Inventory ")





# Script_Start
func _ready() -> void:
	pass




# What node is using this? Player.gd ... 
func open(inventory:Inventory):
	# Emit Signal to Stop Input in Farm.gd
	self.ui_open = true
	# Show/Hide UI
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
		# Test
		# New ....
		slot.item_resource = item


func _on_item_button_pressed(item_description,animated_sprite_2d):
	#print_debug("Received " + item_description )
	item_desc_label.text = item_description
	
	# Stop Other Slot Animations
	var slot_array = grid_container.get_children()
	for slot in slot_array:
		slot.animated_sprite_2d.animation = "Default"
	
	# Set Animation
	animated_sprite_2d.animation = "Selected"
	pass


func _on_close_button_pressed() -> void:
	# Let everyone know ui is Closed.....
	self.ui_open = false
	hide()
