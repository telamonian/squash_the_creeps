extends Node

@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mob_timer_timeout():
	# create a new instance of the Mob scene
	var mob = mob_scene.instantiate()

	# choose a random location on the SpawnPath
	# get a ref to the SpawnLocation node
	var loc_mob_spawn = get_node("SpawnPath/SpawnLocation")
	# give it a random offset
	loc_mob_spawn.progress_ratio = randf()

	#loc_mob_spawn.position.y -= 1
	var pos_player = $Player.position
	mob.init(loc_mob_spawn.position, pos_player)

	# spawn the mob by adding it to the main scene
	add_child(mob)
