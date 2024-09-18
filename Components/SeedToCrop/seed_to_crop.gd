# seed_to_crop.gd
class_name CropToSeed extends Sprite2D

@export var item_data: Item

var current_day: int 
#var day_planted: int
#var days_since_planted: int 


#var crop_info: Array = []

var crop_dict: Dictionary = {
	"day planted": 0,
	"days since planted": 0
}




func _ready() -> void:
	# Set Texture
	self.texture = item_data.icon
	
	# Setting Vars ...
	if get_parent().crops:
		# Get Crops from parent
		var stored_data: Dictionary = get_parent().crops[0]
		# Set
		crop_dict["day planted"] = stored_data["day planted"]
		crop_dict["days since planted"] = stored_data["days since planted"]
		
		#print("Stored Data:day planted %s" % crop_dict["day planted"])
		#print("Stored Data:days since planted %s" % crop_dict["days since planted"])
		
		# Pop
		get_parent().crops.pop_front()
		
		
	#Or Else Get crops From Self
	else:
		# Current day 
		crop_dict["day planted"] = time_tracker.day
		print("Vars from self")
		
	
	
	if time_tracker.day > crop_dict["day planted"]:
		print("Current day bigger than day planted")
		if crop_dict["days since planted"] < time_tracker.day:
			crop_dict["days since planted"] += 1
			print(crop_dict["days since planted"])
	
	
	
	

func _exit_tree() -> void:
	# Send
	get_parent().crops.append(crop_dict)
	print("Sent To Crop Layer")
	pass
