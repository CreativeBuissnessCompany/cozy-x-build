# highlight_tile.gd
extends Node2D


# Variables 
@onready var color_rect: ColorRect = $ColorRect

var new_pos
var offset = Vector2(5,5)
var tilemap_target: TileMapLayer
var tile_array: Array = []
var wait_time: float = 0.15

var highlight_atlas_coords = Vector2(0,0)

var tilemap_to_copy
var highlight_tilemap


func _ready() -> void:
	var parent = get_parent() # 04CropTileMapLayer3 Highlight
	tilemap_target = parent.find_child("Highlight")
	print(tilemap_target.name)
	#print(tilemap_target)
	pass 



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	 
	var mos_pos: Vector2i = get_global_mouse_position()
	var mouse_pos_tml: Vector2 = Utility.convert_mos_local(tilemap_target, mos_pos)
	# Store Atlas Coords of selected Tile ....
	tile_array.append(tilemap_target.get_cell_atlas_coords(mouse_pos_tml))
	# Change Tile to Highlight PNG
	tilemap_target.set_cell(mouse_pos_tml, 2, highlight_atlas_coords)
	# Create Timer and Wait for TimeOut...
	await get_tree().create_timer(wait_time).timeout
	# Grab the previous Tile and Put it back where it belongs ....
	tilemap_target.set_cell(mouse_pos_tml, 0, tile_array[0])
	
	
