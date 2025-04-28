class_name ValueReference extends Resource

@warning_ignore("unused_signal")
signal on_value_changed(old, new)

var value :
	get:
		_getter()
	set(v):
		_setter(v)

func _getter():
	pass

func _setter(_v):
	pass
