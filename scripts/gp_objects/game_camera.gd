extends Camera3D

@export var should_position: Vector3 = Vector3.ZERO
@export var follow_speed: float = 1
@export var camera_acceleration: float = 1

@export var should_rotation: Vector3
@export var r_follow_speed: float = 1
@export var r_camera_acceleration: float = 1
var speed = 0
var rotation_speed = 0

func _process(delta: float) -> void:
	speed = move_toward(speed, clamp(self.position.distance_to(should_position) * 2, 0.1, follow_speed), delta * camera_acceleration)
	rotation_speed = move_toward(speed, clamp(self.rotation.distance_to(should_rotation) * 1.32, 0.1, r_follow_speed), delta * r_camera_acceleration)
	self.position = self.position.move_toward(should_position, speed * delta)
	self.rotation = self.rotation.move_toward(should_rotation, rotation_speed * delta)
