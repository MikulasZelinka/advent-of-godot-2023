extends VBoxContainer

var scenes: Dictionary = {
	# TODO: this doesn't work with error 31
	# https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#class-globalscope-constant-err-invalid-parameter
	"Day 10": preload("res://scenes/day-10/day_10.tscn").instantiate(),
	"Day 10 – Bezier point": preload("res://scenes/day-10/bezier_point.tscn").instantiate(),	
	"Day 10 – Bezier test": preload("res://scenes/day-10/bezier_test.tscn").instantiate(),
	

#	"Day 10": "res://day-10/day_10.tscn",

}

func _button_pressed(name: String):
	print("Switching scene to %s" % name)
	
	# TODO: this doesn't work with error 31
	# https://docs.godotengine.org/en/stable/classes/class_%40globalscope.html#class-globalscope-constant-err-invalid-parameter
#	var err = get_tree().change_scene_to_packed(scenes[name])
#	print(err)

	self.visible = false
	%Scenes.add_child(scenes[name])
	

func _ready():
	for name in scenes:
		
		var button = Button.new()
		button.text = name
		button.pressed.connect(Callable(self._button_pressed).bind(name))
		self.add_child(button)
			
