extends ColorRect

@onready var vbox: VBoxContainer = %VBoxContainer
@onready var controls_label: Label = %ControlsLabel
var _playing: bool = false
var original_x_coords: float = 82.0

func _ready() -> void:
	_on_mouse_exited()
	
	await get_tree().create_timer(2).timeout
	_on_mouse_entered()
	await get_tree().create_timer(3).timeout
	_on_mouse_exited()


func _on_mouse_entered() -> void:
	await Engine.get_main_loop().process_frame
	if _playing == false:
		_playing = true
		# Move Controls Label
		var tween_label: Tween = get_tree().create_tween()
		tween_label.set_ease(Tween.EASE_OUT)
		tween_label.tween_property(controls_label, "position", Vector2(571, 238.26), 0.4)
	
		vbox.custom_minimum_size.x = original_x_coords
		var tween_1: Tween = get_tree().create_tween()
		tween_1.set_ease(Tween.EASE_IN_OUT)
		tween_1.tween_property(self, "self_modulate", Color(1,1,1,1), 1)
		await tween_1.finished 
		_playing = false
		
		
		pass # Replace with function body.
	else:
		print("Still playing, cant mouse enter")


func _on_mouse_exited() -> void:
	await Engine.get_main_loop().process_frame
	if _playing == false:
		_playing = true
		# Move Controls Label
		var tween_label: Tween = get_tree().create_tween()
		tween_label.set_ease(Tween.EASE_IN_OUT)
		tween_label.tween_property(controls_label, "position", Vector2(571, 340), 0.8)
	
		vbox.custom_minimum_size.x = 0
		var tween_1: Tween = get_tree().create_tween()
		tween_1.set_ease(Tween.EASE_IN_OUT)
		
		tween_1.tween_property(self, "self_modulate", Color(1,1,1, 0), 1)
		await tween_1.finished
		_playing = false
	else:
		print("Still playing, cant mouse exit")
