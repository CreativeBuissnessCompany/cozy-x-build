class_name Item
extends Resource

enum ITEM_TYPE {DEFAULT, SEED, RESIZE}
@export var item_type: ITEM_TYPE = ITEM_TYPE.DEFAULT
@export var name:String
#@export var scene:PackedScene
#@export var icon:Texture2D
@export_multiline var description: String = ""
@export var price: int = 0
var qty: int = 1
# New
@export var sprite_frame: SpriteFrames
