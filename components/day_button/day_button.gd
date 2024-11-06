extends Button




func _on_pressed() -> void:
	
	time_tracker.day += 1
	var universe = $"../../.."
	var farm = $"../../../Farm"
	farm.get_parent().remove_child(farm)
	universe.add_child(farm)
	pass # Replace with function body.
