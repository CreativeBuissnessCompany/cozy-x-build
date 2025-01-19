extends AnimatedSprite2D




func _ready() -> void:
	var parent: PickupComp = get_parent()
	self.sprite_frames = parent.item.inven_spriteframe
#	self.scale = Vector2(.9,.9)
#	position.x += 150
