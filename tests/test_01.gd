# test_01.gd
class_name Test_01
extends Node



var times_ran: int = 0


func increment_times_ran(times: int):
	
	times_ran += times
	

# Copy for testing

## For TESTING 
#@onready var test : Test_01= %Test	


# 	# TESTING 
#	test.increment_test(1)
#	if test.times_ran > 4:
#		return