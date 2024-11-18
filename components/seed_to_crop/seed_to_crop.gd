# seed_to_crop.gd
#@tool
class_name CropToSeed extends AnimatedSprite2D


# Variables

# Where we get the texture and such for seed to crop 
@export var item_data: Item:
	set(value):
		item_data = value
		# Used for when farm.gd sets data ...
		self.sprite_frames = item_data.sprite_frame
		#print("    item_data changed ...... .... //// /// // ")


@onready var animation_player: AnimationPlayer = %AnimationPlayer

# Set Stages ..
var stage_one: int
var stage_two: int
var stage_three: int
var stage_four: int
var stage_five: int
var stage_six: int
var stage_seven: int
var last_stage: int

@export var current_stage: int:
	set(value):
		current_stage = value
		print(" ")
		print(" Someone Changed current_stage !!!!!!!!")
		print(" ")

var day_planted: int
var days_since_planted: int = 0
var current_day: int 
#var current_frame: float = 0.00
var watered: bool = false:
	set(value):
		watered = value
		#print("Watered Variable Changed to ..")
		#print("......", watered)

var days_watered: int = 0

# Path for Directory of "from_seed" ...
var dir_path: String = "res://entities/items/consumables/from_seed_pickups/"
# Directory for Fully grown versions of seeds....Fruit,Veggie....
var dir = DirAccess.open(dir_path)
var grown: bool = false
# Pack 'em up
var crops_array: Array = []






# Script_Start
func _ready() -> void:
	
	
	# From Farm.gd...
	Signalbus.connect("watered", _on_watered)
	
	
	
	# Setting Vars from GameData...
	if GameData.crop_array:
		#print(" crop_array exists .... ")
		 #NOTE Get Crops Data from GameData
		
		# TEST Try a for loop .... With a Dictionary ....
		crops_array = GameData.all_crops_array[-1]
		
		days_watered = GameData.crop_array[-7]
		current_stage = GameData.crop_array[-6]
		days_since_planted = GameData.crop_array[-5]
		current_day = GameData.crop_array[-4]
		day_planted = GameData.crop_array[-3]
		watered = GameData.crop_array[-2]
		item_data = GameData.crop_array[-1]
		
		# --- NOTE Changed 11/11      # Set most recent stage ( current_stage)
		#current_stage = item_data.current_stage
		print("After GameData Loop.... current_stage is"," ", current_stage)
		
		
		# TEST Change...
		
		# Clear array after grabbing from it NOTE
		var array_size: int = 7 # NOTE Should reflect GameData.crop_array size
		while array_size != 0:
			GameData.crop_array.pop_back()
			array_size -= 1
			
	#Or Else ... Set DayPlanted
	else:
		# If no saved data, This must be its first day planted....
		day_planted = time_tracker.day
	
	
	
	
	
	#NOTE New, Set stages
	item_set()
	
	
	# Do math for days planted .... # Also ...advance days_watered ...
	if watered == true:
		#print("Watered is true in Ready ")
		if time_tracker.day > day_planted and time_tracker.day > current_day:
			
			# NOTE NEW 11/14 ( OLD )
			days_watered += 1
			print("time_tracker > day_pland and current_day ")
			days_since_planted = time_tracker.day - day_planted
			print("days_since_planted...", " ",days_since_planted)
			
			advance_stage(days_watered)
			watered = false 
			print("Water changed to false in Ready/ if watered == true: loop")
	#NOTE new, Was indented one more
	current_day = time_tracker.day
	
	
	 #Grab animation NAME from Item Resource....
	var animation_name = item_data.animation_resize_check()
	animation_player.play(animation_name)
	animation_player.pause()
	animation_player.seek(current_stage, true) 
	print("End of @Ready , Current Stage ", " ", current_stage)
	print("")
	#animation_player.pause()
	
	# Old Block
	# If current day bigger than day on recorded, watered false. For when you change scene 
	#-Without proceeding to the next day
	#if current_day <= time_tracker.day:
		#print("current_day Smaller or Equal to GameData.day")
		#watered = false 
	## Set Day after the check above 
	#current_day = time_tracker.day
	#advance_stage(days_watered)
	#print("Advancing Stage")


# ------- NOTE ------- Tool........ 
#func _process(delta: float) -> void:
	#if Engine.is_editor_hint():
		#
		##self.frame = current_stage
		#animation_player.seek(current_stage, false) 
		##pass
	## Code to execute in editor.




# NOTE Custom Functions ........

#Splitting Function up...
func item_set():
	
	stage_one = item_data.stage_one
	stage_two = item_data.stage_two
	stage_three = item_data.stage_three
	stage_four = item_data.stage_four
	stage_five = item_data.stage_five
	stage_six = item_data.stage_six
	stage_seven = item_data.stage_seven
	last_stage = item_data.last_stage


func _on_watered(mos_pos):
	
	var parent = get_parent()
	var tile_pos_local = Utility.convert_mos_local(parent,global_position )
	
	if mos_pos == tile_pos_local:
		watered = true


func advance_stage(_days_since_planted):
	
	match _days_since_planted:
		
		stage_one:
			current_stage = stage_one
			#print("Stage One")
		
		stage_two:
			current_stage = stage_two
			#print("Stage Two")
			
		stage_three:
			current_stage = stage_three
			#print("Stage Three")
			
		stage_four:
			current_stage = stage_four
			#print("Stage Four")
			
		stage_five:
			current_stage = stage_five
			#print("Stage Five")
			
		stage_six:
			current_stage = stage_six
			#print("Stage Six")
			
		stage_seven:
			current_stage = stage_seven
			#print("Stage Seven")
			
		_:    #WILDCARD All else fails, Set to previous stage  NOTE 11/14
			#current_stage = item_data.current_stage 
			print("Wild Card Statement ")
	
	
	print("advance_stage() is done ", " current stage is ..", current_stage)
	
	
	# NOTE New After Match , Do this no matter what ....
	#animation_player.seek(current_stage, true) # ALERT Maybe change to false .....
	# Last Stage ...
	if current_stage == last_stage:
		last_stage_process()
	

#NOTE added 11/13 ...
func last_stage_process():
	print("last_stage_process called ")
	grown = true
	# Delete word "Seed" from item name....Space before the word "seed" aswell ...
	var item_name = item_data.name.replacen(" seed","")
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.containsn(item_name):
			# Combine Directory Path with File Path for full path...
			var full_path = dir_path + file_name
			# Load, Instantiate
			var crop_scene: PackedScene = load(full_path)
			var instanced_scene = crop_scene.instantiate()
			# Position
			instanced_scene.global_position = self.global_position
			var pickups_node = get_parent().owner.find_child("PickUps")
			pickups_node.add_child(instanced_scene)
			# NOTE Changed on 10/13... Unindented by one
			# Set grown to true so we dont send data to GameData
			Signalbus.delete_crop.emit(self.global_position)
			get_parent().remove_child(self)
			self.queue_free()
		#------ END IF STATEMENT ------
		# Loop through untill you cant ...
		file_name = dir.get_next()
	#------ END WHILE STATEMENT ------


func _exit_tree() -> void:
	# Send Data if Grown not true ...
	if not grown:
		
		# TEST Try a for loop ....
		 # Pack the array
		var crop_array: Array = [
			days_watered,
			current_stage,
			days_since_planted,
			current_day,
			day_planted,
			watered,
			item_data
		]
		
		GameData.all_crops_array.append(crop_array)
		
		
		# Set current Stage 
		print_debug("EXIT TREE Current Stage is ... ", " ", current_stage)
		print(crop_array)
		print(" ")
		
		#item_data.current_stage = current_stage
		
		GameData.crop_array.append(days_watered)
		GameData.crop_array.append(current_stage)
		GameData.crop_array.append(days_since_planted)
		GameData.crop_array.append(current_day)
		GameData.crop_array.append(day_planted)
		GameData.crop_array.append(watered)
		GameData.crop_array.append(item_data)
		
		#print_debug("Exiting Tree")
		#print("Appending GameData ....")
		
	else: # Maybe check for last stage 
		print(" No GameData Update  ")
		return
