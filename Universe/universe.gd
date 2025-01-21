@icon("res://themes/editor_icons/universe_icon.png")
class_name Universe               # Universe.gd
extends Node2D

#                                           Variables... 

@onready var player: Player = %Player

# Careful with type ...
var current_location: BaseScene
 # Places To Place Player
var entrance_markers
# Entrance marker
var entrance_name: String = "any"
# Debug
@export var debug_component: DebugComponent





#                                               Script_Start
func _ready() -> void:
	# Sets itself in ... Utility Autoload ...
	Utility.universe = self
	
	# Give Player Node Referece to Scene_Manager
	SceneManager.player = player
	# Connect location_loaded signal
	Signalbus.location_loaded.connect(on_location_loaded)
	# Set current_location
	if get_tree().get_nodes_in_group("Locations").size() == 0 :
		print_debug("Cant Get node in group 'Locations'")
		
	else:
		current_location = get_tree().get_nodes_in_group("Locations")[0]

	# Grab Location/Scene's Markers
	entrance_markers = current_location.entrance_markers
	Utility.entrance_name_check(entrance_markers, player, entrance_name)
	debug_component.check_for_developer_mode()
	



# Position player again when new scene is loaded
# Maybe add current location ....
func on_location_loaded(new_entrance_markers: Node2D):
	Utility.entrance_name_check(new_entrance_markers, player, entrance_name)
