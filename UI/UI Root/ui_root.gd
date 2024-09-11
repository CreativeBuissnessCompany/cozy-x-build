# UIRoot.gd
extends CanvasLayer


# Variables
@onready var player: Player = $"../Player"
@onready var inventory_dialog: InventoryDialog = %InventoryDialog
@onready var vending_machine_ui: Control = $VendingMachineUI



var objects_w_ui



func _ready() -> void:
	
	if %ObjectsWithUI:
		var objects_w_ui = %ObjectsWithUI
		var children = objects_w_ui.get_children()
		for child in children:
			child.connect("vending_machine_ui", _on_vending_machine_ui)
		pass
	
	pass


func _on_vending_machine_ui():
	vending_machine_ui.visible = !vending_machine_ui.visible
	print("VendUI Signal")
	pass






func _unhandled_input(event: InputEvent) -> void:
	
	
	if event.is_action_released("ui_inventory"):
		inventory_dialog.open(player.inventory)
	
