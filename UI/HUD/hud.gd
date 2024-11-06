extends Control


@onready var day_node: RichTextLabel = %Day



func _ready() -> void:
	Signalbus.day_change.connect(on_day_change)



func on_day_change(day):
	day_node.text = "Day: %s" % day


func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_released("ui_inventory"):
		self.visible = !self.visible
	
