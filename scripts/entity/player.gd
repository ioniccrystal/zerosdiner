extends Entity
class_name Player


@export var character_inventory_system: CharacterInventorySystem

# 物理更新函数，处理玩家移动
func _physics_process(delta):
	super._physics_process(delta)
	if InventorySystem.crafter.is_open_any_station() or InventorySystem.inventory_handler.is_open_main_inventory():
		return
	if input_vector != Vector2.ZERO:
		# 更新动画朝向
		update_blend_position(input_vector)
		# 计算目标速度和位置
		var target_velocity = input_vector * max_speed
		var target_position = global_position + target_velocity * delta
		
		# 检查目标位置是否在可行走区域内
		var target_tile = tile_maps.layer_0.local_to_map(target_position)
		if tile_maps.layer_0.get_used_cells().has(target_tile):
			# 如果目标位置可行走，则进行移动
			velocity = velocity.move_toward(target_velocity, ACCELERATION * delta)
			move_and_slide()
		else:
			# 如果目标位置不可行走，则停止移动
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	else:
		# 没有输入时，逐渐停止移动
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

# 处理键盘输入
func _unhandled_input(_event: InputEvent) -> void:
	# 获取原始输入向量
	var raw_input = Input.get_vector("left_move","right_move","forward_move","back_move")
	
	# 转换为等距方向
	# 上 = 东北(NE)，右 = 东南(SE)，下 = 西南(SW)，左 = 西北(NW)
	input_vector = Vector2(
		raw_input.x - raw_input.y,  # x轴：右移 + 左移 - 上移 - 下移
		(raw_input.x + raw_input.y) * 0.5  # y轴：(右移 + 左移 + 上移 + 下移) / 2
	)
	
	# 标准化向量，确保各个方向速度一致
	input_vector = input_vector.normalized()

func pick_animation(item:SlotItem):
	state_machine.travel("pick")
	var sprite_new = Sprite2D.new()
	sprite_new.z_index = 1000
	sprite_new.texture = item.definition.icon
	sprite_new.position = Vector2(0, -32)
	add_child(sprite_new)
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite_new,"position",Vector2(0,-48),0.5)
	tween.tween_property(sprite_new,"modulate",Color.TRANSPARENT,0.5)
	await tween.finished
	sprite_new.queue_free()
