@tool
extends BTLeaf

func tick(_delta: float, actor: Node, _blackboard: Blackboard) -> BTStatus:
	if !actor.transport_component:
		return BTStatus.FAILURE
	if actor.transport_component.inventory.is_full():
		return BTStatus.SUCCESS
	return BTStatus.FAILURE
