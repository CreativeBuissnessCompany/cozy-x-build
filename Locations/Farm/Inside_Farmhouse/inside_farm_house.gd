# inside_farm.gd ...
extends BaseScene

@export var camera_bounds: Vector4i	= Vector4i(-10000000,-10000000,10000000,10000000) 






func _enter_tree() -> void:
	super()
	GameData.camera_bounds = camera_bounds
	Signalbus.camera_limits.emit()


func _ready() -> void:
	super()
