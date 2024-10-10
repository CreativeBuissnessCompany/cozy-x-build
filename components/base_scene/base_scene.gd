class_name BaseScene extends Node2D

# @onready ...
@onready var entrance_markers: Node2D = %EntranceMarkers





func _ready() -> void:
	
	
	
	
	# Tell everyone(Universe.gd) you are ready..    
	Signalbus.location_loaded.emit(entrance_markers)
	
	#print_orphan_nodes()
	#print("BaseScene: Ready")


func _enter_tree() -> void:
	# A sticky way to run after inital load only...
	if entrance_markers:
		# Tell everyone(Universe.gd) you are ready..    
		Signalbus.location_loaded.emit(entrance_markers)
	
	pass
