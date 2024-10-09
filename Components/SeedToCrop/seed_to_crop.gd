# seed_to_crop.gd
class_name CropToSeed extends Sprite2D

# Variables
# Where we get the texture and such for seed to crop
@export var item_data: Item
@onready var animation_player: AnimationPlayer = %AnimationPlayer

# New, Set stages in inspector
@export var stage_one: int
@export var stage_two: int
@export var stage_three: int
@export var stage_four: int
@export var stage_five: int
@export var stage_six: int
@export var stage_seven: int
@export var last_stage: int
@export var current_stage: int

var day_planted: int
var days_since_planted: int = 0
var current_day: int 
var current_frame: float = 0.00
var watered: bool = false
var days_watered: int = 0








# Script_Start
func _ready() -> void:
	# From Farm...
	Signalbus.connect("watered", _on_watered)
	
	# Setting Vars ...
	if GameData.crop_array:
		 #Get Crops Data from GameData
		 #Set
		days_watered = GameData.crop_array[-5]
		current_day = GameData.crop_array[-4]
		day_planted = GameData.crop_array[-3]
		current_frame = GameData.crop_array[-2]
		watered = GameData.crop_array[-1]
		
		# Pop
		GameData.crop_array.pop_back()
		GameData.crop_array.pop_back()
		GameData.crop_array.pop_back()
		GameData.crop_array.pop_back()
		GameData.crop_array.pop_back()
		
	#Or Else ...
	else:
		day_planted = time_tracker.day
	if watered == true:
		if time_tracker.day > day_planted:
			days_watered += 1
			days_since_planted = time_tracker.day - day_planted
			print(" days_watered ")
			print(days_watered)
	
	# Set Animationplayer @ 0.00 in "default" Animation
	animation_player.play("default")
	animation_player.seek(current_frame, true)
	animation_player.pause()
	
	if watered == true:
		# Advance to next stage of plant growth...
		advance_stage(days_watered)
		
	
	# If day bigger than day on record, watered false
	if current_day < time_tracker.day:
		# Set watered to false
		watered = false 
	
	# NOTE Happens no matter what 
	# Set Day 
	current_day = time_tracker.day
	


func _on_watered(mos_pos):
	
	var parent = get_parent()
	var tile_pos_local = Utility.convert_mos_local(parent,global_position )
	
	if mos_pos == tile_pos_local:
		watered = true


func advance_stage(_days_since_planted):
	
	
	
	match _days_since_planted:
		
		stage_one:
			current_stage = stage_one
			animation_player.seek(0.00, true)
			print("Stage One")
		
		stage_two:
			current_stage = stage_two
			animation_player.seek(1.00, true)
			print("Stage Two")
			
		stage_three:
			current_stage = stage_three
			animation_player.seek(2.00,true)
			print("Stage Three")
			
		stage_four:
			current_stage = stage_four
			animation_player.seek(3.00,true)
			print("Stage Four")
			
		stage_five:
			current_stage = stage_five
			animation_player.seek(4.00,true)
			print("Stage Five")
			
		stage_six:
			current_stage = stage_six
			animation_player.seek(5.00,true)
			print("Stage Six")
			
		stage_seven:
			current_stage = stage_seven
			animation_player.seek(6.00,true)
			print("Stage Seven")
			
	# Last Stage ...
	if current_stage == last_stage:
		print("Last Stage")
		print(item_data.name)
		# Delete word "Seed" from item name....
		var name = item_data.name.replacen("seed","")
		print(name)
		var dir = DirAccess.open("res://Entities/items/consumables/from_seed_pickups/")
	
		
	
	animation_player.pause()
	current_frame = animation_player.current_animation_position
	
	


func _exit_tree() -> void:
	# Send
	GameData.crop_array.append(days_watered)
	GameData.crop_array.append(current_day)
	GameData.crop_array.append(day_planted)
	GameData.crop_array.append(current_frame)
	GameData.crop_array.append(watered)
	
	pass
