extends Entity
class_name Voidsent

@onready var nav_agent: NavigationAgent2D = %NavigationAgent2D
@onready var transport_component = $TransportComponent
@onready var timer = $Timer
@onready var voidsent_state_machine: FiniteStateMachine = %VoidsentStateMachine


func _physics_process(delta):
	super._physics_process(delta)
	# 导航移动
	if !nav_agent.is_navigation_finished():
		input_vector = position.direction_to(nav_agent.get_next_path_position())
		input_vector = input_vector.normalized()
		update_blend_position(input_vector)
		velocity = velocity.move_toward(input_vector * max_speed, ACCELERATION * delta)
		move_and_slide()
	else:
		velocity = velocity.move_toward(Vector2.ZERO , FRICTION * delta)


func go_to_map_position(map_position:Vector2i):
	nav_agent.target_position = tile_maps.layer_0.map_to_local(map_position)
