extends "res://TrainCars/Car.gd"
var engine_power = 500
var brake_power = 1000
var steam_pressure = 0
var exerted_force = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		exerted_force = -steam_pressure * engine_power
		steam_pressure = max(0, steam_pressure - 0.18 * delta)
	elif Input.is_action_pressed("ui_down"):
		exerted_force = steam_pressure * engine_power
		steam_pressure = max(0, steam_pressure - 0.18 * delta)
	else:
		exerted_force = 0
		steam_pressure = min(1, steam_pressure + 0.15 * delta)
	#print(steam_pressure)
	if Input.is_action_pressed("ui_left"):
		consist_group.accelerate(exerted_force, brake_power)
	else:
		consist_group.accelerate(exerted_force)

## Declare member variables here. Examples:
## var a = 2
## var b = "text"
#var engine_power = 400
#var brake_force = 800
#var force = engine_power
#var steam_pressure = 0
## signal kinematic_change
#signal apply_force
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass
#
#func _process(delta):
#	if Input.is_action_pressed("ui_up"):
#		#acceleration = (force/mass)
#		force = steam_pressure * engine_power
#		# 'expel steam'
#		steam_pressure = max(0, steam_pressure - 0.18 * delta)
#
#		emit_signal("apply_force", -force)
#	elif Input.is_action_pressed("ui_down"):
#		force = steam_pressure * engine_power
#		steam_pressure = max(0, steam_pressure - 0.18 * delta)
#		#acceleration = (-force/mass)
#		emit_signal("apply_force", force)
#	else:
#		acceleration = 0
#		steam_pressure = min(1, steam_pressure + 0.15 * delta)
#		emit_signal("apply_force", 0)
#	#print('steam pressure', steam_pressure)
#	#velocity += delta * acceleration
#	#position.y += velocity * delta
#	#emit_signal("kinematic_change", acceleration, velocity)
#	#emit_signal("apply_force", force)
