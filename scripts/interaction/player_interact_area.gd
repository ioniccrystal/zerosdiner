extends InteractArea
class_name PlayerInteractArea
# 玩家交互区域,除了找最近的交互物外,还会显示鼠标悬停效果、返回玩家所在的格子坐标


@export var player: Player

# 把handitemholder集成了
@export_node_path("Hotbar") var hotbar_path = NodePath("../CharacterInventorySystem/Hotbar")
@onready var hotbar : Hotbar = get_node(hotbar_path)
@export_node_path("InventoryInteractor") var interactor_path = NodePath("../CharacterInventorySystem/InventoryInteractor")
@onready var interactor : InventoryInteractor = get_node(interactor_path)
@export_node_path("ObjectPlacer2D") var object_placer_path = NodePath("../CharacterInventorySystem/InventoryInteractor/ObjectPlacer")
@onready var object_placer :ObjectPlacer2D = get_node(object_placer_path)

var _can_interact : bool = true
var current_mouse_tile_pos  # 存储当前鼠标瓦片坐标

# 鼠标悬停效果
var hover_effect: Polygon2D

# HandItemHolder部分
var hand_item : SlotItem = null
var objects_per_id : Dictionary


func _ready() -> void:
	super._ready()
	setup_hover_polygon()   # 设置鼠标悬停效果




func _process(_delta):
	if _can_interact:
		hand_item = interactor.hotbar.get_selected_item()
		hover_effect.visible = false  # 默认隐藏高亮
		if !hand_item:
			return
		if hand_item.definition.properties.has("设施"):
			handle_hover_effect()
		elif hand_item.definition.properties.has("种子"):
			handle_hover_effect("soil")


func _unhandled_input(event: InputEvent) -> void:
	if _can_interact:
		# 鼠标左键
		if event is InputEventMouseButton and event.pressed and hover_effect.visible:
			var click_pos = get_global_mouse_position()
			var tile_pos = player.tile_maps.layer_0.local_to_map(click_pos)
			if event.button_index == MOUSE_BUTTON_LEFT:
				if !hand_item:
					return
				if hand_item.definition.properties.has("设施") or hand_item.definition.properties.has("种子"):
					object_placer.place_item(hand_item,current_mouse_tile_pos,false)
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				if player.tile_maps.block_layer.get_used_cells().has(tile_pos):
					player.tile_maps.block_layer.erase_cell(tile_pos)
					Global.map_block_item_changed.emit(tile_pos,false)


# 设置鼠标悬停效果的多边形
func setup_hover_polygon() -> void:
	hover_effect = Polygon2D.new()
	# 创建菱形形状的多边形
	hover_effect.polygon = PackedVector2Array([
		Vector2(0, -8),  # 顶点
		Vector2(16, 0),  # 右点
		Vector2(0, 8),   # 底点
		Vector2(-16, 0)  # 左点
	])
	hover_effect.color = Color(1, 1, 1, 0.2)  # 设置半透明白色
	hover_effect.visible = false  # 初始时隐藏
	hover_effect.z_index = 200
	add_child(hover_effect)


# 处理鼠标悬停效果
func handle_hover_effect(custom_data = null) -> void:
	# 获取玩家所在的格子坐标
	var player_pos = player.position
	var player_tile_pos = player.tile_maps.layer_0.local_to_map(player_pos)
	
	# 获取鼠标位置并转换为瓦片坐标
	var mouse_pos = player.tile_maps.get_local_mouse_position()
	var mouse_tile_pos = player.tile_maps.layer_0.local_to_map(mouse_pos)
	
	# 获取玩家周围的8个相邻格子
	var neighbor_cells = [
		Vector2i(player_tile_pos.x + 1, player_tile_pos.y),     # 右
		Vector2i(player_tile_pos.x + 1, player_tile_pos.y + 1), # 右下
		Vector2i(player_tile_pos.x + 1, player_tile_pos.y - 1),  # 右上
		Vector2i(player_tile_pos.x, player_tile_pos.y - 1),     # 上
		Vector2i(player_tile_pos.x, player_tile_pos.y + 1),     # 下
		Vector2i(player_tile_pos.x - 1, player_tile_pos.y + 1), # 左下
		Vector2i(player_tile_pos.x - 1, player_tile_pos.y),     # 左
		Vector2i(player_tile_pos.x - 1, player_tile_pos.y - 1), # 左上
	]
	
	# 检查鼠标是否在玩家周围的可用地板上
	var is_valid_floor = player.tile_maps.layer_0.get_used_cells().has(mouse_tile_pos) or \
		player.tile_maps.layer_0_a.get_used_cells().has(mouse_tile_pos)
	
	# 检查自定义数据
	var tile_data = player.tile_maps.layer_0.get_cell_tile_data(mouse_tile_pos)
	var has_custom_data = true
	if custom_data != null and tile_data != null:
		has_custom_data = tile_data.get_custom_data(custom_data)
	
	if neighbor_cells.has(mouse_tile_pos) and is_valid_floor and has_custom_data:
		# 只在有效位置时更新 current_mouse_tile_pos
		current_mouse_tile_pos = mouse_tile_pos
		# 将瓦片坐标转换回世界坐标
		var local_pos = player.tile_maps.layer_0.map_to_local(current_mouse_tile_pos)
		hover_effect.global_position = local_pos
		hover_effect.visible = true
	else:
		current_mouse_tile_pos = null  # 无效位置时设为null
		hover_effect.visible = false

#func store_box_to_player(box: BoxInteractible) -> void:
	#if not box or box.inventory.is_empty():
		#return
		#
	## 转移所有物品槽
	#var slots_to_transfer = box.inventory.slot_list.duplicate()
	#for slot in slots_to_transfer:
		#if player.inventory.is_full():
			## 玩家背包满了，结束储存
			#return
		#
		#box.inventory.remove_slot(slot)
		#player.inventory.add_slot(slot)
	#

func get_map_position() -> Vector2:
	# 直接使用已经计算好的瓦片坐标
	return player.tile_maps.layer_0.map_to_local(current_mouse_tile_pos)
