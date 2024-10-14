# seed_to_crop.gd
class_name CropToSeed extends AnimatedSprite2D

# Variables

# Where we get the texture and such for seed to crop 
@export var item_data: Item:
	set(value):
		item_data = value
		self.sprite_frames = item_data.sprite_frame

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
# Path for Directory of "from_seed" ...
var dir_path: String = "res://entities/items/consumables/from_seed_pickups/"
# Directory for Fully grown versions of seeds....Fruit,Veggie....
var dir = DirAccess.open(dir_path)

var grown: bool = false







# Script_Start
func _ready() -> void:
	print(" Grown Status at Ready in SeedToCrop....")
	print(grown)
	
	
	# From Farm...
	Signalbus.connect("watered", _on_watered)
	
	# Setting Vars from GameData...
	if GameData.crop_array:
		#print("GameData CropArray Exists....")
		#print(GameData.crop_array)
		 #Get Crops Data from GameData
		 #Set
		days_watered = GameData.crop_array[-6]
		current_day = GameData.crop_array[-5]
		day_planted = GameData.crop_array[-4]
		current_frame = GameData.crop_array[-3]
		watered = GameData.crop_array[-2]
		item_data = GameData.crop_array[-1]
		
		# Pop
		GameData.crop_array.pop_back()
		GameData.crop_array.pop_back()
		GameData.crop_array.pop_back()
		GameData.crop_array.pop_back()
		GameData.crop_array.pop_back()
		GameData.crop_array.pop_back()
		
		
	#Or Else ... Set DayPlanted, W
	else:
		day_planted = time_tracker.day
	# Also ...advance DaysWatered ...
	# Do math for days planted ....
	if watered == true:
		if time_tracker.day > day_planted:
			days_watered += 1
			days_since_planted = time_tracker.day - day_planted
	
	# NOTE NOTE Might Delete for SpriteFrames
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
	
	# NOTE New ...
	# New, Try to set spriteframes...
	self.sprite_frames = item_data.sprite_frame
	#self.offset = Vector2( 0 , -12 )



func _on_watered(mos_pos):
	
	var parent = get_parent()
	var tile_pos_local = Utility.convert_mos_local(parent,global_position )
	
	if mos_pos == tile_pos_local:
		watered = true


func advance_stage(_days_since_planted):
	
	match _days_since_planted:
		
		stage_one:
			current_stage = stage_one
			self.frame = stage_one
			#print("Stage One")
		
		stage_two:
			current_stage = stage_two
			#animation_player.seek(1.00, true)
			self.frame = stage_two
			#print("Stage Two")
			
		stage_three:
			current_stage = stage_three
			#animation_player.seek(2.00,true)
			self.frame = stage_three
			#print("Stage Three")
			
		stage_four:
			current_stage = stage_four
			#animation_player.seek(3.00,true)
			self.frame = stage_four
			#print("Stage Four")
			
		stage_five:
			current_stage = stage_five
			#animation_player.seek(4.00,true)
			self.frame = stage_five
			#print("Stage Five")
			
		stage_six:
			current_stage = stage_six
			#animation_player.seek(5.00,true)
			self.frame = stage_six
			#print("Stage Six")
			
		stage_seven:
			current_stage = stage_seven
			#animation_player.seek(6.00,true)
			self.frame = stage_seven
			#print("Stage Seven")
			
	# Last Stage ...
	if current_stage == last_stage:
		print("Last Stage")
		#print(item_data.name)
		
		# Delete word "Seed" from item name....
		# NOTE Space BEFORE the word seed is NEEDED
		print(item_data.name)
		var item_name = item_data.name.replacen(" seed","")
		print(item_name)
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.containsn(item_name):
				#print(file_name)
				print( "They Match!")
				# Combine Directory Path with File Path for full path...
				#print(dir_path + file_name)
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
				grown = true
				Signalbus.delete_crop.emit(self.global_position)
				get_parent().remove_child(self)
				self.queue_free()
			file_name = dir.get_next()
		#print(dir_path)
		#print(file_name)
		
	
	animation_player.pause()
	current_frame = animation_player.current_animation_position
	
	


func _exit_tree() -> void:
	# Send Data if Grown not true ...
	if not grown:
		GameData.crop_array.append(days_watered)
		GameData.crop_array.append(current_day)
		GameData.crop_array.append(day_planted)
		GameData.crop_array.append(current_frame)
		GameData.crop_array.append(watered)
		GameData.crop_array.append(item_data)
		print(" Not Grown ")
