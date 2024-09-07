class_name SceneTrigger extends Area2D

@export var connected_scene: PackedScene





func _on_body_entered(body: Node2D) -> void:
	print("Entered")
	
	if body is Player:
		scene_manager.change_scene(get_owner(), connected_scene)
	pass # Replace with function body.
