# highlight_tile.gd
extends Node2D


# Variables 
@onready var color_rect: ColorRect = $ColorRect

var new_pos
var offset = Vector2(5,5)
var tilemap_target: TileMapLayer
var tile_array: Array = []


func _ready() -> void:
	var parent = get_parent()
	tilemap_target = parent.get_child(-4)
	#print(tilemap_target)
	pass 



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var mos_pos = get_global_mouse_position()
	var mouse_pos_tml = Utility.convert_mos_local(tilemap_target, mos_pos)
	# Store Atlas Coords of selected Tile ....
	tile_array.append(tilemap_target.get_cell_atlas_coords(mouse_pos_tml))
	# Change Tile to Highlight PNG
	tilemap_target.set_cell(mouse_pos_tml, 0, Vector2(9,13))
	# Wait 0.5 seconds
	await get_tree().create_timer(0.2).timeout
	# Grab the previous Tile 
	tilemap_target.set_cell(mouse_pos_tml, 0, tile_array[0])
	
	
	#print("finalmos", mouse_pos_tml)
	#var highlight = Vector2i(mouse_pos_tml)
	#color_rect.position = highlight
	#print(color_rect.position)
	#
	#new_pos = get_global_mouse_position()
	#print(new_pos)
	#color_rect.position = new_pos - offset
	#pass
	#
