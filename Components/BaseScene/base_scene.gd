class_name BaseScene extends Node2D


@onready var universe: Node = $"."

@onready var player: Player = self.get_parent().find_child("Player")
@onready var entrance_markers: Node2D = $EntranceMarkers

func _ready() -> void:
	# If scenemanager has player...
	#if scene_manager.player:
		# And If this script's player exists, Q-free this one
		#if player:
			#player.queue_free()
		# Grab SceneManager player, Set it here
		#player = scene_manager.player
		#get_parent().add_child(player)
	#print("BaseScene: player" + str(player))
	print("BaseScene: Ready")
	print("BaseScene: player var in ready" + str(player))
	position_player()




func position_player() -> void:
	for entrance in entrance_markers.get_children():
		if entrance is Marker2D and entrance.name == "any":
			player.global_position = entrance.global_position
			self.get_parent().call_deferred("move_child", player, -1)
			#get_parent().move_child(player,-1)
			print(" BaseScene: func position_player")
