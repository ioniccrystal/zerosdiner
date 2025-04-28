@tool
extends BTLeaf

func tick(_delta: float, actor: Node, _blackboard: Blackboard) -> BTStatus:
	if actor.transport_component:
		if actor.transport_component.inventory.is_empty():
			#print("NearestStoreF1_inventoryempty")
			return BTStatus.FAILURE
		actor.transport_component.search_nearest_box_can_store()
		var box = actor.transport_component.nearest_box_can_store
		if box and is_instance_valid(box):
			actor.nav_agent.target_position = box.global_position
			return BTStatus.SUCCESS
		#print("NearestStoreF2_nobox")
		return BTStatus.FAILURE
	#print("NearestStoreF3_noTC")
	return BTStatus.FAILURE
