extends Node

class_name Consist
var total_mass = 0
var body_velocity = 0
var offset = 10
var consist_scene = get_script()
var attached_cars = []
var consist_collision_already_processed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Append car to train car array and set its consist variable to this consist
func add_car(train_car):
	train_car.consist_group = self
	total_mass += train_car.mass
	if attached_cars.size() > 0:
		var tail_car = attached_cars[-1]
		# calculate position of new train car relative to the previous train car
		train_car.position.y = tail_car.position.y + tail_car.length/2 + offset + train_car.length/2
	attached_cars.append(train_car)

# Calculate the body's velocity from an applied force
# and then apply the velocity to all the cars in this consist
func apply_force(delta, engine_force, brake_force = 0):
	# calculate acceleration first
	# engine acceleration and brake acceleration are added together
	var acceleration = engine_force/total_mass + -1 * sign(body_velocity) * brake_force / total_mass
	# calculate velocity
	body_velocity += acceleration * delta
	# loop and set the velocities
	for car in attached_cars:
		car.velocity = body_velocity

# Decouples a new consist of cars beginning at the target car passed in
func decouple(target_car):
	# if the target car is the head car, do nothing
	if target_car == attached_cars[0]:
		return
	else:
		var new_consist = consist_scene.new()
		# find the target car in the array
		var target_index = attached_cars.find(target_car)
		
		# add the the target car and all cars that come after it to the new consist
		for i in range(target_index, attached_cars.size()):
			new_consist.add_car(attached_cars[i])
		# the new consist retains any velocity it had while attached to this one
		new_consist.body_velocity = body_velocity
		
		# set attached_cars to an array slice that excludes all decoupled cars
		attached_cars = attached_cars.slice(0, target_index-1)
		
		# subtract the new consist's mass from the total mass
		total_mass -= new_consist.total_mass
		get_parent().add_child(new_consist)

# Couples a consist of cars (min size 1) together
# This method is called when a collision happens so it will always be called twice
# However, 
func couple(colliding_consist):
	# two ways to check if its been processed
	# if the consist calling this method is equal to the colliding one, that means
	# they've already been combined
	if self == colliding_consist:
		return
	# otherwise you can use a variable thats toggled for the colliding consist by
	# this consist
	if consist_collision_already_processed:
		print("I, " , self, " have already been processed\n")
		consist_collision_already_processed = false
	else:
		print("I, " , self, " called this function first\n")
		colliding_consist.consist_collision_already_processed = true

		var front_consist
		var back_consist
		# check positions of first car in consists to determine the consists' positions
		var this_consist_head = attached_cars[0]
		var colliding_consist_head = colliding_consist.attached_cars[0]
		# logic here will be slightly different when on paths
		# since it'll be checking offsets and path nodes instead of position.y
		if this_consist_head.position.y < colliding_consist_head.position.y:
			front_consist = self
			back_consist = colliding_consist
		else:
			front_consist = colliding_consist
			back_consist = self
		print('checkpoint 1')
		print('The front consist is ', front_consist, ' which contains ', front_consist.attached_cars)
		print('The back consist is ', back_consist, ' which contains ', back_consist.attached_cars, '\n')
		
		# Add all the train cars from the back_consist to the front consist
		for car in back_consist.attached_cars:
			front_consist.add_car(car)
		# Clear the back consist of its attached cars and queue_free it
		back_consist.attached_cars = []
		back_consist.queue_free()
		print('method finished\n')
