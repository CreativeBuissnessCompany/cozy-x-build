class_name TimeTracker extends Node


var day: int = 1:
	set(value):
		day = value
		Signalbus.day_change.emit(day)
		print("Day Changed")
		print_rich("[center] Day [/center] ", day)
		print("")
		week_calc()
		day_names_calc()


var week: int = 1
var day_of_week: int = 1
var month: int = 1 
var year: int = 1

var day_name: Dictionary = {
	1: "Sunday",
	2: "Monday",
	3: "Tuesday",
	4: "Wednesday",
	5: "Thursday",
	6: "Friday",
	7: "Saturday"
}



func week_calc():
	if day != 1:
		day_of_week += 1
		#print("Day of week")
		#print(day_of_week)
		if day_of_week == 8:
			week += 1
			day_of_week = 1
			month_calc()
			#print("Week")
			#print(week)


func month_calc():
	if week == 5:
		month += 1
		week = 1
		year_calc()
		#print("Month")
		#print(month)


func year_calc():
	if month ==5:
		year +=1 
		month = 1
		#print("Year")
		#print(year)

func day_names_calc():
	
	print("This is the fucking day of the week .....")
	print(day_name[day_of_week])
	
	return day_name[day_of_week]
	
