extends RigidBody3D

@export var cube_mesh: Mesh
@export var number = 0
signal thrown

func _ready() -> void:
	$Cube_001.mesh = cube_mesh

func throw():
	self.apply_central_impulse(Vector3(randf_range(-1,1), randf_range(3, 5), randf_range(-1, 1)))
	self.apply_torque_impulse(Vector3(randf_range(-.07, .07), randf_range(-.07, .07), randf_range(-.07, .07)))
	
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	while Vector3.ZERO.distance_to(linear_velocity) > 0.01 or Vector3.ZERO.distance_to(angular_velocity) > 0.01:
		await get_tree().physics_frame

	var floor_collider: Node
	var has_dice_collider: bool = false
	for i in $rays.get_children():
		if i.get_collider() != null:
			if i.get_collider().is_in_group("floor"):
				floor_collider = i
			elif i.get_collider().is_in_group("dice"):
				has_dice_collider = true
	
	if floor_collider and !has_dice_collider:
		$number.text = str(7 - int(floor_collider.name))
		$number.position = get_viewport().get_camera_3d().unproject_position(self.position)
		number = 7 - int(floor_collider.name)
		thrown.emit()
	else:
		throw()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		throw()
