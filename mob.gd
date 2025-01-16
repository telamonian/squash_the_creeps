extends CharacterBody3D

@export var speed_min = 10 # m/s
@export var speed_max = 18 # m/s
@export var little_g = 75

# this will be called from the Main scene
func init(pos_start, pos_player):
	# point the mob at the player to start
	look_at_from_position(pos_start, pos_player)

	# randomize start angle +-45 deg
	rotate_y(randf_range(-PI/4, PI/4))

	# get a velocity in the -z direction with a random magnitude
	var vel_target = Vector3.FORWARD * randi_range(speed_min, speed_max)

	# rotate the velocity
	vel_target = vel_target.rotated(Vector3.UP, rotation.y)

	# update the Mob's actual velocity
	velocity = vel_target

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()

func _physics_process(delta):
	# vertical velocity
	if not is_on_floor():
		# if in the air, increase downward velocity according to gravity. Also allow for perfect XZ air control
		velocity.y = velocity.y - (little_g * delta)

	move_and_slide()
