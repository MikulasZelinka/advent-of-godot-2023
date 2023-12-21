extends Node2D


func _ready() -> void:
	assert(part1("res://assets/day-18/example.txt") == 62)
	print(part1("res://assets/day-18/input.txt"))

	assert(part1("res://assets/day-18/example.txt") == 952408144115)
	print(part2("res://assets/day-18/input.txt"))


func read_file(file_path):
	# https://docs.godotengine.org/en/stable/classes/class_fileaccess.html
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = file.get_as_text()
	return content


func map_str_to_dict(map: String):
	var lines = map.split("\n", false)
#	print(lines)

	# var row = 1
	# for line in lines:
	# 	var col = 1
	# 	for c in line:
	# 		coords_to_char[[row, col]] = c

	# 		if c == "S":
	# 			starting_position = [row, col]

	# 		col += 1
	# 	row += 1
	var row = 0
	var col = 0
	var starting_position = [row, col]
	var coords_to_char = {starting_position: "#"}

	# map string looks like:

	# R 6 (#70c710)
	# D 5 (#0dc571)
	# L 2 (#5713f0)
	# D 2 (#d2c081)
	# R 2 (#59c680)
	# D 2 (#411b91)
	# L 5 (#8ceee2)
	# U 2 (#caa173)
	# L 1 (#1b58a2)
	# U 2 (#caa171)
	# R 2 (#7807d2)
	# U 3 (#a77fa3)
	# L 2 (#015232)
	# U 2 (#7a21e3)

	# for each line, split, take direction and number, and add to coords_to_char

	const dirs_to_pipe = {
		"LU": "L",
		"LD": "F",
		"RU": "J",
		"RD": "7",
		"RR": "-",
		"LL": "-",
		"UU": "|",
		"DD": "|",
		"UL": "7",
		"UR": "F",
		"DL": "J",
		"DR": "L",
	}

	var expanded_instructions = []

	for line in lines:
		var split_line = line.split(" ", false)
		var direction = split_line[0]
		var number = int(split_line[1])
		# var color = split_line[2]

		for i in range(number):
			expanded_instructions.append(direction)

	expanded_instructions.append(expanded_instructions[0])

	for i in range(len(expanded_instructions) - 1):
		var from_dir = expanded_instructions[i]
		var to_dir = expanded_instructions[i + 1]

		var shape = dirs_to_pipe["%s%s" % [from_dir, to_dir]]

		match from_dir:
			"R":
				col += 1
			"L":
				col -= 1
			"U":
				row -= 1
			"D":
				row += 1

		coords_to_char[[row, col]] = shape

	# print("row, col: ", row, col)
	assert([row, col] == starting_position)
	# print(coords_to_char)
	return [coords_to_char, starting_position]


func part1(file_path):
	var map_str = read_file(file_path)

	var coords_to_char_starting_position = map_str_to_dict(map_str)
	var coords_to_char = coords_to_char_starting_position[0]
	var starting_position = coords_to_char_starting_position[1]

	# what is the minimum row and col in coords_to_char?
	var min_row = 0
	var min_col = 0

	var max_row = 0
	var max_col = 0

	for coords in coords_to_char.keys():
		if coords[0] < min_row:
			min_row = coords[0]
		elif coords[0] > max_row:
			max_row = coords[0]
		if coords[1] < min_col:
			min_col = coords[1]
		elif coords[1] > max_col:
			max_col = coords[1]
	print("min row: ", min_row, " min col: ", min_col)

	var num_inside_loop = 0

	for row in range(min_row - 1, max_row + 1):
		var inside_loop = false
		var start_corner = null

		# only add candidates if we encounter a pipe cell before the end of the line
		var num_candidates = 0

		for col in range(min_col - 1, max_col + 1):
			var current_position = [row, col]

			var char = coords_to_char.get(current_position)

			if inside_loop and !coords_to_char.has(current_position):
#				print(current_position, ": ", char)
				num_candidates += 1
				continue

			if !coords_to_char.has(current_position):
				# we can simply ignore pipes that aren't a part of the loop
				continue
			else:
				# trench counts too
				num_inside_loop += 1

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

	print(num_inside_loop)
	return num_inside_loop
