extends RigidBody2D

const textures = [
	preload("res://art/mob/1.svg"),
	preload("res://art/mob/2.svg"),
	preload("res://art/mob/3.svg"),
	preload("res://art/mob/4.svg"),
	preload("res://art/mob/5.svg"),
	preload("res://art/mob/6.svg"),
]

func _ready():
	$Sprite2D.texture = (textures[randi() % textures.size()])

signal mob_destroyed

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func destroy():
	mob_destroyed.emit()
	queue_free()
