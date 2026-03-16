extends Node2D

@export var door : Sprite2D
@export var order : Array[int]

var stack = []

func push_order(value):
	stack.push_back(value)
	if stack.size() > 4:
		stack.pop_front()
	print(stack)
	
	if door == null:
		return
	
	if stack == order:
		door.open_door()
		print("OPEN SAYS ME")
	#else:
		#door.close_door()
