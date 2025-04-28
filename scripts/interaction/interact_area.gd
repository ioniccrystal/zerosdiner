extends Area2D
class_name InteractArea
## 这个类的作用是找最近的Interactible

@onready var entity = get_parent()
@export var inventory_handler: InventoryHandler


var current_interactible: Interactible:
	set(value):
		current_interactible = value
		current_interactible_changed.emit()

#signal interact
signal current_interactible_changed

func _ready() -> void:
	# 连接区域信号
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D) -> void:
	if not area is Interactible:
		return
	# 如果已经有连接，检查新的是否更近
	if current_interactible and is_instance_valid(current_interactible):
		var current_distance = ScriptUtilities.isometric_distance_to(global_position,current_interactible.global_position)
		var new_distance = ScriptUtilities.isometric_distance_to(global_position,area.global_position)
		
		if new_distance < current_distance:
			# 断开旧连接
			disconnect_from_current()
			# 连接新的
			connect_to_interactible(area)
	else:
		# 如果当前连接无效，直接断开并连接新的
		disconnect_from_current()
		connect_to_interactible(area)
	


func connect_to_interactible(interactible: Interactible) -> void:
	current_interactible = interactible
	#interact.connect(interactible._on_interact.bind(self))
	interactible._on_connected(self) #通知它已经连上了

func disconnect_from_current() -> void:
	if current_interactible and is_instance_valid(current_interactible):
		#if interact.is_connected(current_interactible._on_interact):
			#interact.disconnect(current_interactible._on_interact)
			current_interactible._on_disconnected(self) #通知它已经断开了
	current_interactible = null

func _on_area_exited(area: Area2D) -> void:
	if area is Interactible and area == current_interactible:
		var disconnected_interactible = current_interactible  # 保存即将断开的引用
		disconnect_from_current()
		
		# 检查是否还有其他可连接的交互物
		var overlapping_areas = get_overlapping_areas()
		var closest_interactible: Interactible = null
		var min_distance = INF
		
		for overlapping_area in overlapping_areas:
			# 跳过刚刚断开的物体
			if overlapping_area == disconnected_interactible:
				continue
				
			if overlapping_area is Interactible and is_instance_valid(overlapping_area):
				var distance = ScriptUtilities.isometric_distance_to(global_position,overlapping_area.global_position)
				if distance < min_distance:
					min_distance = distance
					closest_interactible = overlapping_area
		
		# 如果找到了最近的，就连接
		if closest_interactible:
			connect_to_interactible(closest_interactible)
