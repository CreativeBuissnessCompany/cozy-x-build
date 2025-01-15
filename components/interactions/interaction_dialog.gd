extends BaseInteraction
class_name InteractionDialog


@export var timelines: Array[DialogicTimeline]
@export var selected: int
@onready var parent: Npc = get_parent().get_parent()
var char_resource: DialogicCharacter

func _ready() -> void:
	char_resource = fetch_character_resouce()

func interact():
	var layout := Dialogic.start(timelines[selected])
	layout.register_character(char_resource, parent.marker2d)
	
	dialogic_variable()
	
	


# Checks if parent has npc_quest...
# Sets Dialogic variable quest_name to npc_quest.quest_name
# Dialogic emits on acceptance of quest...Dialogic>Signalbus.on_quest_given()>QuestManager...
func dialogic_variable():
	# Check the thing has an npc_quest
	if parent.npc_quest:
		Dialogic.VAR.quest_name = parent.npc_quest.quest_name
		print("Loojing good joker")
		print(Dialogic.VAR.quest_name)
		
		
func fetch_character_resouce() -> DialogicCharacter:
	var char_resource: DialogicCharacter = parent.dialogic_character_resource
	return char_resource
	
	
