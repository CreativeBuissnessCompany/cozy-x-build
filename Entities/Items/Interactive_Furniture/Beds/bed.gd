extends StaticBody2D

@onready var dialog_box: ColorRect = %DialogBox
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@export var jingle: AudioStreamMP3
var player : Player





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
	
	# Play Jingle ....
	Signalbus.sfx.emit(jingle)
	
	# Disable Collisions so player can get in bed...
	collision_shape_2d.disabled = true
	# Move player under sheets?
	player.z_index = 1
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(player,"position",Vector2(95,-15),0.30)
	#player.position = Vector2(95.00,-15.00)
	player.set_physics_process(false)
	# Timer
	await get_tree().create_timer(1).timeout
	# Outta Bed
	player.z_index = 0
	var tween2: Tween = get_tree().create_tween()
	tween2.tween_property(player,"position",Vector2(50, 0),0.30)
	collision_shape_2d.disabled = false
	player.set_physics_process(true)
	
	pass # Replace with function body.


func _on_no_pressed() -> void:
	dialog_box.hide()
	pass # Replace with function body.
