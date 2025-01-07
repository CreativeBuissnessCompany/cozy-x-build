extends AnimatedSprite2D






func _ready() -> void:
	Signalbus.currency.connect(on_currency_change)
	


func on_currency_change(_amount: int):
	print("on_currency_change in animated_coins")
	self.visible = true
	self.play("default")
	await animation_finished
	self.play_backwards("default")
	await animation_finished
	self.visible = false
	