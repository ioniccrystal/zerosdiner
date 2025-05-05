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
	match action_index:
		0:
			craft_station.input_inventories = interactor.inventory_handler.inventories
			craft_station.output_inventories = interactor.inventory_handler.inventories
			interactor.get_parent().open_station(craft_station)
		1:
			$Sprite2D.flip_h = !$Sprite2D.flip_h
		2:
			CursorManager.start_holding(craft_station)
			craft_station.can_processing_craftings = true
		
func interact_release(interactor : InventoryInteractor, action_index : int = 0):
	if action_index == 2:
		CursorManager.stop_holding()
		craft_station.can_processing_craftings = false
