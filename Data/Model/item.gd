class_name Item
extends Resource

@export var name:String
@export var scene:PackedScene
@export var icon:Texture2D
@export_multiline var description: String = ""

#var item_info_dict: Dictionary = {}


#func _ready():
	#
	## Fill Item Dictionary ...
	#item_info_dict = {
	#Name = name,
	#Scene = scene,
	#Icon = icon, 
	#Description = description
#}
