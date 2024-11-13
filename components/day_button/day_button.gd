extends Button

@export_node_path("Node") var farm_path 
@export_node_path("Node") var universe_path 




func _on_pressed() -> void:
	
	var farm: Node2D = get_node(farm_path)
	var universe = get_node(universe_path)
	
	#print(" Day Button Has Been [ pressed ] .... Hated it ")
	#var copy: Node2D = farm
	farm.get_parent().remove_child(farm)
	time_tracker.day += 1
	await Engine.get_main_loop().process_frame
	universe.call_deferred("add_child", farm)
	pass # Replace with function body.
