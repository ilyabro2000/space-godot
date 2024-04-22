extends RigidBody2D

signal mob_destroyed

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func destroy():
	mob_destroyed.emit()
	queue_free()
