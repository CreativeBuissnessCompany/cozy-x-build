extends ColorRect

@onready var tween: Tween = create_tween().set_ease(Tween.EaseType.EASE_OUT_IN).set_trans(Tween.TRANS_BACK)
@export var colors: Array[Color]



func _ready() -> void:
	# Colors
	var chosen_color: Color = colors.pick_random()
	print(chosen_color)
	self.color = chosen_color
	
	# Tweens, Shrink and grow circle ....
	tween.tween_property(self.material,"shader_parameter/circle_size", 0.0, 0.8)
	await tween.tween_property(self.material,"shader_parameter/circle_size", 1.05, 0.3).set_delay(0.3).finished

	
	self.queue_free()
	