extends Sprite2D
 
@export var Lights : Array[Light]
 
var switch = false:
	set(value):
		switch = value
		set_counter(value)
		if value == true:
			on()
		else:
			off()
 
func interact():
	switch = not switch
 
func on():
	AudioController.play_ButtonClick()
	frame = 0
 
func off():
	AudioController.play_ButtonClick()
	frame = 1
 
func set_counter(value):
	for light in Lights:
		if value == true:
			%LeverManager.counter[light] += 1
		else:
			%LeverManager.counter[light] -= 1
 
	%LeverManager.light_lights()
