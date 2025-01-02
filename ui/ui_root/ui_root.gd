# UIRoot.gd
@icon("res://themes/editor_icons/ui_icon.png")
extends CanvasLayer


# Variables
@onready var player: Player = %Player

# Different UI Screens
@onready var inventory_ui: InventoryUI = $InventoryUI
@onready var inventory_ui_vending_machine: VendorInventoryUI = $InventoryUIVendingMachine

# Store Inventory of Opened Object
var object_inventory: Array[Item]





func _ready() -> void:
	
	# Setup signal to objects with inventory
	Signalbus.open_object_with_inventory.connect(on_open_object_with_inventory)
	



func on_open_object_with_inventory(vending_inventory: InventoryResource):
	inventory_ui_vending_machine.open(vending_inventory)
	


func _on_vending_machine_ui(inventory_vending: InventoryResource):
	inventory_ui_vending_machine.open(inventory_vending)
	#print("UIRoot, Signal Received")



func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_released("ui_inventory"):
		inventory_ui.open(player.inventory)
		#print("Released")
