extends Node

class_name Consist
var head = null
var tail = null
var total_mass = 0
var body_acceleration = 0
var body_velocity = 0
var offset = 10
var consist_scene = get_script()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# adds a car to the consist similar to adding a node to a linked list
func add_car(train_car):
	if head == null:
		head = train_car
	else:
		tail.next_car = train_car
		train_car.previous_car = tail
		# this can be modified so that it only uses length/2 + offset to give 
		# this car a position relative to the tail on a path node
		train_car.position.y = tail.position.y + tail.length/2 + offset + train_car.length/2
	train_car.consist_group = self
	tail = train_car
	total_mass += train_car.mass
	# might need to connect the decouple signal here

# accelerate is called by locomotives
func accelerate(force, delta):
	body_acceleration = force/total_mass
	print(body_acceleration)
	var current_node = head
	while current_node != null:
		current_node.acceleration = body_acceleration
		current_node = current_node.next_car

func brake(force, delta):
	if body_acceleration > 0:
		body_acceleration = -force/total_mass
	else:
		body_acceleration = force/total_mass
	var current_node = head
	while current_node != null:
		current_node.acceleration = body_acceleration
		current_node = current_node.next_car

func _process(delta):
	pass
#	if get_children().size() == 0:
#		queue_free()
#	if Input.is_action_pressed('ui_left'):
#		if velocity > 0:
#			calculate_speed(-bf)
#		else:
#			calculate_speed(bf)
#	#velocity += acceleration * delta
#	for train_car in get_children():
#		train_car.position.y += velocity * delta
	#position.y += velocity * delta
