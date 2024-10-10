class_name Item
extends Resource

enum ITEM_TYPE {DEFAULT, SEED}
@export var item_type: ITEM_TYPE 

@export var name:String
@export var scene:PackedScene
@export var icon:Texture2D
@export_multiline var description: String = ""
@export var price: int = 0
var qty: int = 1
