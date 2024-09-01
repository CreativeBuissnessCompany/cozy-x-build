extends PanelContainer



@onready var texture_rect: TextureRect = %TextureRect





func display(item:Item):
	texture_rect.texture = item.icon

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print_debug("Item Click Worked")
