class_name VendorInventoryUI
extends Control  # Sept 15, Used to be panel container


#                                                         Variables...
# Setting the item slot scene to use ....
@export var item_slot_scene:PackedScene
@export var inventory_for_objects: InventoryResource    # Heads-Up... Change to inventory_for_sellers ...
@onready var grid_container: GridContainer = %GridContainer
@onready var item_desc_label: RichTextLabel = %ItemDescRichTextLabel
@onready var price_label: RichTextLabel = %Price
@onready var item_name_label: RichTextLabel = %ItemNameLabel

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
#
var vendor_ui_displayed: bool = false








#                                         Script Start...
#                                                        Esc. Key ...
func _unhandled_key_input(event: InputEvent) -> void:
	# Close inventoryUI ....
	if ui_open == true:
		if Input.is_action_just_released("escape"):
			if buy_displayed:
				buy_instance.queue_free()
				buy_displayed = false
			else:
				_on_close_button_pressed()
			# Close vendingInventory if you open inventory 
		if event.is_action_released("ui_inventory"):
			_on_close_button_pressed()
		

func display_buy(pos) -> void:
	if buy_instance != null:
		print( "Deleting buy instance in display buy")
		buy_instance.queue_free()
	buy_instance = buy_scene.instantiate()
	buy_instance.global_position = pos
	add_child(buy_instance)
	buy_instance.find_child("Button").connect("pressed", on_buy)
	#buy_instance.connect( "pressed", on_buy )
	buy_displayed = true
	pass


# What node is using this? Player.gd ... 
func open(inventory: InventoryResource):
	if vendor_ui_displayed == true:
		_on_close_button_pressed()
		
		return
	else:
		print(" Opening inventory for vendor")
		self.ui_open = true # Emit Signal to Stop Input in Farm.gd
		self.visible = !self.visible # Show/Hide UI
		# Used for things that already have inventory like...
		#Vending Machine, Chest, Etc ...
		if inventory_for_objects:
			inventory = inventory_for_objects
		reset_inventory(inventory)
		print("vendor_ui_displayed set to false")
		vendor_ui_displayed = true


func _on_item_button_pressed(animated_sprite_2d, item_resource: Item, slot_position, slot_scene: ItemSlot):
	#print_debug( "Received " + item_resource.description )
	item_name_label.text = str("[center]" + item_resource.name + "[/center]") # TESTING 12/04 , Add name 
	item_desc_label.text = item_resource.description
	price_label.text = "$: " + str(item_resource.price)
	# Stop Other Slot Animations
	var slot_array: Array[Node] = grid_container.get_children()
	for slot in slot_array:
		slot.animated_sprite_2d.animation = "Default"
	
	# Set Animation
	animated_sprite_2d.animation = "Selected"
	
	# Use or Drop Dialog Displayed 
	if not buy_displayed:
		display_buy(slot_position)
		slot_scene.buy_displayed = true
	elif buy_displayed:
		for i in slot_array:
			i.buy_displayed = false
		buy_instance.global_position = slot_position
		slot_scene.buy_displayed = true
		
	
	# Set last_clicked_item for buy
	last_clicked_item = item_resource

# Heads-Up...  Close buy box added New ... 12/03
func _on_close_button_pressed() -> void:
	print(" Closed button pressed")
	# Close buy box  Heads-Up... New ... 12/03
	if buy_instance != null:
		print("Delete buy_instance")
		buy_instance.queue_free()
		buy_displayed = false
	#
	self.ui_open = false
	vendor_ui_displayed = false
	hide()


func on_buy() -> void:
#	print(" Clicked Buy Button ")
	var price: int = last_clicked_item.price
	var held: int = player.currency_node.currency_held
	

	if check_if_player_can_afford(price, held):
		player.currency_node.lose_currency(price)

		player.inventory.add_item(last_clicked_item)
		# NOTE This line is the one causing me trouble ...
		inventory_for_objects.remove_item(last_clicked_item)
		buy_instance.queue_free()
		buy_displayed = false
		_on_close_button_pressed()
		open(inventory_for_objects)
	# Close buy box 
		
	else:
		print("Cant Afford This Shit Bud!! ....")
		return
	
func check_if_player_can_afford(cost: int, held: int) -> bool:
	# Make sure player has enough currency for transaction ...
	if held >= cost:
		return true
	else:
		return false


func reset_inventory(inventory: InventoryResource) -> void:
	
	for child in grid_container.get_children():
		grid_container.remove_child(child)
		child.queue_free()
	
	for item in inventory.get_items():
		var slot: ItemSlot = item_slot_scene.instantiate()
		grid_container.add_child(slot)
		slot.set_item(item)
		# Connect Slot
		slot.on_item_button_pressed.connect(_on_item_button_pressed)
	
