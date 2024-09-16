class_name TimeTracker extends Node


var day_node: RichTextLabel

var day: int = 1:
	set(value):
		day = value
		Signalbus.day_change.emit(day)
		#day_node.text = "Day: %s" % day
		print()
