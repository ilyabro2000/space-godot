extends Node

@export var mob_scene: PackedScene
var score

@onready var player := $Player
@onready var lasers := $Lasers

func _ready():
	player.laser_shot.connect(_on_player_laser_shot)

func _on_player_laser_shot(laser):
	lasers.add_child(laser)

func game_over():
	$MobTimer.stop()
	
	$HUD.show_game_over()

func new_game():
	score = 0
	player.start($StartPosition.position)
	
	get_tree().call_group("mobs", "queue_free")

func _on_start_timer_timeout():
	$MobTimer.start()
