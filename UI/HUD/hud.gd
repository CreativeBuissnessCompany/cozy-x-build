extends Control


@onready var day_node: RichTextLabel = %Day
#@export var universe: Node2D

func _ready() -> void:
	modulate = Color(1,1,1,0)
	Signalbus.day_change.connect(on_day_change)
	Signalbus.ui_open.connect(on_ui_open)
#	Signalbus.currency.connect(on_currency_change)
	
	await get_tree().create_timer(1).timeout
	var fade_tween: Tween = get_tree().create_tween()
	fade_tween.set_ease(Tween.EASE_IN_OUT)
	fade_tween.tween_property(self, "modulate", Color(1,1,1,1), 1)
	
	


#                                               Custom Functions...
func on_ui_open():
	show_hide()
	
	
func show_hide():
	self.visible = !self.visible


func on_day_change(day:int):
	day_node.text = "Day: %s" % day
	