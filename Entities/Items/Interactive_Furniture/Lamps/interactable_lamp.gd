extends Interactable


@onready var lamp: AnimatedSprite2D = $Lamp
@onready var light: PointLight2D = $Lamp/OmniLight3D


func _on_area_2d_body_entered(_body: Node2D) -> void:
	lamp.play("default")
	light.visible = !light.visible
	print("Liight")
	pass # Replace with function body.
