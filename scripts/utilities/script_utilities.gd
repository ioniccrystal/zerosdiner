class_name ScriptUtilities extends Object

static func find_child(node : Node, type : String) -> Node:
	# Iterate through all children
	for child in node.get_children():
		# If the child is a match then return it
		if child.is_class(type):
			return child

		# Recurse into child
		var found := find_child(child, type)
		if found:
			return found

	# No child found matching type
	return null

## 计算等距视角下的距离(pos1: Vector2,pos2: Vector2),返回值为float
static func isometric_distance_to(pos1: Vector2,pos2: Vector2) -> float:
	var delta = pos1 - pos2
	# 在等距视角下，y轴显示的距离是实际距离的一半
	# 所以我们需要将y轴的差值乘以2来得到实际距离
	delta.y *= 2
	return delta.length()
