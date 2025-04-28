@tool
extends BTLeaf

func tick(_delta: float, actor: Node, _blackboard: Blackboard) -> BTStatus:
	var nearest_box = actor.transport_component.nearest_box_can_store
	var nearest_drop = actor.transport_component.nearest_drop
	
	# 如果两个目标都不存在，返回失败
	if not nearest_box and not nearest_drop:
		print("NearestTransportF")
		return BTStatus.FAILURE
	
	
	# 如果只有一个目标存在，直接导航向该目标
	if not nearest_box:
		if is_instance_valid(nearest_drop):
			actor.nav_agent.target_position = nearest_drop.global_position
			print("NearestTransportS1")
			return BTStatus.SUCCESS
		print("NearestTransportF1")
		return BTStatus.FAILURE
		
	if not nearest_drop:
		if is_instance_valid(nearest_box):
			actor.nav_agent.target_position = nearest_box.global_position
			print("NearestTransportS2")
			return BTStatus.SUCCESS
		print("NearestTransportF2")
		return BTStatus.FAILURE
	
	# 如果两个目标都存在，需要先检查它们的有效性
	if not (is_instance_valid(nearest_box) and is_instance_valid(nearest_drop)):
		print("NearestTransportF3")
		return BTStatus.FAILURE
	
	# 计算距离并选择较近的
	var distance_to_box = ScriptUtilities.isometric_distance_to(actor.global_position,nearest_box.global_position)
	var distance_to_drop = ScriptUtilities.isometric_distance_to(actor.global_position,nearest_drop.global_position)
	
	if distance_to_box < distance_to_drop:
		actor.nav_agent.target_position = nearest_box.global_position
	else:
		actor.nav_agent.target_position = nearest_drop.global_position
	print("NearestTransportS")
	return BTStatus.SUCCESS
