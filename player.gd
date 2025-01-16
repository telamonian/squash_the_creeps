extends CharacterBody3D

# emitted when the player is hit by a mob
signal hit

# how fast the players moves in meters/second
@export var speed = 14
# the downward acceleration when in the air, meters/second^2
@export var little_g = 75
# the velocity applied to the character upon jumping in the +y direction, m/s
@export var vel_jump = 20
# the velocity applied to the character upon bouncing on a mob, m/s
@export var vel_bounce = 16

var vel_target = Vector3.ZERO

func die():
	hit.emit()
	queue_free()

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
	vel_target.x = dir.x * speed
	vel_target.z = dir.z * speed

	# vertical velocity
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			vel_target.y = vel_jump
	else:
		# if in the air, increase downward velocity according to gravity. Also allow for perfect XZ air control
		vel_target.y = vel_target.y - (little_g * delta)

	# iterate through all collisions that occurred this frame
	for i in range(get_slide_collision_count()):
		# get the ith player collision
		var collision = get_slide_collision(i)

		# if the collision is with ground
		if collision.get_collider() == null:
			continue

		# if the collision is with a mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			# check that collision is from above
			if Vector3.UP.dot(collision.get_normal()) > .1:
				# if so, squash the mob and bounce
				mob.squash()
				vel_target.y = vel_bounce
				# prevent further duplicate calls
				break

	# update the velocity of the Player:CharacterBody3D object
	velocity = vel_target
	move_and_slide()

func _on_mob_detector_body_entered(body):
	die()
