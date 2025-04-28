extends Interactible
class_name BoxInventory

@onready var inventory : Inventory = $Inventory
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func get_inventory() -> Inventory:
	return $Inventory


func _on_inventory_closed():
	_on_close()


func _on_inventory_opened():
	_on_open()


func _on_open():
	animated_sprite_2d.play("open")


func _on_close():
	animated_sprite_2d.play("close")


func get_interaction_position(_interaction_point : Vector2) -> Vector2:
	return position


func get_actions(_interact_area : InventoryInteractor) -> Array[InteractAction]:
	if inventory.is_open:
		return []
	return actions


func interact(interactor : InventoryInteractor, _action_index : int = 0):
	interactor.get_parent().open_inventory(inventory)
