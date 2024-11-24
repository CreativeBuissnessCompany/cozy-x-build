# Utility.gd
extends Node

var entrance_marker: String = "any"





#func check_for_dev_mode():



# Positions Player on current Map ...
func position_player(entrance_markers: Node2D, player: Player) -> void:
	
	# TESTING Insert keyword from whoever emits
	
	
	
	# Make sure player is the last node in the scene tree....
	player.get_parent().move_child(player, -1)
	
	# Look through entrance_marker Node...
	for entrance in entrance_markers.get_children():
		if entrance is Marker2D and entrance.name == "any":
			player.global_position = entrance.global_position

			
# TESTING , Check for "any" , Who sets? Universe Sets ....
func entrance_name_check(entrance_markers: Node2D, player: Player, _name: String):

	player.get_parent().move_child(player, -1)

	for entrance in entrance_markers.get_children():
		if entrance is Marker2D and entrance.name == _name:
			player.global_position = entrance.global_position
			print(entrance.name)
	


# Convert mouse for local TileMap
func convert_mos_local(tml_layer,mos_pos):
	var result = tml_layer.local_to_map(mos_pos)
	return result

