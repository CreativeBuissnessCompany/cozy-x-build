class_name VendorInventoryUI
extends Control  # Sept 15, Used to be panel container


# Variables
# Setting the item slot scene to use ....
@export var item_slot_scene:PackedScene
@export var inventory_for_objects: Inventory
@onready var grid_container: GridContainer = %GridContainer
@onready var item_desc_label: RichTextLabel = %ItemDescRichTextLabel
@onready var qty: RichTextLabel = %Qty
# Use_or_drop stuff
@export var buy_scene: PackedScene
var buy_instance: Node2D
var buy_displayed: bool = false
# Last picked ItemResource
var last_clicked_item: Item
# Player Var
@export var player: Player



# For Signals, And Stopping user Input
var ui_open: bool = false:
	set(value):
		ui_open = value
		Signalbus.ui_open.emit()
		#print(" Emitting From Inventory ")









# Script_Start
func _ready() -> void:
	#print(" Ready in inventory_ui")
	#print(inventory_for_objects)
	pass


func _unhandled_key_input(event: InputEvent) -> void:
	
	if Input.is_action_just_released("escape"):
		if buy_displayed:
			buy_instance.queue_free()
			buy_displayed = false
		else:
			_on_close_button_pressed()
		
	







func display_buy(pos) -> void:
	buy_instance = buy_scene.instantiate()
	buy_instance.global_position = pos
	add_child(buy_instance)
	buy_instance.find_child("Button").connect("pressed", on_buy)
	#buy_instance.connect( "pressed", on_buy )
	buy_displayed = true
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
		#print(" Found Inventory")
		#printt(inventory, inventory_for_objects)
	
	reset_inventory(inventory)
	
	
	
	
	# Delete under me, Replaced by func reset_inventory
	
	#for child in grid_container.get_children():
		#child.queue_free()
	#
	#for item in inventory.get_items():
		#var slot: ItemSlot = item_slot_scene.instantiate()
		#grid_container.add_child(slot)
		#slot.set_item(item)
		## Connect Slot
		#slot.on_item_button_pressed.connect(_on_item_button_pressed)



func _on_item_button_pressed(animated_sprite_2d, item_resource: Item, slot_position):
	print_debug( "Received " + item_resource.description )
	item_desc_label.text = item_resource.description
	qty.text = "Qty: " + str(item_resource.qty)
	# Stop Other Slot Animations
	var slot_array = grid_container.get_children()
	for slot in slot_array:
		slot.animated_sprite_2d.animation = "Default"
	
	# Set Animation
	animated_sprite_2d.animation = "Selected"
	
	# Use or Drop Dialog Displayed 
	if not buy_displayed:
		display_buy(slot_position)
	elif buy_displayed:
		buy_instance.global_position = slot_position
	
	# Set last_clicked_item for buy
	last_clicked_item = item_resource


func _on_close_button_pressed() -> void:
	
	self.ui_open = false
	hide()


func on_buy() -> void:
	print(" Clicked Buy Button ")
	player.inventory.add_item(last_clicked_item)
	# NOTE This line is the one causing me trouble ...
	inventory_for_objects.remove_item(last_clicked_item)
	#var new_inventory = inventory_for_objects.duplicate()
	#reset_inventory(new_inventory)
	_on_close_button_pressed()
	open(inventory_for_objects)
	# Close buy box 
	buy_instance.queue_free()
	buy_displayed = false


func reset_inventory(inventory: Inventory) -> void:
	
	for child in grid_container.get_children():
		grid_container.remove_child(child)
		child.queue_free()
	
	for item in inventory.get_items():
		var slot: ItemSlot = item_slot_scene.instantiate()
		grid_container.add_child(slot)
		slot.set_item(item)
		# Connect Slot
		slot.on_item_button_pressed.connect(_on_item_button_pressed)
	
