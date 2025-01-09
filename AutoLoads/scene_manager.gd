# SceneManager
extends Node

var player: Player
var previous_scene: Node2D = null
var next_scene: Node2D = null


func _ready() -> void:
	#print("Scenemanager: Ready")
	pass



func manual_scene_change(from: Node2D, loaded_scene_name: PackedScene):
	# Pause Game 
	get_tree().paused = true
	Utility.transition_spawner()
	await get_tree().create_timer(0.8).timeout
	
	
	# If no previous_scene/Location is stored....
	if !previous_scene:
		# Store Previous and Next Scenes ...
		previous_scene = from
		# Instantiate Next Scene
		next_scene = loaded_scene_name.instantiate()
		
	else:
		# Otherwise, Load the previous instance
		# instead of creating a brand new one ...
		next_scene = previous_scene
	
	# Add Child next_scene ...
	from.get_parent().call_deferred("add_child", next_scene)
	# Store previous_scene
	previous_scene = from
	# Remove Previous ( Copy in "previous_scene" )
	from.get_parent().call_deferred("remove_child", from)
	
	# Unpause Game ....
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = false
	
	
