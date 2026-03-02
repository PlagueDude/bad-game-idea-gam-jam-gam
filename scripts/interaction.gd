extends Area2D

@export var timeline_name : String

func interact():
	print("INTERACT CALLED")
	if timeline_name != "":
		Dialogic.start(timeline_name)
