# farm.gd
extends BaseScene


## NOTE : Tilling is happening on top of one tilemap layer, And watering ontop of Tilling. 


# @Onready.. 

# TileMapLayers
@onready var tml_1:= $"01FarmGrass_TileMapLayer"
@onready var tml_2:= $"02GrassOnDirt_TileMapLayer"
@onready var tml_3:= $"03TilledAndWateredTileMapLayer2"

#  Variables ....  

# 1st Terrain Set
var terrain_set:int = 0
# Terrains within 1st Set
var tilled_terrain:int = 2
var watered_terrain:int = 3
# Tile Arrays ...
var dirt_tiles: Array = []
var wet_tiles: Array = []

# Farming States ...
enum FARMING_MODES {WATERING, TILL}
# Current State of Farming mode 
var farming_mode_state := FARMING_MODES.TILL

# Tile Data/Info.... for custom data? Maybe Unused
var source_id: int = 0
# Holds the string name for the custom data we want...
var can_till_custom_data: String = "can_till"
var can_water_custom_data: String = "can_water"

# Empty vars until used by farming()
var layer_to_look: TileMapLayer
var layer_to_place: TileMapLayer
var tiles: Array
var terrain: int
var custom_data: String









func _ready() -> void:
	super()



# Player Inputs at Farm ...
func _input(_event: InputEvent) -> void:
	
	# E key
	if Input.is_action_just_pressed("toggle_dirt"):
		farming_mode_state = FARMING_MODES.TILL
		print("Till State")
	
	# R key
	if Input.is_action_just_pressed("toggle_water"):
		farming_mode_state = FARMING_MODES.WATERING
		print("Water State")
	
	
	# Mouse click, Farming Happening ..
	if Input.is_action_just_pressed("click"):
		# Whats the pos of Mouse? Vector 2
		var mouse_pos: Vector2 = get_global_mouse_position()
		var state = farming_mode_state
		# Farming Func ...
		farming(state, mouse_pos)
		

		#
		## NOTE Farming States ...
		## Check state of farming ... If WATERING...
		#if farming_mode_state == FARMING_MODES.WATERING:
			#var mouse_pos_for_watering = Utility.convert_mos_local(tml_3,mouse_pos)
			## How's this working ? ...
			## Layer , MousPos , CustomData Name  tml_3 to tml_3
			#if retrieving_custom_data(tml_3, mouse_pos_for_watering,can_water_custom_data):
				#wet_tiles.append(mouse_pos_for_watering)
				## Set the tilemap at mouse position using cells in Array, TerrainSet and  Terrain
				#tml_3.set_cells_terrain_connect(wet_tiles,terrain_set, watered_terrain)
		#
		## Otherwise it's just TILL.... 
		#elif farming_mode_state == FARMING_MODES.TILL:
			#var mouse_pos_for_tilling = Utility.convert_mos_local(tml_2,mouse_pos)
			## Check that you can even get custom data called can_till  tml_2 to tml_3
			#if retrieving_custom_data(tml_2, mouse_pos_for_tilling, can_till_custom_data):
				#dirt_tiles.append(mouse_pos_for_tilling) 
				#tml_3.set_cells_terrain_connect(dirt_tiles,terrain_set, tilled_terrain) 

		
		return


# Test Func .... FARMING FUNC
func farming(state,mouse_pos):
	
	match state:
		FARMING_MODES.TILL:
			layer_to_look = tml_2 
			layer_to_place = tml_3
			tiles = dirt_tiles
			terrain = tilled_terrain
			custom_data = can_till_custom_data
			print(" Farming Worked - Till ")
	
		FARMING_MODES.WATERING:
			layer_to_look = tml_3
			layer_to_place = tml_3
			tiles = wet_tiles
			terrain = watered_terrain
			custom_data = can_water_custom_data
			print(" Farming Worked - Water")
	
	# After STATE match, Do work ...
	var mouse_pos_for_farming = Utility.convert_mos_local(layer_to_look,mouse_pos)
	if retrieving_custom_data(layer_to_look, mouse_pos_for_farming, custom_data):
		tiles.append(mouse_pos_for_farming) 
		layer_to_place.set_cells_terrain_connect(tiles,terrain_set, terrain) 
		# If that worked, Pop Tile Array to try to fiz issues with placement 
		if wet_tiles.size() or dirt_tiles.size() >= 3:
			print("3 tiles stored, Now removing...")
			wet_tiles.pop_back()
			dirt_tiles.pop_back()




# Custom function ....
func retrieving_custom_data(tml_layer: TileMapLayer,tml_mouse_pos: Vector2, custom_tilemap_data_name: String):
	
	# Get tile map data at the converted mouse position...
	var tile_data: TileData = tml_layer.get_cell_tile_data(tml_mouse_pos)
	# Check if exists...
	if tile_data:
		#print("Got Data")
		return tile_data.get_custom_data(custom_tilemap_data_name)
	else:
		#print("NO DataTile here")
		return false
	
