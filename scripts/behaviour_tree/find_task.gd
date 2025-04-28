@tool
extends BTLeaf

func tick(_delta: float, actor: Node, _blackboard: Blackboard) -> BTStatus:
	if actor.transport_component:
		print("searching")
		var nearest_drop = actor.transport_component.search_nearest_drop()
		actor.transport_component.search_nearest_box_can_store()
		if nearest_drop:
			return BTStatus.SUCCESS
	return BTStatus.FAILURE
