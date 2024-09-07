# farm.gd
extends Node2D


# @onready.. 

# Layers
@onready var tml_1:= $"01FarmGrass_TileMapLayer"
@onready var tml_2:= $"02GrassOnDirt_TileMapLayer"
@onready var tml_3:= $"03TilledAndWateredTileMapLayer2"

# Player....
@onready var player: Player = %Player




#  Variables ....   NOTE 


# 1st Terrain Set
var terrain_set:int = 0
# Terrains within 1st Set
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






func _input(_event: InputEvent) -> void:
	
	
	# E key
	if Input.is_action_just_pressed("toggle_dirt"):
		farming_mode_state = FARMING_MODES.TILL
		print("till")
	
	# R key
	if Input.is_action_just_pressed("toggle_water"):
		farming_mode_state = FARMING_MODES.WATERING
		print("water")
	
	
	
	# Is the mouse clicked?
	if Input.is_action_just_pressed("click"):
		# Whats the pos of Mouse? Vector 2
		var mouse_pos: Vector2 = get_global_mouse_position()
		# Convert that from Float to Int ...
		
		
		
		
		# NOTE FARMING STATES //////
		# Check state of farming ... If WATERING...
		if farming_mode_state == FARMING_MODES.WATERING:
			# Custom func , Requires converted mouse location and custom data layer name ...
			#  Retrievies SPECIFIC data from the tile ...
			var mouse_pos_for_watering = Utility.convert_mos_local(tml_3,mouse_pos)
			
			# How's this working ? ...
			# Layer , Mos , CustomData Name
			if retrieving_custom_data(tml_3, mouse_pos_for_watering,can_water_custom_data):
				wet_tiles.append(mouse_pos_for_watering)
				# Set the tilemap at mouse position using source id and atlas coords 
				tml_3.set_cells_terrain_connect(wet_tiles,terrain_set, watered_terrain)
		
		
		
		# Otherwise it's just TILL.... 
		elif farming_mode_state == FARMING_MODES.TILL:
			
			var mouse_pos_for_tilling = Utility.convert_mos_local(tml_2,mouse_pos)
			
			# Check that you can even get custom data called can_water
			if retrieving_custom_data(tml_2, mouse_pos_for_tilling, can_till_custom_data):
				dirt_tiles.append(mouse_pos_for_tilling)
				tml_3.set_cells_terrain_connect(dirt_tiles,terrain_set, tilled_terrain)
				
		
		# Trying to fix tiles, tiling weird
		if wet_tiles.size() or dirt_tiles.size() >= 3:
			print("3 tiles stored, Now removing...")
			wet_tiles.pop_back()
			dirt_tiles.pop_back()
			
			pass
		
		#print(wet_tiles)
		return





# Custom function ....
func retrieving_custom_data(tml_layer,tml_mouse_pos, custom_tilemap_data_name):
	
	# Get tile map data at the converted mouse position...
	var tile_data: TileData = tml_layer.get_cell_tile_data(tml_mouse_pos)
	# Check if exists...
	if tile_data:
		print("Got Data")
		
		return tile_data.get_custom_data(custom_tilemap_data_name)
	else:
		print("NO Data here")
		
		return false
	
