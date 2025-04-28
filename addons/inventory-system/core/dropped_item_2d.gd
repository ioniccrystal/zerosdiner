@icon("res://addons/inventory-system/icons/dropped_item_2d.svg")
extends Area2D
class_name DroppedItem2D

@export var item : SlotItem
@export var is_pickable := true
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready():
	#设置物品
	if item:
		sprite.texture = item.definition.icon

	#准备好了
	Global.drop_ready.emit()


#func interact(interactor : InventoryInteractor, _action_index : int = 0):
	#interactor.inventory_handler.pick_to_inventory(self)
	#if interactor is TransportComponent:
		#var transport = interactor
		#if transport and transport.inventory.slot_list.size() < transport.inventory.volume:
			## 创建新的物品槽
			#var new_slot = SlotItem.new()
			#new_slot.difinition = item
#
			#transport.on_item_slot_picked_up(new_slot)
			#queue_free()

##在InventoryHandler中有调用
func on_pick_up():
	Global.drop_picked.emit()
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is PlayerInteractArea:
		area.inventory_handler.pick_to_inventory(self)
		area.entity.pick_animation(item)
