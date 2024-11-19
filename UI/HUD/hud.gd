extends Control


@onready var day_node: RichTextLabel = %Day



func _ready() -> void:
	Signalbus.day_change.connect(on_day_change)
	Signalbus.ui_open.connect(on_ui_open)


#func _unhandled_input(event: InputEvent) -> void:
#	
#	if event.is_action_released("ui_inventory"):
#		show_hide()


	
func on_ui_open():
	show_hide()
	
	
func show_hide():
	self.visible = !self.visible


func on_day_change(day):
	day_node.text = "Day: %s" % day