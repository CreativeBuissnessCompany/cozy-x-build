#  item_sprite_sheet.gd
extends Item

class_name Item_Sprite_Sheet


var sprite_sheet_png: AtlasTexture 



func _init() -> void:
	icon = sprite_sheet_png
