# GameData 
extends Node


var crop_array: Array=[]:
	set(value):
		crop_array = value
		#print_rich("[center][color]GameData.crop_array in Global ......[/center][/color]")
		#print(crop_array)
	
	get():
		#print_rich("[center][color=orange]GameData.crop_array in Global [center][color=green]", "", crop_array)
		return crop_array

#var crop_dict: Dictionary = {}
