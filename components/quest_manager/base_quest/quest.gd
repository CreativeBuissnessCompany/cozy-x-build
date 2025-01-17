extends Resource
class_name Quest


@export var quest_name: String
@export var description: String
#@export var objective: Objective # Delete Later.... Replace with the array under....
@export var objectives: Array[Objective]

@export var rewards: Array[Reward]

var inprogress: bool = false  # Unused for now
var all_objectives_complete: bool = false

var objectives_completed: bool = false:
	set(value):
		objectives_completed = value
		if objectives_completed == true:
			#Signalbus.quest_completed.emit(objectives_completed)
			# Set variables quest_complete in Dialogic ...
			if Dialogic.VAR.quest_complete != null:
				Dialogic.VAR.quest_complete = true
				print(" Quest set the var in Dialogic .....")
