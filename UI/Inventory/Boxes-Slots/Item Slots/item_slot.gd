extends PanelContainer
class_name ItemSlot


@onready var texture_rect: TextureRect = %TextureRect
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D


signal on_item_button_pressed(item_description, animated_sprite_2d)


#var item_info: Dictionary = {}
var item_description: String = ""



func display(item:Item):
	texture_rect.texture = item.icon

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print_debug("Item Click Worked")
			on_item_button_pressed.emit(item_description,animated_sprite_2d)
			
		
