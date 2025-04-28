class_name ObjectPlacer2D
extends NodeInventorySystemBase

signal dropped
signal placed

@export var property_for_block_item : String = "设施"
@export var property_for_seed_item : String = "种子"
@export var drop_node_path : NodePath = "../../../.."
@onready var drop_node_parent : Node = get_node(drop_node_path)
@export_node_path("InventoryHandler") var inventory_handler_path := NodePath("../../InventoryHandler")
@onready var inventory_handler : InventoryHandler = get_node(inventory_handler_path)


func place_item(item : SlotItem, position : Vector2, rotation : bool):
	var id
	var tile_map
	if item.definition.properties.has(property_for_block_item):
		id = item.definition.properties[property_for_block_item]
		tile_map = drop_node_parent.block_layer
		Global.map_block_item_changed.emit(position,true)
	elif item.definition.properties.has(property_for_seed_item):
		id = item.definition.properties[property_for_seed_item]
		tile_map = drop_node_parent.plant_layer
		Global.map_plant_item_changed.emit(position,true)
	else:
		return
	# 使用ID放置
	for inventory in inventory_handler.inventories:
		if inventory.remove(item) <= 0:
			tile_map.set_cell(position, 2, Vector2i(0, 0), int(id))
