class_name UseHandlerComponent
extends Node




func _ready() -> void:
	Signalbus.use_item.connect(_on_use)
	
	
func _on_use(item: Item):
	for i in range(item.use_components.size()):
		print(" use_components loop,Item is" + item.name)
		print()
		match item.use_components[i].use_type:
			
			UseComponent.USE_TYPE.MONEY:
				print("Money change..." + str(item.use_components[i].amount))
				var amount: int = item.use_components[i].amount
				money_please(amount)
			UseComponent.USE_TYPE.HEALTH:
				print("Health Gained..." + str(item.use_components[i].amount))
		

		
func money_please(amount: int):
	print("Money change amount $" + str(amount))
	
	var player: Player = get_parent()
	var currency_node: Currency = player.currency_node

	print("currency held BEFORE item use = $" + str(currency_node.currency_held))
	currency_node.change_currency(amount)
	
	print("currency held AFTER item use = $" + str(currency_node.currency_held))