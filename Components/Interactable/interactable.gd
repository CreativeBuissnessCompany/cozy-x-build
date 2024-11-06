# interactable.gd
class_name Interactable
extends Node2D


# Variables  
var player:Player


@onready var area_2d: Area2D = $Area2D




# Script_Start
func _ready() -> void:
	
	pass



func _unhandled_input(_event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("interact"):
		if player != null:
			if self.area_2d.overlaps_body(player):
				print_debug("Interact")
			else:
				return
	
		#print("No interact")


func _on_area_2d_body_entered(body: Node2D) -> void:
	player = body
