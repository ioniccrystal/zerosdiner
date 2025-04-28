class_name Interactible extends Area2D
@export var actions : Array[InteractAction]

func _on_interact(_interact_area : InteractArea):
	pass


func _on_connected(_interact_area : InteractArea):
	pass


func _on_disconnected(_interact_area : InteractArea):
	pass

func get_actions(_interactor : InventoryInteractor) -> Array[InteractAction]:
	return actions

## 在子类补充
func interact(_interactor : InventoryInteractor, _action_index : int = 0):
	pass
