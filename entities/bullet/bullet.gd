extends CharacterBody2D

@export var SPEED = 300

func _ready():
	pass

func _physics_process(delta):
	var collisition = move_and_collide(Vector2.UP * SPEED * delta)
	
	if collisition:
		var collider = collisition.get_collider()
		
		if collider.has_method('destroy'):
			collider.destroy()
		
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
