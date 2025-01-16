class_name ItemReward
extends Reward


@export var reward: Item




func give_cookie():
	print("Was able to override properly in ItemReward")
	var player: Player = SceneManager.player
	player.inventory.add_item(reward)