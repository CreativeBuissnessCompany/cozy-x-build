# Item.gd ....

class_name Item
extends Resource


enum ITEM_TYPE {DEFAULT, SEED, RESIZE}
enum ANIMATION_RESIZE_TYPE {DEFAULT, RESIZE_16_TALL}

@export var name:String
@export_multiline var description: String = ""
@export var item_type: ITEM_TYPE = ITEM_TYPE.DEFAULT
@export var price: int = 0
var qty: int = 1
@export var sprite_frame: SpriteFrames
@export var animation_resize_type: ANIMATION_RESIZE_TYPE = ANIMATION_RESIZE_TYPE.DEFAULT 


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








func animation_resize_check() -> String:
	
	var animation_name: String
	
	
	match animation_resize_type:
		
		ANIMATION_RESIZE_TYPE.DEFAULT:
			animation_name = "default"
		
		ANIMATION_RESIZE_TYPE.RESIZE_16_TALL:
			animation_name = "resize_16_tall"
	
	
	return animation_name

	
func pack_stages_array() -> Array:
	
	var stages_array: Array = [
	stage_one,
	stage_two,
	stage_three,
	stage_four,
	stage_five,
	stage_six,
	stage_seven,
	last_stage,
	current_stage
	]
	
	return stages_array