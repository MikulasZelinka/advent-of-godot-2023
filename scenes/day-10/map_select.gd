extends OptionButton

signal map_changed(map_name)

func _ready():
	for map in %Map.maps:
		self.add_item(map)
	_on_item_selected(0)


func _on_item_selected(index):
	print("Emitting that map '%s' is now selected" % self.get_item_text(self.selected))
	map_changed.emit(self.get_item_text(self.selected))

