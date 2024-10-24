extends RefCounted
class_name TransferItemCommand




func transfer_item( item: Item, inventory_a: Inventory,inventory_b: Inventory) -> void:
	# find item in inventory a
	for item_a in inventory_a.get_items():
		print(item_a)
		pass
	# remove it from a
	
	# add item to b 
	
	pass
