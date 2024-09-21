# farm.gd
extends BaseScene


## NOTE : Tilling is happening on top of tilemap layers, And watering ontop of Tilling. 
# Seeds

# @Onready.. 

# TileMapLayers
@onready var tml_1:= $"01FarmGrass_TileMapLayer"
@onready var tml_2:= $"02GrassOnDirt_TileMapLayer"
@onready var tml_3:= $"03TilledAndWateredTileMapLayer2"
@onready var tml_4:= $"04CropTileMapLayer3"

#  Variables ....  

# 1st Terrain Set
var terrain_set:int = 0

# Tile Data/Info.... for custom data? Maybe Unused
var terrain_sourceid_farmhouse: int = 0
var source_id

# Second Image SourceID, Seeds and Crops
var terrain_sourceid_crops:int = 1

# Terrains within 1st Set
var tilled_terrain:int = 2
var watered_terrain:int = 3
var seed_terrain:int = 4
# Tile Arrays ...
var dirt_tiles: Array = []
var wet_tiles: Array = []
# Seed AtlasCoords
var seed_coords: Vector2i = Vector2i(0,4)



# Farming States ...
enum FARMING_MODES {WATERING, TILL, PLANT_SEED}
# Current State of Farming mode 
var farming_mode_state := FARMING_MODES.TILL

# Holds the string name for the custom data we want...
var can_till_custom_data: String = "can_till"
var can_water_custom_data: String = "can_water"
var can_plant: String = "can_plant"

# Empty vars until used by farming()
var layer_to_look: TileMapLayer
var layer_to_place: TileMapLayer
var tiles: Array
var terrain: int
var custom_data: String









func _ready() -> void:
	super()
	# Connects to ItemSlot in inventory_ui
	Signalbus.item_clicked.connect(on_seed_selected)
	#print("Farm Ready ")



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


func on_seed_selected(item_resource: Item):
	if item_resource.item_type == Item.ITEM_TYPE.SEED:
		farming_mode_state = FARMING_MODES.PLANT_SEED
		print("Clicked Seed to Plant")
	pass



# Test Func .... FARMING FUNC
func farming(state,mouse_pos):
	
	match state:
		FARMING_MODES.TILL:
			layer_to_look = tml_2 
			layer_to_place = tml_3
			tiles = dirt_tiles
			terrain = tilled_terrain
			custom_data = can_till_custom_data
			
	
		FARMING_MODES.WATERING:
			layer_to_look = tml_3
			layer_to_place = tml_3
			tiles = wet_tiles
			terrain = watered_terrain
			custom_data = can_water_custom_data
			
	
	# NOTE Test ...
		FARMING_MODES.PLANT_SEED:
			layer_to_look = tml_3
			layer_to_place = tml_4
			#terrain = seed_terrain
			custom_data = can_plant
			source_id = 3 # Maybe change for scene tile , from 1 to 3
			var scene_tile_id = 1
			print("Farming Mode Seed") 
			
			var mouse_pos_for_data = Utility.convert_mos_local(layer_to_look,mouse_pos)
			var mouse_pos_for_seed = tml_4.local_to_map(get_local_mouse_position())
			
			if retrieving_custom_data(layer_to_look, mouse_pos_for_data, custom_data):
				# # Scenetile, Add sourceid and tile id, seed_cord to (0,0)
				layer_to_place.set_cell(mouse_pos_for_seed,source_id, Vector2i(0,0),scene_tile_id) 
				#print("Checked for Seed Data, Tried to place")
				print("layer_to_place : %s" % mouse_pos_for_data)
				return
			
			
	
	if farming_mode_state != FARMING_MODES.PLANT_SEED:
		print("Not in seed mode")
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
	
