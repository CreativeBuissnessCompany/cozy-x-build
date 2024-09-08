class_name BaseScene extends Node2D


@onready var player: Player = $Player
@onready var entrance_markers: Node2D = $EntranceMarkers

func _ready() -> void:
	if scene_manager.player:
		print("scene_manager.player exists...")
		if player:
			player.queue_free()
			
		player = scene_manager.player
		add_child(player)
	print("About To Position Player")
	position_player()
	



func position_player() -> void:
	for entrance in entrance_markers.get_children():
		if entrance is Marker2D and entrance.name == "any":
			player.global_position = entrance.global_position
			print("Marker Worked")
