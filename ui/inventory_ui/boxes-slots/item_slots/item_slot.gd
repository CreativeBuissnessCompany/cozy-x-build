extends PanelContainer
class_name ItemSlot


@onready var texture_rect: TextureRect = %TextureRect
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

signal on_item_button_pressed( animated_sprite_2d, item_resource: Item)


# Store Item, Being set in Inevtory UI
var item_resource: Item





# Script_Start
func set_item(item):
	item_resource = item
	display(item)


func display(item:Item):
	# NOTE NEW ...
	texture_rect.texture = item.sprite_frame.get_frame_texture("default", 0)
	
	#texture_rect.texture = item.icon

# Inventory ...
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			on_item_button_pressed.emit( animated_sprite_2d, item_resource )
			# Sent to farm ...
			Signalbus.item_clicked.emit(item_resource)
			
		

#func item_check():
	#if item_resource.item_type == Item.ITEM_TYPE.SEED:
		#print("Wanna plant seeds")
	#pass
