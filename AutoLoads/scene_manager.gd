class_name SceneManager extends Node

var player: Player
var previous_scene
var next_scene


func _ready() -> void:
	print("Scenemanager: Ready")


# Not in use, Comment out ! !! ! 
#func change_scene(from, to_scene_name: PackedScene) -> void:
	#player = from.player
	#player.get_parent().remove_child(player)
	## from.get_tree().call_defferred
	#print(from.name)
	#from.get_tree().call_deferred("change_scene_to_packed", to_scene_name)
	#pass


# New Manual change, Custom
func manual_scene_change(from, loaded_scene_name: PackedScene):
	# Store Player from scenes
	#player = from.player
	
	#player.get_parent().remove_child(player)
	# Store Previous and Next Scenes ...
	previous_scene = from
	# Instantiate Next Scene
	next_scene = loaded_scene_name.instantiate()
	# Set next scene ...
	from.get_parent().call_deferred("add_child", next_scene)
	
	# Remove Previous ( Copy in "previous_scene" )
	from.get_parent().call_deferred("remove_child", from)
	
