#@tool                                      seed_to_crop.gd 
class_name SeedToCrop extends AnimatedSprite2D


# Variables

# Where we get the texture and such for seed to crop 
@export var item_data: Item:
	set(value):
		item_data = value
		# Used for when farm.gd sets data ...
		self.sprite_frames = item_data.sprite_frame


@onready var animation_player: AnimationPlayer = %AnimationPlayer

# Set Stages .. NOTE How can you get rid of this shit ? ?
var stage_one: int
var stage_two: int
var stage_three: int
var stage_four: int
var stage_five: int
var stage_six: int
var stage_seven: int
var last_stage: int

@export var current_stage: int # Tweak to better use for testing 
var day_planted: int
var days_since_planted: int = 0
var current_day: int 
var watered: bool = false
var days_watered: int = 0
var grown: bool = false

var ready_to_harvest: bool = false





# Script_Start
func _ready() -> void:
	
	# From farm.gd...
	Signalbus.connect("watered", _on_watered)
	Signalbus.harvest.connect(_on_harvest)
	
	

#                                  Custom Functions 




## If parent isnt null, does local_to_map(self.pos) to compare with _mos_pos ...
## If match,And ready_to_harvest is equal to true... Do new_last_stage_process() ...
func _on_harvest(_mos_pos) -> void:
	
	var parent: TileMapLayer = get_parent()
	var seed_pos
	
	if parent != null:
		seed_pos = parent.local_to_map(self.position)
	else:
		return
	
	if seed_pos == _mos_pos:
		if ready_to_harvest == true:
			print("Player is trying to Harvest ...")
			new_last_stage_process()

## Triggered in on_harvest() above,Does CropData.get_seeds_scene(item_data.name), 
## Instantiates PackedScene,Sets grown to true, Positiones,Does add_child to pickups_node, Finally ...
## Signalbus.delete_crop.emit(self.global_position), parent.remove_child(self),And self.queue_free() ...
func new_last_stage_process():
	var scene: PackedScene = CropData.get_seeds_scene(item_data.name)
	var instanced_scene: Node = scene.instantiate() # Instantiate ...
	grown = true   # Set Grown ...
	
	instanced_scene.global_position = self.global_position   # Position ...
	var pickups_node: Node = get_parent().owner.find_child("PickUps") # Find Node ...
	pickups_node.add_child(instanced_scene) # Add Child ...
	Signalbus.delete_crop.emit(self.global_position) # Emit Delete Self ...
	get_parent().remove_child(self) # Also , Delete Self
	self.queue_free() 
	
	pass


## check_if_watered(), Set current_day = TimeTracker.day, 
## advance_stage(days_since_planted), set_crop_animation()
func _on_next_day():
	
	check_if_watered()
	current_day = time_tracker.day # NOTE Always after check_if_watered
	advance_stage(days_watered)
	print("days_watered")
	print_debug(days_watered)
	set_crop_animation()
	# Receive signal
	pass


## Sets item_data from farm.gd plant_seed(seed_selected), stages_set(item_data), 
## check_if_watered(),current_day = TimeTracker.day, 
## advance_stage(days_since_planted), set_crop_animation()
func set_crop_data(_item_data):
#	print_debug(" set_crop_data in seed_to_crop")
	item_data = _item_data
	day_planted = time_tracker.day
	stages_set(item_data) # Grabbed from item_data
#	check_for_crop_data() # Setting Vars from CropData... NOTE Delete ????
	# Do math for days planted .... # Also ...advance days_watered ...
	check_if_watered()
	current_day = time_tracker.day # NOTE Always after check_if_watered
	advance_stage(days_watered)
	set_crop_animation() # Grab animation NAME from Item Resource, Set....
	
## Checks item_data for animation to use... i.e. "default" or "resize_16_tall" in Item ...	
func set_crop_animation():
	var animation_name: String = item_data.animation_resize_check()
	animation_player.play(animation_name)
	animation_player.pause()
	animation_player.seek(current_stage, true)


## if watered is True,time_tracker.day > day_planted AND time_tracker.day> current_day ...
## days_watered += 1, set watered = false ...
func check_if_watered():
	if watered == true:
		if time_tracker.day > day_planted and time_tracker.day > current_day:

			days_watered += 1
			days_since_planted = time_tracker.day - day_planted
			watered = false

## NOTE Delete ? ? ?
## Look at CropData.crop_array for info
func check_for_crop_data():

	if CropData.crop_array: 
		print(" crop_array exists .... ") #  Get Crops Data from CropData
		days_watered = CropData.crop_array[-6]
		current_stage = CropData.crop_array[-5]
		days_since_planted = CropData.crop_array[-4]
		current_day = CropData.crop_array[-3]
		day_planted = CropData.crop_array[-2]
		watered = CropData.crop_array[-1]
		#		item_data = CropData.crop_array[-1] # Set at Exit, seperate

		print("After CropData Loop.... current_stage is"," ", current_stage)

		# Clear array after grabbing from it 
		var array_size: int = 6 # NOTE Should reflect CropData.crop_array size
		while array_size != 0:
			CropData.crop_array.pop_back()
			array_size -= 1
		
	else: #Or Else ... Set DayPlanted
		# If no saved data, This must be its first day planted....
		day_planted = time_tracker.day

## Sets stages from _item_data ... Used by set_crop_data() Above ...
func stages_set(_item_data):
	
	stage_one = _item_data.stage_one
	stage_two = _item_data.stage_two
	stage_three = _item_data.stage_three
	stage_four = _item_data.stage_four
	stage_five = _item_data.stage_five
	stage_six = _item_data.stage_six
	stage_seven = _item_data.stage_seven
	last_stage = _item_data.last_stage

## Triggered by SignalBus.watered ... Matches mos_pos to tile_pos_local ...
## NOTE Maybe check if its actually matching the tile itself ...
func _on_watered(mos_pos):
	
	var parent: Node   = get_parent()
	var tile_pos_local = Utility.convert_mos_local(parent,global_position )
	
	if mos_pos == tile_pos_local:
		print("Watered Successfully")
		watered = true

## Matches the days_watered var from check_if_watered() above to stage_one, stage_two, Etc ...
## NOTE Changed from _days_since_planted to _days_watered ... 11/29
func advance_stage(_days_watered):
	
	match _days_watered:
		
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
		print("Seed to crop is setting ready_to_harvest = true ....")
		ready_to_harvest = true
		# Instance the butterflies to let player know Crop Is Ready ...
		var butterflies_scene: PackedScene = load("res://entities/animals/butterfly/MultipleButterfly01/multiple_butterfly_01.tscn") 
		var butterflies_instance: Node2D = butterflies_scene.instantiate()
		add_child(butterflies_instance)

# NOTE                                      Exit Tree 
# CropData.crop_array.append(self)
func _exit_tree() -> void:
	# Send Data if Grown not true ...
	if not grown:
		
		CropData.crop_array.append(self)
		
		print_debug("EXIT TREE Current Stage is ... ", " ", current_stage)
		
	else: # Maybe check for last stage 
		print(" No CropData Update  ")
		print()
		print(" Grown")
		print()
		return
