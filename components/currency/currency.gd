
class_name Currency
extends Node2D

@export var currency_held: int



#                                                 Script Start...


func lose_currency(amount: int):
	currency_held -= amount


func gain_currency(amount: int):
	currency_held += amount