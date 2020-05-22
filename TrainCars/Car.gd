extends Area2D

signal decouple
signal couple
export var length = 0
var width = 30
var clickable = false
var consist_group = null
# set default mass to 1, no massless objects here
export var mass = 1
var velocity = 0
var acceleration = 0

# Car keeps track of previous and next cars as if it were a node in a linked list
var previous_car = null
var next_car = null


# Resize the train when its first brought into the scene and connect signals
func _ready():
	_resize(length)
	connect("mouse_entered", self, '_toggle_click')
	connect("mouse_exited", self, '_toggle_click')
	connect("area_entered", self, '_on_collision')

# resizes the train car's polygon to use the specified car length
# an optional scale_multiplier can be provided to increase the dimensions of the car proportionally
func _resize(new_car_length, scale_multiplier = 1):
	# create an empty polygon with no vertices
	var vertices = PoolVector2Array()
	# get the x and y offsets from 0,0
	var x_offset = (width * scale_multiplier)/2
	var y_offset = (new_car_length * scale_multiplier)/2
	# append the 4 vertices of the polygon, creating the train car shape
	vertices.append(Vector2(-x_offset, -y_offset))
	vertices.append(Vector2(x_offset, -y_offset))
	vertices.append(Vector2(x_offset, y_offset))
	vertices.append(Vector2(-x_offset, y_offset))
	$Polygon2D.polygon = vertices
	$CollisionPolygon2D.polygon = vertices

func _process(delta):
	if clickable and Input.is_action_just_pressed("left_click"):
		emit_signal('decouple', self)
		print("I've been clicked")
	# velocity += acceleration * delta
	position.y += velocity * delta

func _toggle_click():
	clickable = !clickable
	print('Clickable: ', clickable)

func _on_collision(object):
	#print(object)
	print(consist_group)
	emit_signal('couple', self, consist_group)
