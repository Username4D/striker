extends Resource

class_name Player

var current_row = 0
var row_states = []

var row_types = [[6,5,4,3,2,1], [6,5,4,3,2,1], [6,5,4,3,2,1], [5,5,4,4,2,1], [5,5,4,3,3,1], [6,4,4,3,3,1]]

func add_row_state():
	var dict = {}
	var keys = ["red", "pink", "green", "black", "blue", "yellow"]
	var balance = row_types[randi_range(0, len(row_types) - 1)].duplicate()
	balance.shuffle()
	for i in range(0, len(keys)):
		dict[keys[i]] = DiceState.new(balance[i])
	dict.sort()
	print(dict)
	row_states.append(dict)

func _init() -> void:
	for i in range(0, 4):
		add_row_state()
