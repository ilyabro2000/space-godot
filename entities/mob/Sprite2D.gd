extends Sprite2D

const textures = [
	preload("res://art/mob/1.svg"),
	preload("res://art/mob/2.svg"),
	preload("res://art/mob/3.svg"),
	preload("res://art/mob/4.svg"),
	preload("res://art/mob/5.svg"),
	preload("res://art/mob/6.svg"),
]

func _ready():
	self.texture = (textures[randi() % textures.size()])
