extends BaseInteraction
class_name InteractionDialog


@export var timelines: Array[DialogicTimeline]
@export var selected: int
@onready var parent: Npc = get_parent().get_parent()
var char_resource: DialogicCharacter

func _ready() -> void:
	char_resource = fetch_character_resouce()
	# Connect to timeline ended? 
	Dialogic.timeline_ended.connect(_on_timeline_ended)

func interact():
	var layout := Dialogic.start(timelines[selected])
	layout.register_character(char_resource, parent.marker2d)
	dialogic_variable()
	
	# Pause stuff
	SceneManager.player.set_physics_process(false)
	get_parent().set_process_unhandled_input(false)
	


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
	char_resource = parent.dialogic_character_resource
	return char_resource
	
func _on_timeline_ended():
	# UnPause stuff
	SceneManager.player.set_physics_process(true)
	get_parent().set_process_unhandled_input(true)
