extends CharacterBody3D

# how fast the players moves in meters/second
@export var speed_player = 14
# the downward acceleration when in the air, meters/second^2
@export var little_g = 75

var vel_target = Vector3.ZERO

func _physics_process(delta):
	var dir = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		dir.x += 1
	if Input.is_action_pressed("move_left"):
		dir.x -= 1

	# in 3D the XZ plane is the ground plane
	# positive z direction is "out of the screen"
	if Input.is_action_pressed("move_back"):
		dir.z += 1
	# negative z direction is "into the screen"
	if Input.is_action_pressed("move_forward"):
		dir.z -= 1

	if dir != Vector3.ZERO:
		dir = dir.normalized()
		# setting the basis property will affect the rotation of the node
		$Pivot.basis = Basis.looking_at(dir)

	# ground velocity
	vel_target.x = dir.x * speed_player
	vel_target.z = dir.z * speed_player

	# vertical velocity
	if not is_on_floor():
		# if in the air, increase downward velocity according to gravity. Also allow for perfect XZ air control
		vel_target.y = vel_target.y - (little_g * delta)

	# update the velocity of the Player:CharacterBody3D object
	velocity = vel_target
	move_and_slide()
