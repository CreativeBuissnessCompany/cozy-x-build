extends RichTextLabel



func _ready() -> void:
	Signalbus.currency.connect(on_currency_change)





func on_currency_change(amount:int):
	print_debug("currency set")
	print(get_parent().name)
	var _text: String = str("$", amount)
	self.text = "[wave amp=30.0 freq=2.0 connected=0 center] %s [/wave]" % _text
	