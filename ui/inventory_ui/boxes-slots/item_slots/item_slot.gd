extends PanelContainer
class_name ItemSlot


@onready var texture_rect: TextureRect = %TextureRect
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
# Where is this being sent to?
signal on_item_button_pressed( animated_sprite_2d, item_resource: Item )

# Store Item, Being set in Inevtory UI
var item_resource: Item

@export var arrow_scene: PackedScene
var instance: Node2D



# Script_Start

func _ready() -> void:
	self.mouse_entered.connect(on_mouse_entered)
	self.mouse_exited.connect(on_mouse_exited)


func on_mouse_entered():
	print(" Mouse Entered ItemSlot.gd ")
	instance = arrow_scene.instantiate()
	instance.position.x = 16
	add_child(instance)
	


func on_mouse_exited():
	instance.queue_free()
	print(" Mouse Exited Slot ")
	


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
			print(" Item Slot Knows You Clicked....")
		

#func item_check():
	#if item_resource.item_type == Item.ITEM_TYPE.SEED:
		#print("Wanna plant seeds")
	#pass
