
class_name Currency
extends Node2D

@export var currency_held: int:
	set(value):
		currency_held = value
		Signalbus.currency.emit(currency_held)
	get:
		Signalbus.currency.emit(currency_held)
		return currency_held
		
		



#                                                 Script Start...


func lose_currency(amount: int):
	currency_held -= amount
	


func gain_currency(amount: int):
	currency_held += amount