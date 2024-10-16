# parallax.gd
extends Node2D


# Variables

@onready var back: Parallax2D = $Back
@onready var middle: Parallax2D = $Middle
@onready var front: Parallax2D = $Front

@export var back_speed: int
@export var middle_speed: int
@export var front_speed: int



func _process(delta: float) -> void:
	
	
	back.scroll_offset.x += delta * back_speed
	middle.scroll_offset.x += delta * middle_speed
	front.scroll_offset.x += delta * front_speed
