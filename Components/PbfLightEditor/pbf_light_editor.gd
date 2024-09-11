extends Node



@onready var h_slider: HSlider = $HSlider
@onready var omni_light_3d: PointLight2D = $".."



func _ready() -> void:
	pass

func _process(delta: float) -> void:
	
	omni_light_3d.energy = int(h_slider.value)
