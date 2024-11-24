extends Button

@export_node_path("Node") var farm_path 
@export_node_path("Node") var universe_path 




func _on_pressed() -> void:
	
	
	# TESTING
	
	
	var universe = get_node(universe_path)
	var current_location: Node2D = universe.current_location
	print(current_location)

	#print(" Day Button Has Been [ pressed ] .... Hated it ")
	#var copy: Node2D = farm
	current_location.get_parent().remove_child(current_location)
	time_tracker.day += 1
	await Engine.get_main_loop().process_frame
	universe.call_deferred("add_child", current_location)
	pass # Replace with function body.
