class_name MoneyReward
extends Reward


@export var reward: int 




func give_cookie():
	print("Was able to override properly in MoneyReward")
	var player: Player = SceneManager.player
	player.currency_node.change_currency(reward)
