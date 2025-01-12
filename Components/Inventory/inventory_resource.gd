#                                         inventory_resource.gd
class_name InventoryResource
extends Resource


@export var _content:Array[Item] = []

# NOTE
signal inventory_changed # NOTE UNUSED



#                                  Script Start...
#                                                   Custom Functions...

## If we have the item already, Increment QTY ...
func add_item(item:Item):
	# Check size of Array ( Inventory[Item] ) ... If not empty ...
	if _content.size() != 0: 
		var count: int = _content.size()     # count is Eual to Size of array ...
		for i in _content: # Loop through array ...
			if i.name == item.name: # Check if item exists in Array by comparing the names ...
				i.qty += 1 # If we have one, Increment QTY ...
				break 
			else: # If not ...
				count -= 1  # Reduce the count by 1 and continue ...                  
				if count == 0: # If count is 0 , Just fucking add the Item ...
					_content.append(item)    
					break
	else: # Do this if the Inventory(_content) is empty ...
		_content.append(item)  # Just fucking add the Item ...

		
## Needs work ? Actually being used by VendingMachine....          Heads-Up...
func remove_item(item:Item):
	# TO DO Check Qty ...
	var _count: int = _content.size()
	if _count != 0:
		for i in _content:
			if i.name == item.name:
				if item.qty > 1:
					item.qty -= 1
				elif item.qty == 1:
					print("Deleteing ")
					_content.erase(item)
	



func get_items() -> Array[Item]:
	return _content
