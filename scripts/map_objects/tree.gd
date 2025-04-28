extends Interactible
class_name TreePlant

@export var item_list:Array[SlotItem]
@export var drop_item_scene:PackedScene

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func drop_item(item):
	# 创建掉落物实例
	var drop = drop_item_scene.instantiate()
	drop.item = item
	
	# 在8x8的范围内随机偏移
	var random_offset = Vector2(
		randf_range(-4, 4),
		randf_range(-4, 4)
	)
	
	# 设置掉落物位置为植物当前位置加上随机偏移
	drop.global_position = global_position + random_offset
	
	# 将掉落物添加到场景中
	get_parent().get_parent().add_child(drop)


func _on_animated_sprite_2d_animation_finished() -> void:
	#drop_item()
	#play()
	pass # Replace with function body.

func interact(_interactor : InventoryInteractor, _action_index : int = 0):
	for item in item_list:
		drop_item(item)
	animated_sprite_2d.frame = 0
	animated_sprite_2d.play()


func _on_animated_sprite_2d_frame_changed() -> void:
	var frame_count = animated_sprite_2d.sprite_frames.get_frame_count("default")
	collision_shape_2d.disabled = !(animated_sprite_2d.frame == frame_count - 1)
