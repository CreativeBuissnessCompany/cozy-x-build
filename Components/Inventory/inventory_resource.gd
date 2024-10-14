# inventory_resource.gd
class_name Inventory
extends Resource


@export var _content:Array[Item] = []


func add_item(item:Item):
	
	# Check Qty ...
	if _content.size() != 0:
		var count = _content.size()
		#print(" First Loop .....")
		#print("Count Size : %s" % count)
		for i in _content:
			#print("for i in _content loop")
			#print(i.name)
			#print(item.name)
			if i.name == item.name:
				print("Names Match ..... ")
				#print(i.name)
				i.qty += 1
				print("Qty : " + str(i.qty))
				break
			else:
				count -= 1
				#print("Count ")
				#print(count)
				if count == 0:
					_content.append(item)
					#print(" All Items in Inventory Checked")
					break
					
	else:
		#print(" First Item Onlu")
		_content.append(item)




func remove_item(item:Item):
	# NOTE Need a drop or use button from Naz ...
	# Check Qty ...
	_content.erase(item)
	

func get_items() -> Array[Item]:
	return _content
