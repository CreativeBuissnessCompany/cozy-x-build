# UIRoot.gd
extends CanvasLayer


# Variables
@onready var player: Player = $"../Player"
@onready var inventory_dialog: InventoryDialog = %InventoryDialog





func _unhandled_input(event: InputEvent) -> void:
	
	
	if event.is_action_released("ui_inventory"):
		inventory_dialog.open(player.inventory)
	
