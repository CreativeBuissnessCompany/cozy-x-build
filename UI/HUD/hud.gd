extends Control


@onready var day_node: RichTextLabel = %Day
@onready var currency_label: RichTextLabel = %Currency
#@export var universe: Node2D

func _ready() -> void:
	modulate = Color(1,1,1,0)
	Signalbus.day_change.connect(on_day_change)
	Signalbus.ui_open.connect(on_ui_open)
	Signalbus.currency.connect(on_currency_change)
	
	await get_tree().create_timer(1).timeout
	var fade_tween = get_tree().create_tween()
	fade_tween.set_ease(Tween.EASE_IN_OUT)
	fade_tween.tween_property(self, "modulate", Color(1,1,1,1), 1)
#	visible = true
	
	



#func _unhandled_input(event: InputEvent) -> void:
#	
#	if event.is_action_released("ui_inventory"):
#		show_hide()


	
func on_ui_open():
	show_hide()
	
	
func show_hide():
	self.visible = !self.visible


func on_day_change(day:int):
	day_node.text = "Day: %s" % day
	
func on_currency_change(amount:int):
	print("currency set")
	print(amount)
	var text: String = str("$", amount)
	currency_label.text = "[wave amp=30.0 freq=2.0 connected=0] %s [/wave]" % text
	