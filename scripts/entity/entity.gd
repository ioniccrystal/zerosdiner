# 实体基类，所有可移动对象的基础类，如玩家、妖异、顾客等，该类控制：导航移动、动画状态机、交互等
extends CharacterBody2D
class_name Entity


@export var profile: EntityProfile
# 移动相关的物理参数
var ACCELERATION = 2000   #加速度
var max_speed = 100   #最大速度
var FRICTION = 5000   #摩擦力

# 节点引用
@onready var tile_maps:Node2D = get_parent()
@onready var animation_tree: AnimationTree = %AnimationTree  # 动画树，用于控制动画状态
@onready var state_machine:AnimationNodeStateMachinePlayback = animation_tree["parameters/state_machine/playback"]  # 动画状态机
@onready var sprite: Sprite2D = %Sprite

# 输入向量，表示移动方向
var input_vector = Vector2.ZERO
# 默认的sprite偏移值
var default_sprite_offset : Vector2

func _ready() -> void:
	max_speed = profile.speed #速度先这样
	default_sprite_offset = sprite.offset

func _physics_process(_delta: float) -> void:
	# 获取当前位置的瓦片
	var current_tile_pos = tile_maps.layer_0.local_to_map(position)
	# 检查瓦片的自定义数据
	var tile_data = tile_maps.layer_0.get_cell_tile_data(current_tile_pos)
	
	if tile_data and tile_data.get_custom_data("lower"):
		# 如果是低洼地形，增加Y轴偏移
		sprite.offset = default_sprite_offset + Vector2(0, 8)
	else:
		# 恢复默认偏移
		sprite.offset = default_sprite_offset

# 更新动画混合位置，控制动画朝向
func update_blend_position(vector):
	# 将移动向量转换为等距视角的方向
	var isometric_vector = Vector2(
		(vector.x + vector.y) * 2,  # 左上右下轴，放大2倍
		(vector.y - vector.x)  # 右上左下轴
	).normalized()
	
	# 更新行走和待机动画的朝向
	animation_tree["parameters/state_machine/walk/blend_position"] = isometric_vector
	animation_tree["parameters/state_machine/idle/blend_position"] = isometric_vector
	animation_tree["parameters/state_machine/pick/blend_position"] = isometric_vector
