extends StaticBody2D

var player : Player
@onready var dialog_box: ColorRect = %DialogBox
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D



func _unhandled_key_input(_event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("interact"):
		if player is Player:
			dialog_box.show()
		





func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body is Player:
		player = body
		


func _on_yes_pressed() -> void:
	time_tracker.day += 1
	dialog_box.hide()
	print("pressed")
	
	# Disable Collisions so player can get in bed...
	collision_shape_2d.disabled = true
	# Move player under sheets?
	player.z_index = 1
	player.global_position += Vector2(50.0,-20.0)
	# Timer
	await get_tree().create_timer(3).timeout
	# Outta Bed
	player.z_index = 0
	player.global_position += Vector2(-50.0,20.0)
	
	pass # Replace with function body.


func _on_no_pressed() -> void:
	dialog_box.hide()
	pass # Replace with function body.
