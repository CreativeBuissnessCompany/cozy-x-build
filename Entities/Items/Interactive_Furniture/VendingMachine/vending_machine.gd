# vending_machine.gd
extends Interactable

# Variables 

var player:Player

signal vending_machine_ui



func _ready() -> void:
	
	pass


func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("interact"):
		if self.area_2d.overlaps_body(player):
			print("vending")
			emit_signal("vending_machine_ui")
	
	
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	player = body
	pass # Replace with function body.
