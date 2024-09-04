# farm.gd
extends Node2D



# Variables ....

@onready var tilemap: TileMapLayer = $"01Ground_TileMapLayer"

# Farming States
enum FARMING_MODES {SEEDS, DIRT}
# Current State of Farming mode ENUM
var farming_mode_state = FARMING_MODES.DIRT


var source_id: int = 0
# Where is the tile located in PNG? 
var atlas_coord = Vector2i(6,13)
# Layers ...
var ground_layer = 1
var crop_layer = 2
# Holds the string name for the custom data we want...
var can_till_custom_data: String = "can_till"




func _ready() -> void:
	pass # Replace with function body.



func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	
	
	# E key
	if Input.is_action_just_pressed("toggle_dirt"):
		farming_mode_state = FARMING_MODES.DIRT
		print("dirt")
	
	
	# R key
	if Input.is_action_just_pressed("toggle_seeds"):
		farming_mode_state = FARMING_MODES.SEEDS
		print("seeds")
	
	
	# Is the mouse clicked?
	if Input.is_action_just_pressed("click"):
		#print("click")
		
		# Whats the pos of Mouse? Vector 2
		var mouse_pos: Vector2 = get_global_mouse_position()
		# Convert that from Float to Int ...
		var tml_mouse_pos: Vector2i = tilemap.local_to_map(mouse_pos)
		# Get Tile Data
		var tile_data: TileData = tilemap.get_cell_tile_data(tml_mouse_pos)
		# Check if Tile Data exists before moving on....
		if tile_data:
			# It Exists, Now get the Custom Data via its name as a "String"...
			var can_till = tile_data.get_custom_data(can_till_custom_data)
			# Check can_till Exists ...
			if can_till:
				tilemap.set_cell(tml_mouse_pos, source_id, atlas_coord)
			else:
				print("Can't Till Here")
		else:
			print("No TileData even exists...")
		
	


func retrieving_custom_data(tml_mouse_pos, custom_tilemap_data_name):
	
	# ALERT may cause problems due to tile_data naming ...
	# Get tile map data at the converted mouse position...
	var tile_data: TileData = tilemap.get_cell_tile_data(tml_mouse_pos)
	# Check if exists...
	if tile_data:
		return tile_data.get_custom_data(custom_tilemap_data_name)
	else:
		return false
	
