extends BaseInteraction
class_name InteractionDialog


@export var timelines: Array[DialogicTimeline]
@export var selected: int





func interact():
	Dialogic.start(timelines[selected])
	dialogic_variable()

	
# Check if thing with interaction has a variable for Dialogic
func dialogic_variable():
	var parent: Npc = get_parent().get_parent()
	
	# Check the thing has an npc_quest
	if parent.npc_quest:
		Dialogic.VAR.quest_name = parent.npc_quest.quest_name
		print("Loojing good joker")
		
		print(Dialogic.VAR.quest_name)