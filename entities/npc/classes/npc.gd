extends Node2D

class_name Npc

@onready var interactable_node: Interactable = %Interactable
@export var npc_quest: Quest
@export var dialogic_character_resource: DialogicCharacter
# Useful for 
@onready var marker2d: Marker2D = %Marker2D
