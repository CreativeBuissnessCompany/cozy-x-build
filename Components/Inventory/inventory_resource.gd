# inventory_resource.gd

class_name Inventory
extends Resource


@export var _content:Array[Item] = []


func add_item(item:Item):
	
	if _content.size() != 0:
		for i in _content:
			print("Itterate...")
			print(i.name)
			print(item.name)
			if i.name == item.name:
				print("More Than One...")
				#print(i.name)
				i.qty += 1
				print("Qty : " + str(i.qty))
			else:
				_content.append(item)
				
				print(" Total Content : ")
				print(_content)
				
	else:
		_content.append(item)

func remove_item(item:Item):
	_content.erase(item)
	

func get_items() -> Array[Item]:
	return _content
