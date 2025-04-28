@tool
extends BTLeaf

func tick(_delta: float, actor: Node, _blackboard: Blackboard) -> BTStatus:
	if actor and is_instance_valid(actor):
		var rand_x = randi() % 100
		var rand_y = randi() % 100
		var rand_position = actor.position + Vector2(rand_x - 50, rand_y - 50)
		actor.nav_agent.target_position = rand_position
	return BTStatus.SUCCESS
