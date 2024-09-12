# inventory_comp.gd

class_name Inventory
extends Resource


@export var _content:Array[Item] = []


func add_item(item:Item):
	_content.append(item)
	

func remove_item(item:Item):
	_content.erase(item)
	

func get_items() -> Array[Item]:
	return _content
