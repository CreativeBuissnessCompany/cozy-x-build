extends Node



func position_player(entrance_markers: Node2D, player: Player) -> void:
	
	# Make sure player is the last node in the scene tree....
	player.get_parent().move_child(player, -1)
	
	
	for entrance in entrance_markers.get_children():
		if entrance is Marker2D and entrance.name == "any":
			player.global_position = entrance.global_position
			print("Utility:func position_player")


func convert_mos_local(tml_layer,mos_pos):
	var result = tml_layer.local_to_map(mos_pos)
	return result
