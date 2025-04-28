extends Node2D
class_name TileMaps

# 获取不同图层的引用
@onready var layer_0: TileMapLayer = $Layer0  # 地板层
@onready var block_layer: TileMapLayer = $BlockLayer  # 障碍物层
@onready var plant_layer: TileMapLayer = $PlantLayer  # 农作物层
@onready var layer_0_wall: TileMapLayer = $Layer0Wall # 空气墙层
@onready var layer_0_a: TileMapLayer = $Layer0A  # 地板替换层（被障碍物遮挡的地板）
@onready var player: Player = $Player  # 玩家引用



# 初始化
func _ready() -> void:
	Global.map_block_item_changed.connect(_on_map_block_item_changed)
	Global.map_layer_0_changed.connect(_on_layer_0_changed)
	delete_blocked_tiles()  # 处理被障碍物遮挡的地板
	set_walls() # 空气墙
	


# 处理被障碍物遮挡的地板
func delete_blocked_tiles():
	var blocked_tiles = block_layer.get_used_cells()  # 获取所有障碍物位置
	var replaced_tiles = layer_0_a.get_used_cells()  # 获取所有被替换的地板位置
	
	# 处理新增的障碍物
	for tile_pos in blocked_tiles:
		if layer_0.get_used_cells().has(tile_pos):
			move_tile_to_layer_0a(tile_pos)
	
	# 处理被移除的障碍物
	for tile_pos in replaced_tiles:
		if not blocked_tiles.has(tile_pos):  # 如果该位置不再有障碍物
			move_tile_to_layer_0(tile_pos)

# 将地板从layer_0移动到layer_0_a
func move_tile_to_layer_0a(tile_pos: Vector2i) -> void:
	var atlas_coords = layer_0.get_cell_atlas_coords(tile_pos)
	var source_id = layer_0.get_cell_source_id(tile_pos)
	layer_0.erase_cell(tile_pos)
	layer_0_a.set_cell(tile_pos, source_id, atlas_coords)

# 将地板从layer_0_a移动到layer_0
func move_tile_to_layer_0(tile_pos: Vector2i) -> void:
	var atlas_coords = layer_0_a.get_cell_atlas_coords(tile_pos)
	var source_id = layer_0_a.get_cell_source_id(tile_pos)
	layer_0_a.erase_cell(tile_pos)
	layer_0.set_cell(tile_pos, source_id, atlas_coords)

# 用位置处理被障碍物遮挡的地板
func _on_map_block_item_changed(tile_pos, placing):
	if placing:
		move_tile_to_layer_0a(tile_pos)
	else:
		move_tile_to_layer_0(tile_pos)
	set_walls()


func set_walls():
	# 第一次跳过
	if !layer_0_wall or !layer_0 or \
	 !is_instance_valid(layer_0_wall) or !is_instance_valid(layer_0):
		return
	
	# 清空所有空气墙
	layer_0_wall.clear()
	
	var floor_tiles = layer_0.get_used_cells()  # 获取所有地板图块
	var wall_positions = []  # 存储需要放置墙的位置
	
	for tile_pos in floor_tiles:
		var surrounding_cells = layer_0.get_surrounding_cells(tile_pos)
		
		for neighbor_pos in surrounding_cells:
			# 如果这个位置没有地板，也没有墙，加入墙位置列表
			if not layer_0.get_used_cells().has(neighbor_pos) and \
			   not wall_positions.has(neighbor_pos):
				wall_positions.append(neighbor_pos)
	
	# 放置空气墙
	for wall_pos in wall_positions:
		layer_0_wall.set_cell(wall_pos, 0, Vector2(0, 0))


func _on_layer_0_changed() -> void:
	set_walls()
