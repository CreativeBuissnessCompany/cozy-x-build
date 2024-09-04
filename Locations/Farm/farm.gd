# farm.gd
extends Node2D

# @onready.. 
@onready var tilemap: TileMapLayer = $"01Ground_TileMapLayer"



#  Variables ....   NOTE 




# 1st Terrain Set
var terrain_set:int = 0
# Tilled ...
var tilled_terrain:int = 2
# Wet ...
var watered_terrain:int = 3

# Tile Arrays ...
var dirt_tiles: Array = []
var wet_tiles: Array = []

# Farming States ...
enum FARMING_MODES {WATERING, TILL}
# Current State of Farming mode ENUM
var farming_mode_state = FARMING_MODES.TILL


# Tile Data/Info
var source_id: int = 0
# Holds the string name for the custom data we want...
var can_till_custom_data: String = "can_till"
var can_water_custom_data: String = "can_water"





func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	
	
	# E key
	if Input.is_action_just_pressed("toggle_dirt"):
		farming_mode_state = FARMING_MODES.TILL
		print("till")
	
	
	# R key
	if Input.is_action_just_pressed("toggle_seeds"):
		farming_mode_state = FARMING_MODES.WATERING
		print("water")
	
	
	# Is the mouse clicked?
	if Input.is_action_just_pressed("click"):
		# Whats the pos of Mouse? Vector 2
		var mouse_pos: Vector2 = get_global_mouse_position()
		# Convert that from Float to Int ...
		var tml_mouse_pos: Vector2i = tilemap.local_to_map(mouse_pos)
		
		# Check state of farming ... If WATERING...
		if farming_mode_state == FARMING_MODES.WATERING:
			# Custom func , Requires converted mouse location and custom data layer name ...
			#  Retrievies SPECIFIC data from the tile ...
			if retrieving_custom_data(tml_mouse_pos, can_water_custom_data):
				wet_tiles.append(tml_mouse_pos)
				# Set the tilemap at mouse position using source id and atlas coords 
				tilemap.set_cells_terrain_connect(wet_tiles,terrain_set, watered_terrain)
		
		# Otherwise it's just TILL.... 
		elif farming_mode_state == FARMING_MODES.TILL:
			# Check that you can even get custom data called can_water
			if retrieving_custom_data(tml_mouse_pos, can_till_custom_data):
				dirt_tiles.append(tml_mouse_pos)
				tilemap.set_cells_terrain_connect(dirt_tiles,terrain_set, tilled_terrain)
				pass



# Custom function ....
func retrieving_custom_data(tml_mouse_pos, custom_tilemap_data_name):
	
	# ALERT may cause problems due to tile_data naming ...
	# Get tile map data at the converted mouse position...
	var tile_data: TileData = tilemap.get_cell_tile_data(tml_mouse_pos)
	# Check if exists...
	if tile_data:
		return tile_data.get_custom_data(custom_tilemap_data_name)
	else:
		return false
	
