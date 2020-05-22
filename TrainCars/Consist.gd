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
	train_car.connect('decouple', self, 'decouple')
	print('connected', train_car, ' to ', self)
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
func accelerate(engine_force, brake_force = 0):
	body_acceleration = engine_force/total_mass
	if body_velocity > 0:
		body_acceleration -= brake_force/total_mass
	else:
		body_acceleration += brake_force/total_mass
#	#print(body_acceleration)
#	var current_node = head
#	while current_node != null:
#		current_node.acceleration = body_acceleration
#		current_node = current_node.next_car

func brake(force):
	if body_velocity > 0:
		body_acceleration = -force/total_mass
	else:
		body_acceleration = force/total_mass
#	var current_node = head
#	while current_node != null:
#		current_node.acceleration = body_acceleration
#		current_node = current_node.next_car

# apply the consist body velocity to all the cars in it
func _process(delta):
	if head == null:
		queue_free()
	else:
		body_velocity += body_acceleration * delta
		#print(body_velocity)
		var current_car = head
		while current_car != null:
			current_car.velocity = body_velocity
			current_car = current_car.next_car

func decouple(target_car):
	if target_car == head:
		return
	else:
		var current_car = head
		var new_mass = 0
		while current_car != target_car:
			new_mass += current_car.mass
			current_car = current_car.next_car
		# once target is found
		var new_consist = consist_scene.new()
		print(new_consist)
		
		#new_consist.total_mass = total_mass - new_mass
		new_consist.body_velocity = body_velocity
		total_mass = new_mass
		get_parent().add_child(new_consist)
		#current_car = new_consist.head
		while current_car != null:
			current_car.disconnect('decouple', self, 'decouple')
			new_consist.add_car(current_car)
			current_car = current_car.next_car
#			current_car.consist_group = new_consist
#			current_car = current_car.next_car
#			print('test')
			#current_car.connect('decouple', new_consist, 'decouple')
		tail = target_car.previous_car
		# remove link between new consist head and the car before the target car
		target_car.previous_car.next_car = null
		target_car.previous_car = null
		
