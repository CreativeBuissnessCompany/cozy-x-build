extends Node2D




func _ready() -> void:
	
	pass
# Signal to inventory_ui
func _on_drop_button_button_up() -> void:
	var drop:= "drop"
	Signalbus.use_or_drop.emit(drop)
	pass # Replace with function body.
