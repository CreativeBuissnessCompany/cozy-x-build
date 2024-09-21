# seed_to_crop.gd
class_name CropToSeed extends Sprite2D

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

var day_planted: int
var days_since_planted: int = 0
var current_day: int 

var current_frame



func _ready() -> void:
	# Set Texture
	self.texture = item_data.icon
	
	# New
	# Setting Vars ...
	if GameData.crop_array:
		print("GameData Exists")
		# Get Crops, day_planted from GameData
		# Set
		day_planted = GameData.crop_array[0]
		# Pop
		GameData.crop_array.pop_front()
		#print(GameData.crop_array[0])
	#Or Else Get crops From Self
	else:
		day_planted = time_tracker.day
		print("Vars from self")
		
		
	
	# Happens no matter what 
	current_day = time_tracker.day
	days_since_planted = current_day - day_planted
	
	# Advance to next stage of plant growth...
	advance_stage(days_since_planted)
	
	

func advance_stage(_days_since_planted):
	animation_player.play("default")
	animation_player.seek(0.00, true)
	
	print(_days_since_planted)
	match _days_since_planted:
		
		stage_one:
			print("Stage One")
		
		stage_two:
			animation_player.seek(2.00, true)
			print("Stage Two")
			
		stage_three:
			animation_player.seek(3.00,true)
			print("Stage Three")
			
		stage_four:
			animation_player.seek(4.00,true)
			print("Stage Four")
			
		stage_five:
			animation_player.seek(5.00,true)
			print("Stage Five")
			
		stage_six:
			animation_player.seek(6.00,true)
			print("Stage Six")
			
		stage_seven:
			animation_player.seek(7.00,true)
			print("Stage Seven")
			
	animation_player.pause()


func _exit_tree() -> void:
	# Send
	GameData.crop_array.append(day_planted)
	print(GameData.crop_array)
	#get_parent().crops.append(crop_dict)
	print(" GameData Sent")
	pass
