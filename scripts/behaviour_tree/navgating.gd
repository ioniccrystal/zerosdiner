@tool
extends BTLeaf

func tick(_delta: float, actor: Node, _blackboard: Blackboard) -> BTStatus:
	if actor.nav_agent.is_navigation_finished():
		return BTStatus.SUCCESS
	else:
		return BTStatus.RUNNING
