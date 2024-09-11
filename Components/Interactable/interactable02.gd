# interactable.gd
extends Interactable



var player:Player





func _ready() -> void:
	
	
	pass


func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("interact"):
		if self.area_2d.overlaps_body(player):
			print("interact")
	
	print("N o interact")
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	player = body
	pass # Replace with function body.
