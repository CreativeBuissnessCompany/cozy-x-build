# Universe.gd
@icon("res://themes/editor_icons/universe_icon.png") 
extends Node2D


# Variables & @onready ...

@export var developer_mode: bool = false:
	set(value):
		developer_mode = value
		
		print("Developer Mode Set")

@onready var debug_indicator = %Debug

@onready var player: Player = %Player

# Locations/Scene
# Careful with type ...
var current_location: BaseScene

 # Places To Place Player
var entrance_markers
# Entrance marker
var entrance_name: String = "any"




# Script_Start
func _ready() -> void:
	check_if_developer_mode()
#	print("Universe is ready ....")
	
	# Give Player Node Referece to Scene_Manager
	SceneManager.player = player
	
	# Connect location_loaded signal
	Signalbus.location_loaded.connect(on_location_loaded)
	
	# Set current_location
	if get_tree().get_nodes_in_group("Locations").size() == 0 :
		print_debug("Cant Get node in group 'Locations'")
		return
	else:
#		print_debug("'Locations' group not empty, Setting current Location for \func position_player? Found in Universe.gd? ...")
		current_location = get_tree().get_nodes_in_group("Locations")[0]

	
	# Grab Location/Scene's Markers
	entrance_markers = current_location.entrance_markers
	# PositionPlayer with Grabbed Markers... TESTING Need keyword like "any"
#	Utility.position_player(entrance_markers, player)
	Utility.entrance_name_check(entrance_markers, player, entrance_name)

	

func check_if_developer_mode():
	if developer_mode == true:
		# Debug Indicator
		debug_indicator.visible = true
		# Entrance Markers
		entrance_name = "debug"



# Position player again when new scene is loaded
# Maybe add current location ....
func on_location_loaded(new_entrance_markers: Node2D):
#	print(" on_location_loaded in Universe is goin ...")
#	Utility.position_player(new_entrance_markers, player)
	Utility.entrance_name_check(new_entrance_markers, player, entrance_name)
