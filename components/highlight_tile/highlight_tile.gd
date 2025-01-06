# highlight_tile.gd
@icon("res://components/highlight_tile/tile-selection.png")
extends Node2D


# Variables 
#@onready var color_rect: ColorRect = $ColorRect
@onready var dirt_paths: TileMapLayer = %DirtPaths


var offset: Vector2 = Vector2(5,5)
var tilemap_target: TileMapLayer
var tile_array: Array
var wait_time: float = 0.20

var highlight_atlas_coords: Vector2 = Vector2(0,0)

var tilemap_to_copy
var highlight_tilemap


func _ready() -> void:
	var parent: Node = get_parent() # 04CropTileMapLayer3 Highlight
	tilemap_target = parent.find_child("Highlight")
	
	pass 



func _process(_delta: float) -> void:
	 
	var mos_pos: Vector2i = get_global_mouse_position()
	var mouse_pos_tml: Vector2 = Utility.convert_mos_local(tilemap_target, mos_pos)
	if tile_array:
		for tile in tile_array:
			tilemap_target.erase_cell(tile)
		# Store Atlas Coords of selected Tile ....
	tile_array.append(mouse_pos_tml)
		# Change Tile to Highlight PNG
	tilemap_target.set_cell(mouse_pos_tml, 2, highlight_atlas_coords)
	


#                           TESTING Copy from farm.gd ....
## Check TileMapLayer for custom data in a Tile at tml_mos_pos ( conversion done inside ) ... 
func retrieving_custom_data(tml_layer: TileMapLayer,\
tml_mouse_pos: Vector2, custom_tilemap_data_name: String) -> Variant:

	# Get tile map data at the converted mouse position...
	var tile_data: TileData = tml_layer.get_cell_tile_data(tml_mouse_pos)
	# Check if exists...
	if tile_data:
		return tile_data.get_custom_data(custom_tilemap_data_name)
	else:
		return false
	
