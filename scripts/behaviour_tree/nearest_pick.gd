@tool
extends BTLeaf

func tick(_delta: float, actor: Node, _blackboard: Blackboard) -> BTStatus:
	if actor.transport_component:
		var drop = actor.transport_component.nearest_drop
		if drop and is_instance_valid(drop):
			actor.nav_agent.target_position = drop.global_position
			return BTStatus.SUCCESS
		#print("NearestPickF2_nodrop")
		return BTStatus.FAILURE
	#print("NearestPickF3_noTC")
	return BTStatus.FAILURE
