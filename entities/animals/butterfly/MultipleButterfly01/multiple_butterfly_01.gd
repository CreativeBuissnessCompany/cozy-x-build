extends Node2D






func _ready() -> void:
	
	
	# Offset Animations 
	var children: Array = get_children()
	for i in children: # i is AnimatedSprite
		var ani_offset : float = randf_range(0,1)
		i.frame_progress = ani_offset
		i.play()
		
		var animation_player: AnimationPlayer = i.get_child(0)
		animation_player.seek(ani_offset + randf_range(0,1))
		animation_player.play()
		
		