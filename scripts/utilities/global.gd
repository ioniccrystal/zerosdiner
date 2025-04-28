extends Node
#存储常用资源

@onready var blackboard:Blackboard = load("res://resources/behaviour_tree/blackboard.tres")

@warning_ignore("unused_signal")
signal drop_ready
@warning_ignore("unused_signal")
signal drop_picked
@warning_ignore("unused_signal")
signal map_block_item_changed(position,placing)#position为地图位置
@warning_ignore("unused_signal")
signal map_plant_item_changed(position,placing)#position为地图位置
@warning_ignore("unused_signal")
signal map_layer_0_changed
