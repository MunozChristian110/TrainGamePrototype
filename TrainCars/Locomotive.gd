extends "res://TrainCars/Car.gd"
var engine_power = 1000
var brake_power = 1000
var steam_pressure = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var engine_force = 0
	if Input.is_action_pressed("ui_up"):
		engine_force = -steam_pressure * engine_power
		steam_pressure = max(0, steam_pressure - 0.18 * delta)
	elif Input.is_action_pressed("ui_down"):
		engine_force = steam_pressure * engine_power
		steam_pressure = max(0, steam_pressure - 0.18 * delta)
	else:
		engine_force = 0
		steam_pressure = min(1, steam_pressure + 0.15 * delta)
	#print(steam_pressure)
	if Input.is_action_pressed("ui_left"):
		consist_group.apply_force(delta, engine_force, brake_power)
	else:
		consist_group.apply_force(delta, engine_force)
