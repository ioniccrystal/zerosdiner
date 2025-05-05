extends Node
#管理光标操作


const CURSOR_NORMAL = preload("res://gui/cursors/cursor_normal.tres")
const CURSOR_HAND = preload("res://gui/cursors/cursor_hand.tres")

var current_cursor = CURSOR_NORMAL
var is_holding := false
var held_mouse_position := Vector2.ZERO

@onready var progress: TextureProgressBar = $Progress


func _ready():
	var main_viewport = get_tree().root.get_viewport()
	# 连接根视口的 size_changed 信号
	main_viewport.connect("size_changed",_on_size_changed)
	# 初始化光标样式
	set_cursor_texture(CURSOR_NORMAL)
	# 初始化时更新一次光标尺寸
	update_cursor_size()

func _process(_delta: float) -> void:
	if is_holding:
		progress.value = progress.max_value - _crafting.time

func _on_size_changed():
	# 当 Viewport 大小发生变化时，更新光标
	update_cursor_size()


func set_cursor_texture(cursor):
	current_cursor = cursor
	update_cursor_size()


func update_cursor_size():
	# 使用 Viewport 的缩放变换来获取缩放比例
	var window_scale = get_window_scale()
	var image = current_cursor.get_image()
	image.resize(image.get_width() * window_scale.x, image.get_height() * window_scale.y, Image.INTERPOLATE_NEAREST)
	var scaled_texture = ImageTexture.create_from_image(image)
	Input.set_custom_mouse_cursor(scaled_texture, Input.CURSOR_ARROW)


func get_window_scale() -> Vector2:
	# 获取 Viewport 缩放变换矩阵
	var stretch_transform = get_viewport().get_stretch_transform()
	# 提取 X 和 Y 轴的缩放因子
	var window_scale = stretch_transform.get_scale()
	return window_scale


func start_holding(station : CraftStation):
	is_holding = true
	held_mouse_position = progress.get_global_mouse_position()
	progress.global_position = held_mouse_position - Vector2(5,5)
	progress.visible = true
	_set_crafting(station)


func stop_holding():
	is_holding = false
	progress.visible = false

## What station is this crafting from
var _station : CraftStation

## Crafting information (Time and recipe)
var _crafting : CraftStation.Crafting 

func _set_crafting(station : CraftStation):
	_station = station
	_crafting = station.craftings[0]
	var recipe_index = _crafting.recipe_index
	var recipe = station.database.recipes[recipe_index]
	progress.max_value = recipe.time_to_craft
