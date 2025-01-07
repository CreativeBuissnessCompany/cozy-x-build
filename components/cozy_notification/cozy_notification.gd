extends Node2D
class_name CozyNotification

@onready var rich_text_node: RichTextLabel = %RichTextLabel
@export var text_displayed: String
var random_number: int = random_digi()
var play: bool = false
var starting_pos: Vector2
var travel_distance: Vector2


func _ready() -> void:
	self.visible = false
	await get_tree().create_timer(clampf(randf(), 0.05, 0.1)).timeout
	starting_pos = position
	print(starting_pos)
	play = true
	
func _process(delta: float) -> void:
	if play:
		visible = true
		display(text_displayed, delta)


func before_display(_text):
	text_displayed = rich_wave(_text)
	rich_text_node.append_text(text_displayed)


func display(_text: String, delta: float):

	travel_distance = position - starting_pos
	self.position.x += random_number 
	self.position.y -= 50 * delta
#	print(position.y)

	if abs(travel_distance) >= Vector2(200,100):
		self.queue_free()


	
#	if self.position.y <= -50 or self.position.x >= 200:
#		print("free")
#		self.queue_free()
		
		
func random_digi() -> int:
	randomize()
	var x : int = randi_range(-1 , 1)
	return x
	
func rich_wave(_text: String) -> String:
	var processed_text: String = "[wave amp=40.0 freq=3.0 connected=1][color=Orange]%s[/color][/wave]" % _text
	print(processed_text)
	return processed_text