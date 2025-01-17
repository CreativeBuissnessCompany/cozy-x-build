extends Node2D
class_name QuestManager


#var held_quests: Array[Quest] # Unused for now ...
var current_quest: Quest
var number_of_objectives: int
var objectives: Array[Objective]

var database: Database = load("res://my_databases/quests.gddb")



func _ready() -> void: # Step 1 ....
	Signalbus.quest_given.connect(_on_quest_given) #  ... From Dialogic 
	Signalbus.quest_completed.connect(_on_quest_completed) # .... From Quest held in player ...

	
func give_reward():
	var rewards: Array = current_quest.rewards
	for reward: int in rewards.size():
		rewards[reward].give_cookie()
		pass


	

# Step 12 .... From Quest
func _on_quest_completed():
	
	Utility.cozy_notification_spawner(" Quest Completed, Go talk to that guy .....",\
	 SceneManager.player,get_parent().get_parent())

	give_reward()
	print(" Quest Completed, Go talk to that guy .....")

# Step 5 ....
#func retrieve_objective():
#	print("Retrieving Objective")
#	var player: Player = get_parent()
#	if player.monitor_items_added != true:
#		player.monitor_items_added = true

# Step 4 ....
func run_objective_func(_objectives: Array[Objective]):
	print("run_objective_func ")
	for i in _objectives.size():
		_objectives[i].run_objective()

# Step 3 ....
func match_quest_w_resource(quest_name: StringName) -> Quest:

	# Find Resource using Collection & Resource Name ...
	var resource_int_id: int = database.get_int_id("quests", quest_name)
	var quest_resource: Quest = database.fetch_data("quests", resource_int_id)
	return quest_resource

# Step 2 - From Dialogic ...    
func _on_quest_given(quest_name: String):
	Utility.cozy_notification_spawner("Quest Accepted!!!", SceneManager.player, get_parent().get_parent())
	# Convert from String To StringName
	# Use string to find Quest resource...Returns Quest
	current_quest = match_quest_w_resource(quest_name as StringName)
	
	run_objective_func(current_quest.objectives) 
	Signalbus.quest_update.emit(current_quest.quest_name)
	
	# Set Objectives and total number of them ...
	number_of_objectives = current_quest.objectives.size()
	objectives = current_quest.objectives
	
	# (Step 6 in Player) Step 7  ....
func match_items(item: Item):
#	var objective: RetrieveObjective = current_quest.objective
	objectives = current_quest.objectives # Wha Why? WARNING 
	for _objective in objectives.size():
		if objectives[_objective] is RetrieveObjective:
			if objectives[_objective].item.name == item.name:
				Utility.cozy_notification_spawner("Got The Thing We Needed !!!!", SceneManager.player, get_parent().get_parent())
				# Set objective to complete ...
				mark_objective_complete(objectives[_objective])
				if current_quest.objectives_completed == true: # Check Objectives are all done ...
					# Turn off player item monitoring
					var player: Player = get_parent()
					player.monitor_items_added = false
	
	# Step 8  ....
func mark_objective_complete(_objective: Objective):
	print("mark_objective_complete")
	_objective.objective_complete = true
	check_all_objectives()
	
	# Step 9 ....
func check_all_objectives():
	print("check_all_objectives")
	number_of_objectives = current_quest.objectives.size()
	
	for i in current_quest.objectives.size():
		if current_quest.objectives[i].objective_complete == true:
			number_of_objectives -= 1
			print("number_of_objectives", number_of_objectives)
			if number_of_objectives == 0:
				current_quest.objectives_completed = true # Step 10 in "Quest"...... NOTE Step 11 is HERE In _Ready...
