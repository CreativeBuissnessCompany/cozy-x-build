extends Objective
class_name RetrieveObjective


@export var item: Item




func run_objective():
	print("Retrieving Objective")
	var player: Player = SceneManager.player
	if player.monitor_items_added != true:
		player.monitor_items_added = true