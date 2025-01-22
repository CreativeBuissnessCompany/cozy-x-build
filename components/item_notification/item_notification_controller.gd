extends VBoxContainer

var item_notification_box_scene: PackedScene = preload("res://components/item_notification/item_notification_box.tscn")

var box_size: int

func _ready() -> void:
	Signalbus.item_picked_up.connect(_on_item_picked_up)
	
	



func _on_item_picked_up(item: Item):
	box_size = self.get_child_count()
	
	
	if box_size <= 3:
		add_box(item.inven_spriteframe, item.name)
	else:
		await get_tree().create_timer(1).timeout
		add_box(item.inven_spriteframe, item.name)



func add_box(_image, _name):
	var box: ItemNotificationBox = item_notification_box_scene.instantiate()
	add_child(box)
	self.move_child(%MarginContainer,-1)
	box.set_item_n_box_data(_image, _name)
