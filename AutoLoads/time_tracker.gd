class_name TimeTracker extends Node


var day_node: RichTextLabel

var day: int = 1:
	set(value):
		day = value
		Signalbus.day_change.emit(day)
		print("")
		print_rich("[center] Day [/center] ", day)
		print("")
		#day_node.text = "Day: %s" % day
		
