class_name DebugComponent

extends Node2D

@export var debug_on: bool
@export var debug_label: RichTextLabel

@export var day_button: Button
@export var universe: Universe




func check_for_developer_mode():
	if debug_on:
		# Debug Indicator
		debug_label.visible = true
		# Entrance Markers
#		entrance_name = "debug"
		universe.entrance_name = "debug"
		# Set day_button shit ...
		day_button.visible = true