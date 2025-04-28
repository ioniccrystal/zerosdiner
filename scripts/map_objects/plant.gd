extends Interactible
class_name Plant

@export var item_list:Array[SlotItem]
@export var drop_item_scene:PackedScene


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
	for item in item_list:
		drop_item(item)
	$AnimatedSprite2D.play()
