extends StaticBody2D

@onready var dialog_box: ColorRect = %DialogBox
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@export var jingle: AudioStreamMP3
var player : Player





func _ready() -> void:
	
		
	
	pass




func _unhandled_key_input(_event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("interact"):
		if player is Player:
			dialog_box.show()
		
# Sets player if they walk into Area2D
func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body is Player:
		player = body


#                                                      Custom Functions...	
	





func move_player():
	var time: float = 0.30
	var original_position: Vector2 = player.global_position
	collision_shape_2d.disabled = true             # Disable Collisions so player can get in bed...
	player.z_index = 1                             # Move player under sheets Z-Index ...
	# Call func
	Utility.move_thing(player, collision_shape_2d.global_position, time)
	player.set_physics_process(false)

	await get_tree().create_timer(1).timeout       # Timer
	# Outta Bed
	player.z_index = 0
	Utility.move_thing(player, original_position, time)
	collision_shape_2d.disabled = false
	player.set_physics_process(true)
	
	
	
	
	


## Increment time_tracker.day by 1, Hide DialogBox, Emit sfx signal(jingle), move_player() 
func _on_yes_pressed() -> void:
	time_tracker.day += 1
	dialog_box.hide()
	
	Signalbus.sfx.emit(jingle)         # Play Jingle ....

	move_player()
	pass # Replace with function body.


func _on_no_pressed() -> void:
	dialog_box.hide()
	pass # Replace with function body.

	