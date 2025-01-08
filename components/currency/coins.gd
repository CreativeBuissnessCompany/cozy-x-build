extends Sprite2D


func _ready() -> void:
	Signalbus.currency.connect(on_currency_change)



func on_currency_change(_amount: int):
	self.visible = false
	await get_tree().create_timer(0.70).timeout
#	await get_tree().process_frame # WARNING hacky ....... 
	self.visible = true
