extends TextureRect
class_name ItemNotificationBox

@onready var image: TextureRect = %Image
@onready var rich_text_label: RichTextLabel = %RichTextLabel


func _ready() -> void:
	
	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0, 3)
	tween.tween_callback(queue_free)




func set_item_n_box_data(_image: SpriteFrames,text):
	image.texture = _image.get_frame_texture("default", 0)
	rich_text_label.parse_bbcode("[center]%s[/center]" % text)
