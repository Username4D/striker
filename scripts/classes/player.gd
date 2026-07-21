extends Resource

class_name Player

var current_row = 0
var row_states = []

var row_types = [[6,5,4,3,2,1], [6,5,4,3,2,1], [6,5,4,3,2,1], [5,5,4,4,2,1], [5,5,4,3,3,1], [6,4,4,3,3,1]]
var screen_position: int

var points: int = 0
var previous_points: int = 0
var bonus_points: int = 0
var bonus_amount: int = 0

func add_row_state():
	var dict = {}
	var keys = ["red", "pink", "green", "black", "blue", "yellow"]
	var balance = row_types[randi_range(0, len(row_types) - 1)].duplicate()
	balance.shuffle()
	for i in range(0, len(keys)):
		dict[keys[i]] = DiceState.new(balance[i])
	dict.sort()
	row_states.append(dict)

func _init(_screen_position) -> void:
	for i in range(0, 4):
		add_row_state()
	screen_position = _screen_position

func finish_round():
	previous_points = points
	const bonus_point_amounts = {0: 0, 1: 1, 2: 3, 3: 6, 4: 10, 5: 15, 6: 21}
	var perfect_items: int = 0
	for i in row_states[current_row]:
		points += row_states[current_row][i].set_value if row_states[current_row][i].set_value != -1 else 0
		if row_states[current_row][i].set_value == row_states[current_row][i].number: perfect_items += 1
		print([row_states[current_row][i].set_value,  row_states[current_row][i].number])
	points += bonus_point_amounts[perfect_items]
	bonus_amount = perfect_items
	bonus_points = bonus_point_amounts[perfect_items]
