# Utility.gd
extends Node

var entrance_marker: String = "any"
var database: Database = load("res://my_databases/seeds.gddb")
@onready var universe: Node = get_node("../Universe") 

var magic_number_for_dropping_pos: int = 10



# Unused ???	

func fetch_pickup_scene(item_name: StringName):
	var pickup_text: String = "_pickup"
	var lowercase_item_name: StringName
#	var spaceless_item_name: StringName
	var formatted_item_name: StringName
	var name_of_collection: StringName = "All_Pickups"
	
	# String Formatting ...
	lowercase_item_name = item_name.to_lower() # From uppercase to Lowercase ...
	formatted_item_name = lowercase_item_name+pickup_text
	
	
	# Find Resource using Collection & Resource Name ...
	var resource_int_id: int = database.get_int_id(name_of_collection, formatted_item_name)
	var scene: PackedScene = database.fetch_data(name_of_collection, resource_int_id)
	
	if scene != null:
		var instanced_scene: Node2D = scene.instantiate()
		var pickups_node: Node      = universe.find_child("PickUps") # WARNING NOTE CHANGE UPPERCASE U ...
		pickups_node.add_child(instanced_scene) # Add Child ...
		# Move
#		var pickup_comp: PickupComp = instanced_scene.get_child(0)
#		pickup_comp.set_process(false)                                        # Magic Numbers ....
		instanced_scene.global_position = SceneManager.player.global_position + Vector2(magic_number_for_dropping_pos*8,magic_number_for_dropping_pos*9)
		# Turn off process for a sec 
		print("yayyyy scene not null")
	
	
#	var resource_int_id: int = database.get_int_id(name_of_collection, formatted_item_name)
	
	
	pass
	


func move_thing(thing_to_move, where_to_move: Vector2, how_long: float):
	

	var tween: Tween = get_tree().create_tween()   # Tween ...
	tween.tween_property(thing_to_move,"position",where_to_move,how_long)



# Positions Player on current Map ...
func position_player(entrance_markers: Node2D, player: Player) -> void:
	
	
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
#			print(entrance.name)
	


# Convert mouse for local TileMap
func convert_mos_local(tml_layer,mos_pos):
	var result = tml_layer.local_to_map(mos_pos)
	return result
