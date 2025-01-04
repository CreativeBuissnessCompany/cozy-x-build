extends Node2D




func _ready() -> void:
	
	pass




# Signal to inventory_ui
func _on_drop_button_button_up() -> void:
	var drop:= "drop"
	Signalbus.use_or_drop.emit(drop)
	pass # Replace with function body.

# Signal to inventory_ui
func _on_use_button_button_up() -> void:
	var inventory_ui: InventoryUI = get_parent()
	var last_clicked_item: Item = inventory_ui.last_clicked_item
	Signalbus.use_item.emit(last_clicked_item)
	pass # Replace with function body.
