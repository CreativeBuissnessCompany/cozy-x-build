# Universe.gd
extends Node


# @onready & Variables ...
@onready var player: Player = %Player
# Locations/Scene
var current_location
 # Places To Place Player
var entrance_markers


func _ready() -> void:
	# Give Player Node Referece to Scene_Manager
	scene_manager.player = player
	
	# Connect location_loaded signal
	Signalbus.location_loaded.connect(on_location_loaded)
	
	# Set current_location
	current_location = get_tree().get_nodes_in_group("Locations")[0]
	# Grab Location/Scene's Markers
	entrance_markers = current_location.entrance_markers
	# PositionPlayer with Grabbed Markers...
	Utility.position_player(entrance_markers, player)
	
	print("Universe: Ready")


# Position player again when new scene is loaded
func on_location_loaded(new_entrance_markers):
	Utility.position_player(new_entrance_markers, player)
	print("Universe: Signal Received from BaseScene")
	pass
