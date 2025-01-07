
class_name Currency
extends Node2D

@export var currency_held: int:
	set(value):
		if value <= 0:
			value = 0
		currency_held = value
		Signalbus.currency.emit(currency_held)
#  Commented out on 01/04 ... NOTE 
#	get:
#		Signalbus.currency.emit(currency_held)
#		return currency_held
		
		



#                                                 Script Start...


func lose_currency(amount: int):
	currency_held -= amount
	

# Does both Gain and Loss by letting amount be negative ... Coming from UseHandlerComponent... Item Effects
func change_currency(amount: int):
#	print("gain currency happening ")
	currency_held += amount