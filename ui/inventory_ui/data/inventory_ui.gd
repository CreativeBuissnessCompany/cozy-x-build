class_name InventoryUI
extends Control  # Sept 15, Used to be panel container


# Variables
# Setting the item slot scene to use ....
@export var item_slot_scene:PackedScene
@export var inventory_for_objects: Inventory
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
	print(" Ready in inventory_ui")
	print(inventory_for_objects)
	pass



# What node is using this? Player.gd ... 
func open(inventory:Inventory):
	# Emit Signal to Stop Input in Farm.gd
	self.ui_open = true
	# Show/Hide UI
	self.visible = !self.visible
	
	# Used for things that already have inventory like...
	#Vending Machine, Chest, Etc ...
	if inventory_for_objects:
		inventory = inventory_for_objects
		print(" Found Inventory")
		printt(inventory, inventory_for_objects)
	
	
	for child in grid_container.get_children():
		child.queue_free()
	
	for item in inventory.get_items():
		var slot: ItemSlot = item_slot_scene.instantiate()
		grid_container.add_child(slot)
		slot.set_item(item)
		# Connect Slot
		slot.on_item_button_pressed.connect(_on_item_button_pressed)



func _on_item_button_pressed(animated_sprite_2d, item_resource: Item):
	print_debug( "Received " + item_resource.description )
	item_desc_label.text = item_resource.description
	
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
