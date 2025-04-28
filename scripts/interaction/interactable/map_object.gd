extends Interactible
class_name MapObject

@export var radius:float = 4.0

var label = AnimatedSprite2D.new()
var animation = load("res://resources/frames/press.tres")



func _ready():
	#设置碰撞体积
	var collision = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = radius
	collision.shape = circle
	add_child(collision)

	#设置可互动标签的位置
	label.sprite_frames = animation
	label.visible = false
	label.position.y = -20
	add_child(label)

# 追加显示E的功能
func _on_connected(interactor:InteractArea):
	if interactor is PlayerInteractArea:
		label.show()

func _on_disconnected(interactor:InteractArea):
	if interactor is PlayerInteractArea:
		label.hide()
