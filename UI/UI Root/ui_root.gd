# UIRoot.gd
extends CanvasLayer


# Variables
@onready var player: Player = $"../Player"
# Different UI Screens
@onready var inventory_ui: InventoryUI = $InventoryUI
@onready var inventory_ui_vending_machine: InventoryUIVendingMachine = $InventoryUIVendingMachine
# A Node2D Containing all objects with UI ...
@onready var objects_with_ui: Node2D = %ObjectsWithUI




# Store Inventory of Opened Object
var object_inventory: Array[Item]


func _ready() -> void:
	
	if objects_with_ui:
		
		var children = objects_with_ui.get_children()
		for child in children:
			child.connect("vending_machine_ui", _on_vending_machine_ui)
		
	
	


func _on_vending_machine_ui(inventory_vending: Inventory):
	inventory_ui_vending_machine.open(inventory_vending)
	print("UIRoot, Signal Received")
	
	pass






func _unhandled_input(event: InputEvent) -> void:
	
	
	if event.is_action_released("ui_inventory"):
		inventory_ui.open(player.inventory)
	
