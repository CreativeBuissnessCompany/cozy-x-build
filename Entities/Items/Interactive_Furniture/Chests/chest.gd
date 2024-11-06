# chest.gd
extends Interactable


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D



func _ready() -> void:
	pass



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		#print("Player at chest")
		animated_sprite_2d.play("open")
		pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		#print("Player Leaving Chest")
		animated_sprite_2d.play_backwards("open")
		pass # Replace with function body.
