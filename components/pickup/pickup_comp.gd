# pickup_comp.gd
class_name PickupComp
extends Node2D


# Variables
@export var item:Item

var ITEM_TYPE_SEED: int = 1
var ITEM_TYPE_RESIZE: int = 2
var animated_sprite2d := AnimatedSprite2D.new()

var player_near: bool = false
var player_body: Player



#                                                Script Start...


func _ready() -> void:
	# Set offset if item type is SEED ...
	if item.item_type == ITEM_TYPE_SEED:
		#animated_sprite2d.global_position += Vector2(0,-15)        NOTE Unused, Delete? 
		pass
	# ITEM_TYPE_RESIZE
	if item.item_type == ITEM_TYPE_RESIZE:
		self.scale = Vector2(0.5,0.5)
	# Set SpriteFrame ...
	if item.sprite_frame:
		animated_sprite2d.sprite_frames = item.sprite_frame
	# Add child ...
	add_child(animated_sprite2d)


func _process(_delta: float) -> void:
	go_to_player()

	
#                                               Custom Functions...	

# If player body enters, player.on_item_pickedup(item) ....
func _on_area_2d_body_entered(body: Player) -> void:
	if body is Player: 
		#print_debug("Got an %s!" % item.name)
		body.on_item_picked_up(item)
		self.queue_free()
	else:
		return
	
## On body entered, Check if body player ...
func check_for_player_body(body:Node2D) -> void:
	if body is Player:
		player_body = body
		player_near = true
		


func dont_go_to_player(_body:Node2D) -> void:
	player_near = false
	pass # Replace with function body.

	
func go_to_player():
	await get_tree().create_timer(.30).timeout
	
	if player_near:
		
		var tween: Tween = get_tree().create_tween().bind_node(self)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self,"global_position", player_body.global_position, .30)