class_name ObjectsWithUI extends Node2D

var the_objects_with_ui: Array

func _ready() -> void:
	
	the_objects_with_ui = get_children()
	#print(" objects_with_ui: %s" % the_objects_with_ui )
	pass
	
