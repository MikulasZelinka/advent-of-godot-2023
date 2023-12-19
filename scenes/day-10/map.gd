extends Node2D


const valid_neighbours = {
	# UP
	[-1, 0]: {"7": null, "|": null, "F": null},
	# DOWN
	[1, 0]: {"J": null, "|": null, "L": null},
	# LEFT
	[0, -1]: {"L": null, "-": null, "F": null},
	# RIGHT
	[0, 1]: {"J": null, "-": null, "7": null},
	
}

const maps = [
	"example1",
	"example2",
	"example3",
	"example4",
	"example5",
	"input",
]

var coords_to_char: Dictionary;
var pipe_path: Dictionary;

func on_map_change(map_name: String):
	
	var result = part1("res://assets/day-10/%s.txt" % map_name)
	
	coords_to_char = result[0]
	pipe_path = result[1]
	
	queue_redraw()


func _ready():
	
	%MapSelect.map_changed.connect(on_map_change)
	
#	assert(part1("res://assets/example1.txt")[2] == 4)
#	assert(part1("res://assets/example2.txt")[2] == 8)
#	print(part1("res://assets/input.txt")[2])
#
#	assert(part2("res://assets/example3.txt") == 4)
#	assert(part2("res://assets/example4.txt") == 8)
#	assert(part2("res://assets/example5.txt") == 10)
#	print(part2("res://assets/input.txt"))

#	var result = part1("res://assets/example2.txt")
#	coords_to_char = result[0]
#	pipe_path = result[1]


func _draw():
	
#	draw_string(SystemFont.new(), Vector2(100, 100), str(pipe_path))
	
#	if not pipe_path:
#		return
	
	var keys = pipe_path.keys()
	
	var window_size = get_viewport().get_visible_rect().size[1]
#	window_size = window_size[window_size.min_axis_index()]
	
	var max_map_size = 0
	for pos in keys:
		if pos.max() > max_map_size:
			max_map_size = pos.max()
#	var max_map_size = keys.max().max()
	
	var scale_factor = window_size / max_map_size
	
	print("Scale factor %s" % scale_factor)
	
	for i in range(len(keys)):
#		print(i)
#		print(keys)
		var j = i + 1 if i < len(keys) - 1 else 0
		draw_line(Vector2(keys[i][0], keys[i][1]) * scale_factor, Vector2(keys[j][0], keys[j][1]) * scale_factor, Color.AQUA)
		

func read_file(file_path):
	# https://docs.godotengine.org/en/stable/classes/class_fileaccess.html
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = file.get_as_text()
	return content


func map_str_to_dict(map: String):
	var lines = map.split("\n", false)
#	print(lines)
	
	var starting_position = [0, 0]
	
	var coords_to_char = {}
	
	var row = 1
	for line in lines:
		var col = 1
		for c in line:
			coords_to_char[[row, col]] = c
			
			if c == "S":
				starting_position = [row, col]
			
			col += 1
		row += 1
	
	assert(starting_position != [0, 0])
	return [coords_to_char, starting_position]
			
		
	


#func can_move_from_to_target(from: Array, to: Array, map: Dictionary):
#	return valid_neighbours[from - to].has()

func part1(file_path):
	var map_str = read_file(file_path)
	
	var coords_to_char_starting_position = map_str_to_dict(map_str)
	var coords_to_char = coords_to_char_starting_position[0]
	var starting_position = coords_to_char_starting_position[1]
	
	var last = starting_position
	var last_char = "S"
	
	var valid_starts = []
	
	for dir in valid_neighbours.keys():
		var next = [last[0] + dir[0], last[1] + dir[1]]
		var next_char = coords_to_char.get(next)
		
		if next_char == null:
			continue
	
		if valid_neighbours.get(dir).has(next_char):
			valid_starts.append(next)
			
	
#	print(coords_to_char)
#	print(starting_position)
#
#	print(valid_starts)
	assert(len(valid_starts) == 2)
	
	last = valid_starts[0]
	last_char = coords_to_char[last]
	var end = valid_starts[1]
	
	var pipe_path = {starting_position: null, last: null}
	
	while last != end:
		for dir in valid_neighbours.keys():
			var next = [last[0] + dir[0], last[1] + dir[1]]
			var next_char = coords_to_char.get(next)
			
			if pipe_path.has(next) or next_char == null:
				continue
		
			if valid_neighbours.get(dir).has(next_char) and valid_neighbours.get([-dir[0], -dir[1]]).has(last_char):
				last = next
				last_char = coords_to_char[last]
#				print(next, next_char)
				pipe_path[last] = null
#				print(pipe_path)
	
#	print(len(pipe_path), pipe_path)
	
	return [coords_to_char, pipe_path, len(pipe_path) / 2]
	
func part2(file_path):
	var part1_results = part1(file_path)
	var coords_to_char = part1_results[0]
	var pipe_path = part1_results[1]
	
	
	var dimensions = coords_to_char.keys().max()
#	print("coords to char: ", coords_to_char)
#	print(dimensions)
#	print("pipe path: ", pipe_path.keys())
	
	var rows = dimensions[0]
	var cols = dimensions[1]
	
	var num_inside_loop = 0
	
	for row in range(1, rows + 1):
		var inside_loop = false
		var start_corner = null
		
		# only add candidates if we encounter a pipe cell before the end of the line
		var num_candidates = 0
		
		for col in range(1, cols + 1):
			var current_position = [row, col]
			
			
			var char = coords_to_char.get(current_position)
			
			if inside_loop and !pipe_path.has(current_position):
#				print(current_position, ": ", char)
				num_candidates += 1
				continue
			
			if !pipe_path.has(current_position):
				# we can simply ignore pipes that aren't a part of the loop
				continue
			else:
				num_inside_loop += num_candidates
				num_candidates = 0
				
			match char:
				"|":
					inside_loop = not inside_loop
				"F", "L":
					start_corner = char
				"7":
					if start_corner == "L":
						inside_loop = not inside_loop
				"J":
					if start_corner == "F":
						inside_loop = not inside_loop
					
				
	
	return num_inside_loop
