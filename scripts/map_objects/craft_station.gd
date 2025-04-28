extends Interactible
class_name Worktable

@onready var craft_station : CraftStation = $CraftStation


func get_interaction_position(_interaction_point : Vector2) -> Vector2:
	return position


func get_actions(_interactor : InventoryInteractor) -> Array[InteractAction]:
	if craft_station.is_open:
		return []
	return actions


func interact(interactor : InventoryInteractor, action_index : int = 0):
	if action_index == 0:
		craft_station.input_inventories = interactor.inventory_handler.inventories
		craft_station.output_inventories = interactor.inventory_handler.inventories
		interactor.get_parent().open_station(craft_station)
	else:
		$Sprite2D.flip_h = !$Sprite2D.flip_h
