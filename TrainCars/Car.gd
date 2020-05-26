extends Area2D

export var length = 0
var width = 30
var clickable = false
var consist_group = null # need a better name for this. Maybe Enclosing consist?
# set default mass to 1, no massless objects here
export var mass = 1
var velocity = 0
# get rid of acceleration since only consist will keep track of it
# var acceleration = 0

# Resize the train when its first brought into the scene and connect signals
func _ready():
	_set_polygon(length)
	connect("mouse_entered", self, '_toggle_click')
	connect("mouse_exited", self, '_toggle_click')
	connect("area_entered", self, '_on_collision')

# resizes the train car's polygons to use the specified car length
# an optional scale_multiplier can be provided to increase the dimensions of the car proportionally
func _set_polygon(new_car_length, scale_multiplier = 1):
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
	# add tight coupling to just call decouple method
	if clickable and Input.is_action_just_pressed("left_click"):
		consist_group.decouple(self)
		print("I've been clicked")
	# velocity += acceleration * delta
	position.y += velocity * delta

func _toggle_click():
	clickable = !clickable
	print('Clickable: ', clickable)

#add tight coupling to just call consists couple method
func _on_collision(object):
	#print(object)
	if object.get('consist_group'):
		print("I collided with another consist")
		print('Consist: ', consist_group, ' Attached Cars: ', consist_group.attached_cars, ' Processed: ' , consist_group.consist_collision_already_processed)
		print('Colliding Consist: ', object.consist_group, ' Colliding Attached Cars: ', object.consist_group.attached_cars, ' Colliding Processed: ', object.consist_group.consist_collision_already_processed)
		consist_group.couple(object.consist_group)
	else:
		print("I collided with something that's not a consist")
