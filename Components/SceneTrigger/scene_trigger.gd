class_name SceneTrigger extends Area2D


# Variables ...
@export var connected_scene: String

var current_scene



func _on_body_entered(body: Node2D) -> void:
	#print("Entered")
	
	if body is Player:
		# Load next Scene
		var loaded_scene = load(connected_scene)
		# Get Owner Node ( Location i.e. "Farm" )
		current_scene = get_owner()
		scene_manager.manual_scene_change(current_scene, loaded_scene)
	
