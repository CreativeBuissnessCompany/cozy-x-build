# pickup_comp.gd
class_name PickupComp
extends Node2D


# Variables
@export var item:Item:
	set(value):
		item = value

var ITEM_TYPE_SEED: int = 1
var ITEM_TYPE_RESIZE: int = 2
var animated_sprite2d := AnimatedSprite2D.new()

var player_near: bool = false
var player_body: Player


# Script_Start
func _ready() -> void:
	#print(item.name," is Ready.... ")
	
	var sprite_frame: SpriteFrames = item.sprite_frame
	
	# Set offset if SEED type of item 
	if item.item_type == ITEM_TYPE_SEED:
		
		#animated_sprite2d.global_position += Vector2(0,-15) 
		pass
		
	if item.item_type == ITEM_TYPE_RESIZE:
		self.scale = Vector2(0.5,0.5)
		pass
	
	
	# NOTE New ......Testing....
	if item.sprite_frame:
		animated_sprite2d.sprite_frames = item.sprite_frame
	
	add_child(animated_sprite2d)


func _process(_delta: float) -> void:
	if player_near:
		var tween: Tween = get_tree().create_tween().bind_node(self)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self,"global_position", player_body.global_position, .50)
	
	


func _on_area_2d_body_entered(body: Player) -> void:
	
	if body is Player: 
		#print_debug("Got an %s!" % item.name)
		body.on_item_picked_up(item)
		self.queue_free()
	else:
		return
	





func go_to_player_body(body:Node2D) -> void:
#	print("Parent")
#	print(get_parent())
#	print("Body Entered")
#	print(body)
	if body is Player:
		player_near = true
		player_body = body
#		print("Pickup comp is trying to go to player ")
#		var tween: Tween = get_tree().create_tween().bind_node(self)
#		tween.set_ease(Tween.EASE_IN_OUT)
#		tween.tween_property(self,"global_position", body.global_position, 1)
	
	pass # Replace with function body.


func dont_go_to_player(_body:Node2D) -> void:
	player_near = false
	pass # Replace with function body.
