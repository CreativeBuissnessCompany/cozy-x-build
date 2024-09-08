class_name SceneTrigger extends Area2D

@export var connected_scene: String





func _on_body_entered(body: Node2D) -> void:
	print("Entered")
	
	if body is Player:
		var loaded_scene = load(connected_scene)
		scene_manager.change_scene(get_owner(), loaded_scene)
	pass # Replace with function body.
