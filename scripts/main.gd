extends Node

@export var mob_scene: PackedScene
var score

func _ready():
	pass

func _process(delta):
	pass


func game_over():
	$MobTimer.stop()
	
	$HUD.show_game_over()

func new_game():
	score = 0
	$PLayer.start($StartPosition.position)
	$StartTimer.start()
	
	$HUD.show_message("Get Ready")
	
	get_tree().call_group("mobs", "queue_free")

func _on_start_timer_timeout():
	$MobTimer.start()


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	var direction = 1.2
	
	mob.position = mob_spawn_location.position

	var velocity = Vector2(randf_range(300.0, 400.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
