extends Node2D
 
var counter : Dictionary
var lights
 
func _ready():
	lights = %Lights.get_children()
	for light in lights:
		counter[light] = 0
 
func light_lights():
	for light in lights:
		if counter[light] % 2 == 1:
			light.set_light(true)
		else:
			light.set_light(false)
 
	for i in counter.values():
		if i % 2 == 0:
			close_door()
			return
	open_door()
 
func open_door():
	if owner.door != null:
		owner.door.open_door()
 
func close_door():
	if owner.door != null:
		owner.door.close_door()
