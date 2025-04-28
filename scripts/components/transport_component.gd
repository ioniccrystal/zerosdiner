@tool
extends InventoryHandler
class_name TransportComponent
## 最大容量
@export var max_volume: int = 1
## 拾取半径
@export var radius: float = 16.0
## 背包节点
@export var interact_area: InteractArea
@onready var entity = get_parent()
var held_items_sprites: Array[Sprite2D] = []

var nearest_drop = null
var nearest_box_can_store = null

func _ready() -> void:
	super._ready()
	# 设置物品栏容量
	inventories[0].slot_amount = max_volume
	
	# 连接物品栏信号
	inventories[0].item_added.connect(_on_inventory_item_added)
	inventories[0].item_removed.connect(_on_inventory_item_removed)
	#check_inventory_volume()

	Global.drop_ready.connect(_on_drop_ready)
	Global.drop_picked.connect(_on_drop_picked)
	
	interact_area.current_interactible_changed.connect(_on_interactible_changed)

func _on_drop_ready():
	entity.voidsent_state_machine.fire_event("work_task")#发布新任务
	search_nearest_drop()


func _on_drop_picked():
	search_nearest_drop()

func _on_inventory_item_added(item : SlotItem, _amount : int) -> void:
	# 创建新的物品精灵
	var sprite = Sprite2D.new()
	sprite.texture = item.definition.icon
	sprite.position = Vector2(0, -32 - (inventories[0].slot_list.size() - 1) * 2)
	add_child(sprite)
	held_items_sprites.append(sprite)
	#state_chart.send_event("item_added")

	# 检查物品栏容量
	#check_inventory_volume()

func _on_inventory_item_removed(_item : SlotItem, _amount : int) -> void:
	# 移除最后一个精灵
	if held_items_sprites.size() > 0:
		var sprite = held_items_sprites.pop_back()
		sprite.queue_free()
	
	# 重新排列剩余精灵的位置
	for i in range(held_items_sprites.size()):
		held_items_sprites[i].position = Vector2(0, -32 - i * 2)
	# 检查物品栏容量
	#check_inventory_volume()


# 检查物品栏容量
#func check_inventory_volume() -> void:
	#var current_size = inventories[0].slot_list.size()
	#var is_full = current_size >= inventories[0].volume
	
	# 设置碰撞形状（只在满时禁用）
	#collision_shape.call_deferred("set_disabled", is_full)


# 处理物品槽拾取
func on_item_slot_picked_up(slot: SlotItem) -> void:
	inventories[0].add(slot, 1) # 现在固定拾取一个


# 搜索最近的掉落物
func search_nearest_drop() -> Node:
	if not entity or not entity.nav_agent:
		return null
	var drops = get_tree().get_nodes_in_group("drops")
	var nearest = null
	var min_distance = INF
	for drop in drops:
		if drop is DroppedItem2D:
			var distance = ScriptUtilities.isometric_distance_to(interact_area.global_position,drop.global_position)
			if distance < min_distance:
				min_distance = distance
				nearest = drop
	nearest_drop = nearest #记下来
	return nearest

# 搜索最近的未满箱子
func search_nearest_box_can_store():
	if not entity or not entity.nav_agent:
		return null
	var boxes = get_tree().get_nodes_in_group("boxes_can_store")
	var nearest = null
	var min_distance = INF
	for box in boxes:
		if box is BoxInventory:
			var distance = ScriptUtilities.isometric_distance_to(interact_area.global_position,box.global_position)
			if distance < min_distance:
				min_distance = distance
				nearest = box
	nearest_box_can_store = nearest #记下来
	return nearest

# 尝试将物品存入箱子
# 修改存储函数
func store_slots_to_box(box: BoxInventory) -> void:
	if not box or inventories[0].slot_list.is_empty():
		return
	# 转移所有物品槽
	var slots_to_transfer = inventories[0].slot_list.duplicate()
	for slot in slots_to_transfer:
		if box.inventories[0].is_full():
			return
		inventories[0].remove_slot(slot)
		box.inventory.add_slot(slot)

func _on_interactible_changed():
	if interact_area.current_interactible and is_instance_valid(interact_area.current_interactible):
		interact_area.interact.emit()
