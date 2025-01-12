extends Node2D

class_name Npc

@onready var interactable_node: Interactable = %Interactable

@export var npc_quest: Quest


#func _ready() -> void:
#	update_dialogic_quest_var()



#func update_dialogic_quest_var():
#	Dialogic.VAR.quest_name = npc_quest.quest_name
#	print("NPC Name", self.name)
#	print("Dialogic variable name ", Dialogic.VAR.variables())
#	print("NPC var....", npc_quest.quest_name)
#	print("Dialogic var...", Dialogic.VAR.Day_01.Old_Guy_quest)