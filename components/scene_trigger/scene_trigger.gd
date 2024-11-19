# scene_trigger.gd
@icon("res://themes/editor_icons/scene_trigger_icon.png")
class_name SceneTrigger 
extends Area2D


# Variables ...

# NEXT Scene ....
@export var connected_scene: String

# SFX for Transition
@export var audio_file: AudioStreamMP3 

# Current ....
var current_scene: Node2D





func _on_body_entered(body: Node2D) -> void:
	
	if body is Player:
		# Load next Scene
		var loaded_scene = load(connected_scene)
		# Get Owner Node ( Location i.e. "Farm" )
		current_scene = get_owner()
		SceneManager.manual_scene_change(current_scene, loaded_scene)
		Signalbus.sfx.emit(audio_file)
