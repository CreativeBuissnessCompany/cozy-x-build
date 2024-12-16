extends Button


# Code Smell
@export_node_path("Node") var farm_path   
@export_node_path("Node") var universe_path   
@onready var universe: Node = get_node(universe_path)  




# How is this bad? This script NEEDS universe node to have developer_mode ...... NOTE
# Should universe hold info instead ? No, Because easy to forget this relationship....
# What about a debug component ? I think thats the perfect solution ....
func _ready() -> void:
#	if universe.developer_mode == false:
#		hide()
	pass




func _on_pressed() -> void:
	
	
	
	# Should this be set in universe? No, It's only used on debug... Placed in upcoming debug component ... NOTE
	var current_location: Node2D = universe.current_location
	print(current_location)

	current_location.get_parent().remove_child(current_location) # Maybe move to SceneManager ....
	time_tracker.day += 1                    # Maybe move to TimeTracker ....
	await Engine.get_main_loop().process_frame # Maybe move to SceneManager ....
	universe.call_deferred("add_child", current_location)# Maybe move to SceneManager ....
