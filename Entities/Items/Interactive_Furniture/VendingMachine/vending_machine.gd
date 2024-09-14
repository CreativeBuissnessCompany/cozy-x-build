# vending_machine.gd
extends Interactable


# @Export
@export var vending_inventory: Inventory

# Signals
signal vending_machine_ui

# Variables
@onready var player: Player = %Player








func _ready() -> void:
	pass


func _unhandled_key_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("interact"):
		if self.area_2d.overlaps_body(player):
			print("Player Vending")
			
			# Goes to UIRoot.gd in Universe.TSCN
			vending_machine_ui.emit(vending_inventory)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == Player:
		player = body
	
