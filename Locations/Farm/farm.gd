# farm.gd
@icon("res://themes/editor_icons/crops_icon.png")
extends BaseScene



#                                      VARIABLES 

@export var camera_bounds: Vector4i # NOTE Test when you move it to misc. 
var crop_to_seed_scene: PackedScene  = preload("res://components/seed_to_crop/seed_to_crop.tscn")

#			TileMapLayers

@onready var dirt_paths_tml:TileMapLayer= %DirtPaths
@onready var tilled_tml:TileMapLayer = %Tilled
@onready var watered_tml:TileMapLayer= %Watered
@onready var crops_tml:TileMapLayer= %Crops

#			Seed Info

var terrain_set:int = 0 # 1st Terrain Set

# Terrains, 1st Set ( Index is actually 0, Computers dumb )
var tilled_terrain: int = 10 
var watered_terrain: int = 11 
# 			Tile Containers ...
var dirt_tiles: Array = []
var wet_tiles: Array = []

# Scenetile ID for SEEDS
var scene_tile_id := 1  #                                       NOTE Seemingly Unused Delete ....

#			Farming Stuff ...

enum FARMING_MODES {WATERING, TILL, PLANT_SEED, HARVEST}
var farming_mode_state := FARMING_MODES.TILL
var can_till_custom_data: String = "can_till"
var can_water_custom_data: String = "can_water"
var can_plant: String = "can_plant"
# Empty vars until used by farming()
var layer_to_look: TileMapLayer
var layer_to_place: TileMapLayer
var tiles: Array
var terrain: int
var custom_data: String

#			Day Change

var current_day: int = 1

#			Audio      NOTE Probably move this out ...
var sfx_file: AudioStreamMP3
@export var sfx_till: AudioStreamMP3 
@export var sfx_watering: AudioStreamMP3 
@export var sfx_seed: AudioStreamMP3

#			Misc...

var ui_open: bool = false # Signal from inventory, to Stop User input if UI is open ....
var seed_selected: Item # Signal received from inventoryUI ....




#								                     Script Start... 


# super(), check_day(), Sends camera_limits ...
func _enter_tree() -> void:
	super()
	check_day()

	# Update Camera
	GameData.camera_bounds = camera_bounds
	Signalbus.camera_limits.emit()
#	print("farm entering")
	

func _ready() -> void:
	super()
	# Connects to ItemSlot in inventory_ui NOTE 01/07
#	Signalbus.item_clicked.connect(on_seed_selected)
	# Connects to inventory_ui, To stop User input while UI open
	Signalbus.ui_open.connect(on_ui_open)
	#  Connects to SeedToCrop .... To delete Crop when pickup instantiated....
	Signalbus.delete_crop.connect(on_delete_crop)
	# Changed from Signalbus.item_clicked.connect(on_seed_selected)
	Signalbus.seed_selected.connect(on_seed_selected)
	

		
	
# Controls are.... Press E To Toggle Till, R For Water, T For Harvest 
# Click does the action thats Toggled ...
func _input(_event: InputEvent) -> void:
	
	# E key Till
	if Input.is_action_just_pressed("toggle_dirt"):
		farming_mode_state = FARMING_MODES.TILL
		print("FARMING_MODES.TILL")
	
	# R key Water
	if Input.is_action_just_pressed("toggle_water"):
		farming_mode_state = FARMING_MODES.WATERING
		print("FARMING_MODES.WATERING")
	
	# T key Harvest
	if Input.is_action_just_pressed("toggle_harvest"):
		farming_mode_state = FARMING_MODES.HARVEST
		print("Harvest State Toggled")

	# NOTE Need to make it so only active 
	# when close to farming area ....
	if Input.is_action_just_pressed("click"):
		# Whats the pos of Mouse? Vector 2
		var mouse_pos: Vector2 = get_global_mouse_position()
		var state: int         = farming_mode_state
		# Farming Func ...
		if ui_open == false: # UI CLOSED ...
			# And NOT Harvesting ...
			if farming_mode_state != FARMING_MODES.HARVEST:
				farming(state, mouse_pos)
				
				return
			else:
#				print("Bout to harvest")
				harvest(mouse_pos)
				pass



#						                           Custom Functions... 


## Converts mos_pos to tml_mos_pos, Checks for Custom Data in Tile ( " can_plant " ), Instantiates SeedToCrop ...
## Add Child to crop_tml, Set position, Run set_crop_data in SeedToCrop, Append to CropData.crop_array...
func plant_seed(mouse_pos: Vector2i) -> void :

	# New NOTE 01/07 
	if seed_selected.qty >= 1:
		print(seed_selected.qty)
		var mouse_pos_for_data = Utility.convert_mos_local(tilled_tml,mouse_pos) 
		if retrieving_custom_data(tilled_tml, mouse_pos_for_data, can_plant):
			var seed_scene: SeedToCrop = crop_to_seed_scene.instantiate() # Instantiate
			crops_tml.add_child(seed_scene) # Add child 
			seed_scene.global_position = tilled_tml.map_to_local(mouse_pos_for_data) # Set position
			 # Set Item Data to Current seed_selected data ... 
			seed_scene.set_crop_data(seed_selected)
			CropData.crop_array.append(seed_scene)
	
			
			# SEED SFX
			if ui_open == false:
				Signalbus.sfx.emit(sfx_seed) # play sound
			# New NOTE 01/07

		seed_selected.qty -= 1
	else:
		
		Utility.cozy_notification_spawner("Out of seeds brother ....", SceneManager.player, get_parent())
	
		
		
	return

## Converts mos_pos to tml_mos_pos, Sends signal to SeedToCrop to do _on_harvest() ...
func harvest(_mouse_pos):
	var local_mos = Utility.convert_mos_local(crops_tml,_mouse_pos)
	Signalbus.harvest.emit(local_mos)
#	print("harvest in farm.gd")
	# Get tile from mos_pos, Do func on it
	pass

## Unused ...Delete ? ? ?
## Uses function check_day() ....Triggered by Signal emitted by SeedToCrop ...
func on_crop_ready() -> void:
	print("farm, on_crop_ready")
#	check_day()
	return

## Triggered by signal from SeedToCrop ... Does erase_cell on TileMapLayer ...x 
func on_delete_crop(coords):
	var local_coords: Vector2 = crops_tml.to_local(coords)
	var cell: Vector2i = crops_tml.local_to_map(local_coords)
	crops_tml.erase_cell(cell)

# For SFX and Farming, BLOCKS INPUT Etc..
func on_ui_open():
	ui_open = !ui_open

## Triggered by InventoryUI
func on_seed_selected(item_resource: Item):
	if item_resource.item_type == Item.ITEM_TYPE.SEED:
		
		farming_mode_state = FARMING_MODES.PLANT_SEED
		seed_selected = item_resource
		# NOTE  Close UI
#		var inventory_ui: InventoryUI = get_parent().find_child("InventoryUI")
#		inventory_ui._on_close_button_pressed()
		
## Uses farming_state/FARMING_MODES to Check and then Match the farming modes selected....
## Uses mos_pos to change tiles for TILL, WATER and HARVEST ... Uses set_cells_terrain_connect ...
func farming(state,mouse_pos):
	
	match state:
		FARMING_MODES.TILL:
			layer_to_look = dirt_paths_tml 
			layer_to_place = tilled_tml 
			tiles = dirt_tiles # Empty before this / NEED THIS
			terrain = tilled_terrain
			custom_data = can_till_custom_data
			sfx_file = sfx_till
	
		FARMING_MODES.WATERING:
			layer_to_look = tilled_tml
			layer_to_place = watered_tml
			tiles = wet_tiles # Empty before this , Needed or else all previously TILL tiles ...
								# ... Will get watered at once ....
			terrain = watered_terrain
			custom_data = can_water_custom_data
			sfx_file = sfx_watering
	
		FARMING_MODES.PLANT_SEED:
			
			plant_seed(mouse_pos)	
	
	# NOTE                       DONE if not PLANT_SEED
	# Farming Func for NOT seeds
	if farming_mode_state != FARMING_MODES.PLANT_SEED:
		# After STATE match, Do work ...
		var mouse_pos_for_farming = Utility.convert_mos_local(layer_to_look,mouse_pos)
		# WATERING & TILL ARE LOOKING ON SAME LAYER ....
		if retrieving_custom_data(layer_to_look, mouse_pos_for_farming, custom_data):
			tiles.append(mouse_pos_for_farming) # Store for Tilling/Watering Removing at end of day? ...
			
			if farming_mode_state == FARMING_MODES.WATERING:
				dirt_tiles.append(mouse_pos_for_farming)   # Store dirt tile pos first
				Signalbus.emit_signal("watered", mouse_pos_for_farming)
			
			# Place Till or Watering tile ..... 
			layer_to_place.set_cells_terrain_connect(tiles,terrain_set, terrain) 
		
	if ui_open == false:     # NOTE Do When UI Closed....
		Signalbus.sfx.emit(sfx_file)
		

## Triggered by Signal on_day_change...Iterates over CropData.crop_array..
## Calls _on_next_day() on all crops in array, Clears array ...
func check_day():
	for index in CropData.crop_array.size():
		var crop: SeedToCrop = CropData.crop_array[index]
		print("CropData.crop_array.size is ... ")
		print(CropData.crop_array.size())
		print()
		crop._on_next_day()
	CropData.crop_array.clear()
		
	if time_tracker.day > current_day:
		if dirt_tiles.size() != 0:
			# Clear wet tiles ...
			watered_tml.clear()
			tilled_tml.set_cells_terrain_connect(dirt_tiles, terrain_set, tilled_terrain)
			tiles.clear()
			dirt_tiles.clear()
			#print(" Clearing tiles Array")
				
		# Set day Eitherway... As long as Timetracker.day is bigger than current day in farm 
		current_day = time_tracker.day
		
## Check TileMapLayer for custom data in a Tile at tml_mos_pos ( conversion done inside ) ... 
func retrieving_custom_data(tml_layer: TileMapLayer,\
tml_mouse_pos: Vector2, custom_tilemap_data_name: String) -> Variant:
	
	# Get tile map data at the converted mouse position...
	var tile_data: TileData = tml_layer.get_cell_tile_data(tml_mouse_pos)
	# Check if exists...
	if tile_data:
		#print("Got Data")
		return tile_data.get_custom_data(custom_tilemap_data_name)
	else:
		#print("NO DataTile here")
		return false
