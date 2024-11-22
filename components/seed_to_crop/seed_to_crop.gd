#@tool                                      #seed_to_crop.gd 
class_name SeedToCrop extends AnimatedSprite2D


# Variables

# Where we get the texture and such for seed to crop 
@export var item_data: Item:
	set(value):
		item_data = value
		# Used for when farm.gd sets data ...
		self.sprite_frames = item_data.sprite_frame
		#print("    item_data changed .......... ///////// ")


@onready var animation_player: AnimationPlayer = %AnimationPlayer

# Set Stages ..
#var stages_array: Array = [] # Pack iun func dow2n there ....
var stage_one: int
var stage_two: int
var stage_three: int
var stage_four: int
var stage_five: int
var stage_six: int
var stage_seven: int
var last_stage: int



#var crop_data_array: Array = [] # Packed in a function down there.... # NOTE UNUSED
@export var current_stage: int # Tweak to better use for testing 
var day_planted: int
var days_since_planted: int = 0
var current_day: int 
var watered: bool = false
var days_watered: int = 0


# Path for Directory of "from_seed" ...
var dir_path: String = "res://entities/items/consumables/from_seed_pickups/"
# Directory for Fully grown versions of seeds....Fruit,Veggie....
var dir := DirAccess.open(dir_path)
var grown: bool = false








# Script_Start
func _ready() -> void:
	
	# From farm.gd...
	Signalbus.connect("watered", _on_watered)
	# Also from farm.gd
	print_debug("crop_ready Signal Emitted....")
	Signalbus.emit_signal("crop_ready", self)


	

#                                  Custom Functions 


# Happens from farm EVERYTIME SeedToCrop is ready, After and in Ready ...
# Made of multiple Functions ....

# TEST 
func new_last_stage_process():

	print("new_last_stage_process called ")
	
	var scene: PackedScene = CropData.get_seeds_scene(item_data.name)
	
	var instanced_scene: Node = scene.instantiate() # Instantiate ...
	
	grown = true   # Set Grow ...
	
	instanced_scene.global_position = self.global_position   # Position ...
	var pickups_node: Node = get_parent().owner.find_child("PickUps") # Find Node ...
	pickups_node.add_child(instanced_scene) # Add Child ...
	Signalbus.delete_crop.emit(self.global_position) # Emit Delete Self ...
	get_parent().remove_child(self) # Also , Delete Self
	self.queue_free() 
	
	pass




func set_crop_data(_item_data):
	print_debug(" set_crop_data in seed_to_crop")
	# Set from farm no matter what, Farm grabs at CropData.item_data_array....
	item_data = _item_data
	stages_set(item_data) # Grabbed from item_data
	# Setting Vars from CropData...
	check_for_crop_data()

	# Do math for days planted .... # Also ...advance days_watered ...
	check_if_watered()
	current_day = time_tracker.day # NOTE Always after check_if_watered
	#Grab animation NAME from Item Resource, Set....
	set_crop_animation()
	
	
func set_crop_animation():
	var animation_name: String = item_data.animation_resize_check()
	animation_player.play(animation_name)
	animation_player.pause()
	animation_player.seek(current_stage, true)
	print("End of @Ready , Current Stage ", " ", current_stage)
	print("")


func check_if_watered():
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


func check_for_crop_data():

	if CropData.crop_array: 
		print(" crop_array exists .... ")
		#  Get Crops Data from CropData

		# TEST 11/18 Should replace the array and all vars inside .... 
		#		crop_data_array = CropData.all_crops_array[-1]
		#		print(days_since_planted)

		days_watered = CropData.crop_array[-6]
		current_stage = CropData.crop_array[-5]
		days_since_planted = CropData.crop_array[-4]
		current_day = CropData.crop_array[-3]
		day_planted = CropData.crop_array[-2]
		watered = CropData.crop_array[-1]
		#		item_data = CropData.crop_array[-1] # Set at Exit, seperate

		print("After CropData Loop.... current_stage is"," ", current_stage)



		# TEST 11/18 
		#		CropData.all_crops_array.pop_back()



		# TEST Change...

		# Clear array after grabbing from it NOTE
		var array_size: int = 6 # NOTE Should reflect CropData.crop_array size
		while array_size != 0:
			CropData.crop_array.pop_back()
			array_size -= 1

		#Or Else ... Set DayPlanted
	else:
		# If no saved data, This must be its first day planted....
		day_planted = time_tracker.day


		# NOTE Unused ???
func transfer_array(array_from: Array, array_to: Array)-> Array:
	
	for i in array_from:
		array_to[i] = array_from[i]
	
	
	return array_to
	

func stages_set(_item_data):
	
	stage_one = _item_data.stage_one
	stage_two = _item_data.stage_two
	stage_three = _item_data.stage_three
	stage_four = _item_data.stage_four
	stage_five = _item_data.stage_five
	stage_six = _item_data.stage_six
	stage_seven = _item_data.stage_seven
	last_stage = _item_data.last_stage


func _on_watered(mos_pos):
	
	var parent: Node   = get_parent()
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
#		last_stage_process()
		new_last_stage_process()
	

func last_stage_process():
	print("last_stage_process called ")
	grown = true
	# Change to lowercase
	var lowercase_item_name = item_data.name.to_lower()
	# Delete word "Seed" from item name....Space before the word "seed" aswell ...
	var item_name: String = lowercase_item_name.replacen(" seed","")
	print_debug(item_name)
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if file_name.containsn(item_name):
			# Combine Directory Path with File Path for full path...
			var full_path: String = dir_path + file_name
			# Load, Instantiate
			var crop_scene: PackedScene = load(full_path)
			var instanced_scene: Node   = crop_scene.instantiate()
			# Position
			instanced_scene.global_position = self.global_position
			var pickups_node: Node = get_parent().owner.find_child("PickUps")
			pickups_node.add_child(instanced_scene)
			# NOTE Changed on 10/13... Unindented by one
			# Set grown to true so we dont send data to CropData
			Signalbus.delete_crop.emit(self.global_position)
			get_parent().remove_child(self)
			self.queue_free()
		#------ END IF STATEMENT ------
		# Loop through untill you cant ...
		file_name = dir.get_next()
	


# Exit Tree //////////////////
func _exit_tree() -> void:
	# Send Data if Grown not true ...
	if not grown:
		
#		CropData.all_crops_array.append(crop_data_array)
		
		
		# Set current Stage 
		print_debug("EXIT TREE Current Stage is ... ", " ", current_stage)
#		print(crop_data_array)
#		print(" ")
		
#		item_data.current_stage = current_stage
		
		CropData.crop_array.append(days_watered)
		CropData.crop_array.append(current_stage)
		CropData.crop_array.append(days_since_planted)
		CropData.crop_array.append(current_day)
		CropData.crop_array.append(day_planted)
		CropData.crop_array.append(watered)
		
		# Farm.gd will be garbbing this later ...
		CropData.item_data_array.append(item_data)
		
		#print_debug("Exiting Tree")
		#print("Appending CropData ....")
		
	else: # Maybe check for last stage 
		print(" No CropData Update  ")
		return


# ------- WARNING ------- Tool........ 
#func _process(delta: float) -> void:
#if Engine.is_editor_hint():
#
##self.frame = current_stage
#animation_player.seek(current_stage, false) 
##pass
## Code to execute in editor.
