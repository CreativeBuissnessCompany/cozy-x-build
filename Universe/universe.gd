# Universe.gd
extends Node

@onready var player: Player = %Player



func _ready() -> void:
	# Set player info at Scene_Manager
	
	print("Universe: Ready")
	print("Universe: Setting Player In SceneManager")
	print("Universe:" + str(scene_manager.player))
