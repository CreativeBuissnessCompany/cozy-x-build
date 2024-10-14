#  item_sprite_sheet.gd
extends Item

class_name Item_Sprite_Sheet


var sprite_sheet_png: AtlasTexture 
#var sprite_sheet_png: Sprite2D 



func _init() -> void:
	#icon = scene.texture # NOTE changed .... Becareful 10/11
	icon = sprite_sheet_png
	#print(scene)
