extends PanelContainer
class_name ItemSlotVending


@onready var texture_rect: TextureRect = %TextureRect
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D


signal on_item_button_pressed(item_name,item_description, animated_sprite_2d)


#var item_info: Dictionary = {}
var item_name: String = ""
var item_description: String = ""
var item_price: int = 0




func display(item:Item):
	texture_rect.texture = item.sprite_frame.get_frame_texture("default", 0)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#print_debug("Item Click Worked")
			on_item_button_pressed.emit(item_name,item_description,item_price,animated_sprite_2d)
			
		
