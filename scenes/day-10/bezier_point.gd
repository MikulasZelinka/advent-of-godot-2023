extends Node2D

@export var colour: Color
var selected = false


func _draw():
#	print(name, " - ", "global: ", global_position, " local: ", position)
	draw_circle(Vector2.ZERO, $CollisionShape2D.shape.radius * $CollisionShape2D.scale.x, colour)


func _process(_delta):
	if selected:
		global_position = get_global_mouse_position()
		queue_redraw()


func _on_input_event(_viewport, event, _shape_idx):
#	print(event)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		selected = event.pressed
