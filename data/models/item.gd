class_name Item
extends Resource


enum ITEM_TYPE {DEFAULT, SEED, RESIZE}

@export var name:String
@export_multiline var description: String = ""
@export var item_type: ITEM_TYPE = ITEM_TYPE.DEFAULT
@export var price: int = 0
var qty: int = 1
@export var sprite_frame: SpriteFrames


# New, Set stages in inspector
@export_category("Stages")
@export var stage_one: int
@export var stage_two: int
@export var stage_three: int
@export var stage_four: int
@export var stage_five: int
@export var stage_six: int
@export var stage_seven: int
@export var last_stage: int
@export var current_stage: int
