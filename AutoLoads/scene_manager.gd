class_name SceneManager extends Node

var player: Player
var previous_scene
var next_scene


func _ready() -> void:
	print("Scenemanager: Ready")



func manual_scene_change(from, loaded_scene_name: PackedScene):
	
	# Store Previous and Next Scenes ...
	previous_scene = from
	# Instantiate Next Scene
	next_scene = loaded_scene_name.instantiate()
	# Set next scene ...
	from.get_parent().call_deferred("add_child", next_scene)
	
	# Remove Previous ( Copy in "previous_scene" )
	from.get_parent().call_deferred("remove_child", from)
	
