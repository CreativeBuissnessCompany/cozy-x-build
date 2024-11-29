# farm.gd
@icon("res://themes/editor_icons/crops_icon.png")
extends BaseScene



#                                      VARIABLES 

@export var camera_bounds: Vector4i 
var crop_to_seed_scene: PackedScene  = preload("res://components/seed_to_crop/seed_to_crop.tscn")

#			TileMapLayers

@onready var dirt_paths_tml:TileMapLayer= %DirtPaths
@onready var tilled_tml:TileMapLayer = %Tilled
@onready var watered_tml:TileMapLayer= %Watered
@onready var crops_tml:TileMapLayer= %Crops

#			Seed Info

var terrain_set:int = 0 # 1st Terrain Set
# Source ID's
var source_id: int
var dirt_tiles_source_id:= 5 
var scene_source_id := 3
# Terrains, 1st Set ( Index is actually 0, Computers dumb )
var tilled_terrain: int = 10 # From 5
var watered_terrain: int = 11 # From 6
# 			Tile Containers ...
var dirt_tiles: Array = []
var wet_tiles: Array = []
#var dirt_tiles_to_replace: Array = []      11.19 coment out
# Scenetile ID for SEEDS
var scene_tile_id := 1

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

#			Audio
var sfx_file: AudioStreamMP3
@export var sfx_till: AudioStreamMP3 
@export var sfx_watering: AudioStreamMP3 
@export var sfx_seed: AudioStreamMP3

#			Misc...

var ui_open: bool = false # Signal from inventory, to Stop User input if UI is open ....
var seed_selected: Item # Signal received from inventory ....








#								Script_Start 
func _enter_tree() -> void:
	super()
	check_day()
	print("farm entering")
	# Update Camera
	GameData.camera_bounds = camera_bounds
	Signalbus.camera_limits.emit()
	

func _ready() -> void:
	super()
	# Connects to ItemSlot in inventory_ui
	Signalbus.item_clicked.connect(on_seed_selected)
	# Connects to inventory_ui, To stop User input while UI open
	Signalbus.ui_open.connect(on_ui_open)
	#  Connects to SeedToCrop .... To delete Crop when pickup instantiated....
	Signalbus.delete_crop.connect(on_delete_crop)
	# To set crop
#	print_debug("Farm is Ready ...")
	Signalbus.crop_ready.connect(on_crop_ready)
	
	
	

func _input(_event: InputEvent) -> void:
	
	# E key Till
	if Input.is_action_just_pressed("toggle_dirt"):
		farming_mode_state = FARMING_MODES.TILL
		#print("Till State")
	
	# R key Water
	if Input.is_action_just_pressed("toggle_water"):
		farming_mode_state = FARMING_MODES.WATERING
		#print("Water State")
	
# NEW
	# T key Harvest
	if Input.is_action_just_pressed("toggle_harvest"):
		farming_mode_state = FARMING_MODES.HARVEST
		print("Harvest State Toggled")



	
	# NOTE Need to make it so only active 
	# when close to farming area ....
	if Input.is_action_pressed("click"):
		# Whats the pos of Mouse? Vector 2
		var mouse_pos: Vector2 = get_global_mouse_position()
		var state: int         = farming_mode_state
		# Farming Func ...
		# TEST Check if mouse is on tml 3 or 4 
		
		if ui_open == false:
			if farming_mode_state != FARMING_MODES.HARVEST:
					
				farming(state, mouse_pos)
				#print(" 'click' at farm.gd")
				return
			else:
				print("Bout to harvest")
				harvest(mouse_pos)
				pass



#						NOTE Custom Functions ... NOTE 



func plant_seed(mouse_pos: Vector2i) -> void :

	var mouse_pos_for_data = Utility.convert_mos_local(tilled_tml,mouse_pos) 
	if retrieving_custom_data(tilled_tml, mouse_pos_for_data, can_plant):
		var seed_scene: SeedToCrop = crop_to_seed_scene.instantiate() # Instantiate
		crops_tml.add_child(seed_scene) # Add child 
		seed_scene.global_position = tilled_tml.map_to_local(mouse_pos_for_data) # Set position
		 # Set Item Data to Current seed_selected data ... 
		seed_scene.set_crop_data(seed_selected)
		CropData.crop_array.append(seed_scene)
		print()
		print("Just appended")
		print(CropData.crop_array)
		# >>>                  >>>
		# Wait for it to get added to the tree ....
#		await get_tree().process_frame
#		await get_tree().process_frame   # Commented out on new func make....
		# >>>                  >>>
		
		# SEED SFX
		if ui_open == false:
			Signalbus.sfx.emit(sfx_seed) # play sound
	return


		
func harvest(_mouse_pos):
	var local_mos = Utility.convert_mos_local(crops_tml,_mouse_pos)
	Signalbus.harvest.emit(local_mos)
	print("harvest in farm.gd")
	# Get tile from mos_pos, Do func on it
	pass

## Uses function check_day() ....Triggered by Signal emitted by SeedToCrop ...
func on_crop_ready() -> void:
	print("farm, on_crop_ready")
#	check_day()
	return



func on_delete_crop(coords):
	var local_coords: Vector2 = crops_tml.to_local(coords)
	var cell: Vector2i = crops_tml.local_to_map(local_coords)
	crops_tml.erase_cell(cell)

# For SFX and Farming, BLOCKS INPUT Etc..
func on_ui_open():
	ui_open = !ui_open


func on_seed_selected(item_resource: Item):
	if item_resource.item_type == Item.ITEM_TYPE.SEED:
		
		farming_mode_state = FARMING_MODES.PLANT_SEED
		seed_selected = item_resource
		# NOTE  Close UI
		var inventory_ui: InventoryUI = get_parent().find_child("InventoryUI")
		inventory_ui._on_close_button_pressed()
		

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
			tiles = wet_tiles # Empty before this , Needed or else all previously TILL tiles\
								# Will get watered at once ....
			terrain = watered_terrain
			custom_data = can_water_custom_data
			sfx_file = sfx_watering
	
		FARMING_MODES.PLANT_SEED:
		
			# TEST
			plant_seed(mouse_pos)	
		
	
#			layer_to_look = tilled_tml 
#			layer_to_place = crops_tml 
#			custom_data = can_plant
#			source_id = scene_source_id # Maybe change for scene tile , from 1 to 3
#			sfx_file = sfx_seed
#			
#			var mouse_pos_for_data           = Utility.convert_mos_local(layer_to_look,mouse_pos) # All same ?
#			var mouse_pos_for_seed: Vector2i = crops_tml.local_to_map(get_local_mouse_position())
#			# Seed SceneTile
#			if retrieving_custom_data(layer_to_look, mouse_pos_for_data, custom_data):
#				# Set Scenetile in the ground first.... Add sourceid and tile id, seed_cord to (0,0)
#				layer_to_place.set_cell(mouse_pos_for_seed,source_id, Vector2i(0,0),scene_tile_id)
#				# Wait for it to get added to the tree ....
#				await get_tree().process_frame
#				await get_tree().process_frame
#				
#				var child: Node = layer_to_place.get_child(-1)
#				#var child = layer_to_place.call_deferred("get_child", -1)
#				on_crop_ready(child) # NOTE Check for seed_selected variable ////
#				# Set Item Data to Current  
#				child.item_data = seed_selected
#				
#				# NOTE SEED SFX
#				if ui_open == false:
#					Signalbus.sfx.emit(sfx_file)
	
	
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
