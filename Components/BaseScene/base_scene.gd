class_name BaseScene extends Node2D

# @onready ...
@onready var entrance_markers: Node2D = $EntranceMarkers





func _ready() -> void:
	# Tell everyone you are ready..    
	Signalbus.location_loaded.emit(entrance_markers)
		   
	#print_orphan_nodes()
	print("BaseScene: Ready")
