extends Node2D

var consist_struct = preload("res://TrainCars/Consist.gd")
var loco_scene = preload("res://TrainCars/Locomotive.tscn")
var cargo_scene = preload("res://TrainCars/Cargo.tscn")
var car_scene = preload("res://TrainCars/Car.tscn")
#var consists = []
var consist_a = null
var consist_b = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var my_consist = consist_struct.new()
	var my_loco = loco_scene.instance()
	add_child(my_consist)
	add_child(my_loco)
	my_loco.connect("couple", self, 'couple_consists')
	my_consist.add_car(my_loco)
	for i in range(3):
		var new_cargo = cargo_scene.instance()
		new_cargo.connect("couple", self, 'couple_consists')
		add_child(new_cargo)
		my_consist.add_car(new_cargo)
#	consists.append(my_consist)

#func couple_consists(train_car, consist_group):
#	print('combining', consist_group)
#	if consist_b == null:
#		consist_b = consist_group
#	else:
#		consist_a = consist_group
#		combine_consist()

#func combine_consist():
#	print(consist_a, ' attached to ', consist_b)
#	var current = consist_b.head
#	while current != null:
#		consist_a.add_car(current)
#		current = current.next_car
#	consist_b.head = null
#	consist_b.tail = null
#	consist_b = null
#	consist_a = null
