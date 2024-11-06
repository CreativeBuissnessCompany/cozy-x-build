extends ColorRect



func _on_mouse_entered() -> void:
	var tween_1 = get_tree().create_tween()
	tween_1.tween_property(self, "self_modulate", Color(1,1,1,1), 1)
	#print("Mouse Entered!")
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	var tween_1 = get_tree().create_tween()
	tween_1.tween_property(self, "self_modulate", Color(1,1,1, 0), 1)
	pass # Replace with function body.
