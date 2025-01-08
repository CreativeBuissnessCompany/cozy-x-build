class_name UseHandlerComponent
extends Node




func _ready() -> void:
	Signalbus.use_item.connect(_on_use)
	
	# Emitted signal from ...... Use button ? From inventory_ui.gd  ??
func _on_use(item: Item):
	# Check if TOOL
	if item.item_type == Item.ITEM_TYPE.TOOL:
		print("Using the Tool known as....." + str(item.name))
		tool_please(item)
	elif item.item_type == Item.ITEM_TYPE.SEED:
		Signalbus.seed_selected.emit(item)
		print("Seed")
	else:
		for i in range(item.use_components.size()):
			print(" use_components loop,Item is" + item.name)
			print()
			match item.use_components[i].use_type:
				
				UseComponent.USE_TYPE.MONEY:
#					print("Money ..." + str(item.use_components[i].amount))
					money_please(item, i)
				UseComponent.USE_TYPE.HEALTH:
					print("Health Gained..." + str(item.use_components[i].amount))

		

			
# When you try to use a tool in inventory ... 
func tool_please(item: Item):
	var input_action = InputEventAction.new()
	
	match item.name: # Double check the input even acti0on names NOTE 
		"Hoe":
#			print("Name Match...Till")
			input_action.action = "toggle_dirt"
		"Watering Can":
#			print("Name Match... Water")
			input_action.action = "toggle_water"
			
	input_faker(input_action)
	

	
# For use with tools, Simulates button press ....
func input_faker(new_input_action: InputEventAction):
#	print("input_faker(), Fake Press ...")
	new_input_action.pressed = true
#	print(new_input_action)
	
# Unpause the game here? 
	get_tree().paused = false
	Input.parse_input_event(new_input_action)
	await get_tree().process_frame
	get_tree().paused = true

	
# For losing or gaining money please ...
func money_please(item: Item,  i: int):
	var amount: int = item.use_components[i].amount
	
#	print("Money change amount $" + str(amount))
	
	var player: Player = get_parent()
	var currency_node: Currency = player.currency_node

#	print("currency held BEFORE item use = $" + str(currency_node.currency_held))
	currency_node.change_currency(amount)
#	print("currency held AFTER item use = $" + str(currency_node.currency_held))
	
	player.inventory.remove_item(item)