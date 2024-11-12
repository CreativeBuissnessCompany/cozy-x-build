extends PanelContainer
class_name ItemSlot


@onready var texture_rect: TextureRect = %TextureRect
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
# Where is this being sent to?
signal on_item_button_pressed( animated_sprite_2d, item_resource: Item )

# Store Item, Being set in Inevtory UI
var item_resource: Item
# Arrow
@export var arrow_scene: PackedScene
var arrow_instance: Node2D




# Script_Start

func _ready() -> void:
	self.mouse_entered.connect(on_mouse_entered)
	self.mouse_exited.connect(on_mouse_exited)



func display_arrow() -> void:
	arrow_instance = arrow_scene.instantiate()
	#arrow_instance.position.x = 16
	add_child(arrow_instance)
	pass






func on_mouse_entered():
	# Animated Arrow Highlighter
	display_arrow()
	


func on_mouse_exited():
	# Destroy Arrow ...
	arrow_instance.queue_free()
	#print(" Mouse Exited Slot ")
	


func set_item(item):
	item_resource = item
	display(item_resource)


func display(item:Item):
	
	texture_rect.texture = item.sprite_frame.get_frame_texture("default", 0)
	

# Inventory ...
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# For UI Purposes
			on_item_button_pressed.emit( animated_sprite_2d, item_resource, self.global_position )
			# Sent to farm ...
			Signalbus.item_clicked.emit(item_resource)
			#print(" Item Slot Knows You Clicked....")
