class_name SceneManager extends Node

var player: Player




func change_scene(from, to_scene_name: PackedScene) -> void:
	player = from.player
	player.get_parent().remove_child(player)
	
	from.get_tree().call_deferred("change_scene_to_packed", to_scene_name)
	
	pass
