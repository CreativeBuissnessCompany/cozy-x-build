# CropData 
extends Node


@export var database: Database



var crop_array: Array=[]:
	get:
		#print_rich("[center][color=orange]CropData.crop_array in Global [center][color=green]", "", crop_array)
		return crop_array


var item_data_array: Array = []


func _ready() -> void:
	pass
	
	
	
func get_seeds_scene(item_name: StringName)-> PackedScene:

	# Variable Declarations,WARNING StringName type NEEDED 

	var lowercase_item_name: StringName
	var spaceless_item_name: StringName
	var formatted_item_name: StringName
	var name_of_collection: StringName = "seeds"

	# String Formatting ...
	lowercase_item_name = item_name.to_lower() # From uppercase to Lowercase ...
	spaceless_item_name = lowercase_item_name.replace(" ", "_") # Replace Emptyspace with "_"
	formatted_item_name = spaceless_item_name.replace("seed","pickup") # Replace "seed" with "_pickup" ...


	# Find Resource using Collection & Resource Name ...
	var resource_int_id: int = database.get_int_id(name_of_collection, formatted_item_name)
	var scene: PackedScene = database.fetch_data(name_of_collection, resource_int_id)
	

	return scene


	