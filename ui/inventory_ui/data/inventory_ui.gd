class_name InventoryUI
extends Control  

#                                                  Variables
# Setting the item slot scene to use ....
@export var item_slot_scene:PackedScene
@export var inventory_for_objects: InventoryResource
@onready var grid_container: GridContainer = %GridContainer
@onready var item_desc_label: RichTextLabel = %ItemDescRichTextLabel
@onready var qty: RichTextLabel = %Qty

# Use_or_drop stuff
@export var use_drop_scene: PackedScene
var use_drop_instance: Node2D
var use_drop_displayed: bool = false

# For Signals, And Stopping user Input
var ui_open: bool = false:
	set(value):
		ui_open = value
		Signalbus.ui_open.emit() # Connected to Farm for input ////
		
@export var  player: Player 

var last_clicked_item: Item




func _ready() -> void:
	Signalbus.use_or_drop.connect(_use_or_drop)




#                                           Script Start... 


func _unhandled_key_input(_event: InputEvent) -> void:
	
	if Input.is_action_just_released("escape"):
		if use_drop_displayed:
			use_drop_instance.queue_free()
			use_drop_displayed = false
		else:
			_on_close_button_pressed()
		

func display_use_drop(pos) -> void:
	use_drop_instance = use_drop_scene.instantiate()
	use_drop_instance.global_position = pos
	add_child(use_drop_instance)
	use_drop_displayed = true
	pass


# What node is using this? Player.gd ... 
func open(inventory: InventoryResource):
	if use_drop_displayed == true:
		close_use_drop()
		use_drop_displayed = false
	self.ui_open = true # Emitting in setget, Signal to Stop Input in Farm.gd
	self.visible = !self.visible # Show/Hide UI # NOTE CHANGED TO SHOW from !self.visible
	
	# Used for things that already have inventory like...
	# Vending Machine, Chest, Etc ...
	if inventory_for_objects:
		inventory = inventory_for_objects
	
	for child in grid_container.get_children():
		child.queue_free()
	
	for item in inventory.get_items():
		var slot: ItemSlot = item_slot_scene.instantiate()
		grid_container.add_child(slot)
		slot.set_item(item)
		# Connect Slot
		slot.on_item_button_pressed.connect(_on_item_button_pressed)
		
		# Pause Game
	get_tree().paused = !get_tree().paused


func _on_item_button_pressed(animated_sprite_2d, item_resource: Item, slot_position, _slot):
	#print_debug( "Received " + item_resource.description )
	last_clicked_item = item_resource
	item_desc_label.text = item_resource.description
	qty.text = "Qty: " + str(item_resource.qty)
	# Stop Other Slot Animations
	var slot_array: Array[Node] = grid_container.get_children()
	for slot in slot_array:
		slot.animated_sprite_2d.animation = "Default"
	
	# Set Animation
	animated_sprite_2d.animation = "Selected"
	
	# Use or Drop Dialog Displayed 
	if not use_drop_displayed:
		display_use_drop(slot_position)
	elif use_drop_displayed:
		use_drop_instance.global_position = slot_position
	

func _on_close_button_pressed() -> void:
	print("Closing Inventory")
	# Let everyone know ui is Closed.....
	self.ui_open = false
	self.visible = !self.visible
	close_use_drop()
	# Unpause Game
	get_tree().paused = false

func close_use_drop():
	use_drop_displayed = false
	use_drop_instance.get_parent().remove_child(use_drop_instance)
	use_drop_instance.queue_free()
	pass	
	
func on_use():
	pass


func on_drop():
	# Remove Qty no matter what
	
	
	
	player.inventory.remove_item(last_clicked_item) # Do if Qty <= 0
	Utility.fetch_pickup_scene(last_clicked_item.name) 
	_on_close_button_pressed()
	
	open(player.inventory)
	pass
	
func _use_or_drop(action):
	if action == "drop":
		print("...Dropping...")
		on_drop()
		pass
	else:
		pass
	
	