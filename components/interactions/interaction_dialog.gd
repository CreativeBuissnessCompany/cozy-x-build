extends BaseInteraction
class_name InteractionDialog


@export var timelines: Array[DialogicTimeline]
@export var selected: int





func interact():
	Dialogic.start(timelines[selected])
	print(" Did something in DialogInteraction ! ")
