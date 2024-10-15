# farm.gd
extends BaseScene

# Variables
# TileMapLayers
@onready var tml_1:= %"01BrightGrass"
@onready var tml_2:= %"02DirtPaths"
@onready var tml_3:= %"03TilledAndWatered"
@onready var tml_4:= %"04Crops"

# 1st Terrain Set
var terrain_set:int = 0 
# Source ID
var source_id
var dirt_tiles_source_id: int = 5 
var scene_source_id = 3

# Terrains within 1st Set
var tilled_terrain_02: int = 10 # From 5
var watered_terrain_02: int = 11 # From 6

# Tile Containers ...
var dirt_tiles: Array = []
var wet_tiles: Array = []
var dirt_tiles_to_replace: Array = []

var dirt_tile_data: Dictionary = {
	"tile location" : 0,
	"atlas coords" : Vector2(0,0)
}

# Scenetile ID for SEEDS
var scene_tile_id := 1

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
# Day Change
var current_day: int = 1
# Audio
var sfx_file: AudioStreamMP3
@export var sfx_till: AudioStreamMP3 
@export var sfx_watering: AudioStreamMP3 
@export var sfx_seed: AudioStreamMP3
#Stop User input if UI is open ....
var ui_open: bool = false
# When selecting seed from inventory ....
var seed_selected: Item








#Script_Start 
func _enter_tree() -> void:
	super()
	check_day()


func _ready() -> void:
	super()
	# Connects to ItemSlot in inventory_ui
	Signalbus.item_clicked.connect(on_seed_selected)
	# Connects to inventory_ui, To stop User input while UI open
	Signalbus.ui_open.connect(on_ui_open)
	#  Connects to SeedToCrop .... To delete Crop when pickup instantiated....
	Signalbus.delete_crop.connect(on_delete_crop)


# Player Inputs at Farm ...
func _input(_event: InputEvent) -> void:
	
	# E key
	if Input.is_action_just_pressed("toggle_dirt"):
		farming_mode_state = FARMING_MODES.TILL
		#print("Till State")
	
	# R key
	if Input.is_action_just_pressed("toggle_water"):
		farming_mode_state = FARMING_MODES.WATERING
		#print("Water State")
	
	
	# Mouse click, Farming Happening ..
	if Input.is_action_pressed("click"):
		# Whats the pos of Mouse? Vector 2
		var mouse_pos: Vector2 = get_global_mouse_position()
		var state = farming_mode_state
		# Farming Func ...
		farming(state, mouse_pos)
		print(" Trying To Farm at Farm.gd")
		return





# NOTE Custom Functions ...
# Used for deleting CropToSeed when it turns into a Fruit/Veggie ...
func on_delete_crop(coords):
	var local_coords = tml_4.to_local(coords)
	var cell = tml_4.local_to_map(local_coords)
	tml_4.erase_cell(cell)
	#print(" Erased Cell At ....", cell )




func on_ui_open():
	ui_open = !ui_open
	#print(" UI Status")
	#print(ui_open)


func on_seed_selected(item_resource: Item):
	if item_resource.item_type == Item.ITEM_TYPE.SEED:
		farming_mode_state = FARMING_MODES.PLANT_SEED
		seed_selected = item_resource
		# NOTE  Close UI
		var inventory_ui: InventoryUI = get_parent().find_child("InventoryUI")
		inventory_ui._on_close_button_pressed()
		
		
		#print("Clicked Seed to Plant")


func farming(state,mouse_pos):
	
	match state:
		FARMING_MODES.TILL:
			layer_to_look = tml_2 
			layer_to_place = tml_3
			tiles = dirt_tiles
			terrain = tilled_terrain_02
			custom_data = can_till_custom_data
			sfx_file = sfx_till
	
		FARMING_MODES.WATERING:
			layer_to_look = tml_3
			layer_to_place = tml_3
			tiles = wet_tiles
			terrain = watered_terrain_02
			custom_data = can_water_custom_data
			sfx_file = sfx_watering
	
		FARMING_MODES.PLANT_SEED:
			layer_to_look = tml_3
			layer_to_place = tml_4
			custom_data = can_plant
			source_id = scene_source_id # Maybe change for scene tile , from 1 to 3
			sfx_file = sfx_seed
			
			var mouse_pos_for_data = Utility.convert_mos_local(layer_to_look,mouse_pos)
			var mouse_pos_for_seed = tml_4.local_to_map(get_local_mouse_position())
			
			if retrieving_custom_data(layer_to_look, mouse_pos_for_data, custom_data):
				# # Scenetile, Add sourceid and tile id, seed_cord to (0,0)
				layer_to_place.set_cell(mouse_pos_for_seed,source_id, Vector2i(0,0),scene_tile_id)
				await get_tree().process_frame
				# Grab SceneTile as Node from Parent ...
				var child = layer_to_place.get_child(-1)
				# Set Item Data to Current  
				child.item_data = seed_selected
				print(" Changing selected Seed")
				# NOTE SEED SFX
				if ui_open == false:
					Signalbus.sfx.emit(sfx_file)
	 # Farming Func for NOT seeds
	if farming_mode_state != FARMING_MODES.PLANT_SEED:
		# After STATE match, Do work ...
		var mouse_pos_for_farming = Utility.convert_mos_local(layer_to_look,mouse_pos)
		if retrieving_custom_data(layer_to_look, mouse_pos_for_farming, custom_data):
			tiles.append(mouse_pos_for_farming) 
			if farming_mode_state == FARMING_MODES.WATERING:
				# Store dirt tile first
				dirt_tile_data["tile location"] = mouse_pos_for_farming
				var dirt_coords = tml_3.get_cell_atlas_coords(mouse_pos_for_farming)
				dirt_tile_data["atlas coords"] = dirt_coords
				dirt_tiles_to_replace.append(dirt_tile_data.duplicate())
				Signalbus.emit_signal("watered", mouse_pos_for_farming)
			
			# After storing dirt tiles, Place dirt or watering tile
			layer_to_place.set_cells_terrain_connect(tiles,terrain_set, terrain) 
		
		
		# Beware, May need to tab shift back a bit.... if farmingmode watering may be interfereing..
		# If that worked, Pop Tile Array to try to fiz issues with placement 
			if wet_tiles.size() or dirt_tiles.size() >= 3:
				wet_tiles.pop_back()
				dirt_tiles.pop_back()
	
	if ui_open == false:
		Signalbus.sfx.emit(sfx_file)
		# NOTE Do When UI Closed....


func check_day():
	
	if time_tracker.day > current_day:
		if dirt_tiles_to_replace:
			for tile in dirt_tiles_to_replace:
				# Reset dirt_tiles
				tml_3.set_cell(tile["tile location"], dirt_tiles_source_id, tile["atlas coords"]) # Changed from farmhouse - 0
				
		# Set day Eitherway... As long as Timetracker.day is bigger than current day in farm 
		current_day = time_tracker.day
		# Clear Dirt Tiles Array
		dirt_tiles_to_replace.clear()
		# Clear Dict
		dirt_tile_data.clear()


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
