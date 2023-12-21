extends VBoxContainer

var scenes: Dictionary = {
	# TODO: this doesn't work with error 31
	# https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#class-globalscope-constant-err-invalid-parameter
	"Day 10": preload("res://scenes/day-10/day_10.tscn").instantiate(),
	"Day 10 - Bezier point": preload("res://scenes/day-10/bezier_point.tscn").instantiate(),
	"Day 10 - Bezier test": preload("res://scenes/day-10/bezier_test.tscn").instantiate(),
	"Day 18 (no visualisation yet, see console)": preload("res://scenes/day-18/day_18.tscn").instantiate(),
	#	"Day 10": "res://day-10/day_10.tscn",
}


func _button_pressed(scene_name: String):
	print("Switching scene to %s" % scene_name)

	# TODO: this doesn't work with error 31
	# https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#class-globalscope-constant-err-invalid-parameter
#	var err = get_tree().change_scene_to_packed(scenes[name])
#	print(err)

	self.visible = false
	%Scenes.add_child(scenes[scene_name])


func _ready():
	for scene_name in scenes:
		var button = Button.new()
		button.text = scene_name
		button.pressed.connect(Callable(self._button_pressed).bind(scene_name))
		self.add_child(button)
