extends AnimatedSprite2D




func _ready() -> void:
	var parent: PickupComp = get_parent()
	self.sprite_frames = parent.item.sprite_frame
#	self.scale = Vector2(.9,.9)
#	position.x += 150
