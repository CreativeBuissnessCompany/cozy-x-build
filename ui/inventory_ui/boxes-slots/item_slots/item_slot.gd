extends PanelContainer
class_name ItemSlot


@onready var texture_rect: TextureRect = %TextureRect
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

signal on_item_button_pressed(item_description, animated_sprite_2d)

#var item_info: Dictionary = {}
var item_description: String = ""

# Store Item, Being set in Inevtory UI
var item_resource: Item



func set_item(item):
	item_resource = item
	item_description = item.description
	display(item)


func display(item:Item):
	# NOTE NEW ...
	texture_rect.texture = item.sprite_frame.get_frame_texture("default", 0)
	
	#texture_rect.texture = item.icon

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#print("Item Click Worked")
			# for inventory_ui
			on_item_button_pressed.emit(item_description,animated_sprite_2d)
			# Test , Maybe to farm ...
			Signalbus.item_clicked.emit(item_resource)
			#item_check()
		

#func item_check():
	#if item_resource.item_type == Item.ITEM_TYPE.SEED:
		#print("Wanna plant seeds")
	#pass
