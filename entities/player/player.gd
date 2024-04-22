extends CharacterBody2D

signal hit

@export var speed = 300
@export var max_speed = 500

var input_vector : Vector2

var rotation_direction : int
@export var rotation_speed := 3.5

@export var friction_weight := 0.05

const BULLET_SCENE = preload("res://entities/bullet/bullet.tscn")

var screen_size

func _ready():
	hide()
	screen_size = get_viewport_rect().size


func _physics_process(delta):
	input_vector.x = Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	rotation_direction = 0
	
	if Input.is_action_pressed("move_left"):
		rotation_direction += -1
	
	if Input.is_action_pressed("move_right"):
		rotation_direction += 1
	
	velocity += Vector2(input_vector.x * speed * delta, 0).rotated(rotation)
	
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
	
	if input_vector.x == 0 && velocity != Vector2.ZERO:
		velocity = lerp(velocity, Vector2.ZERO, friction_weight)
	
		if abs(velocity.x) <= 0.1:
			velocity.x = 0
			
		if abs(velocity.y) <= 0.1:
			velocity.y = 0
	
	rotation += rotation_direction * rotation_speed * delta	
	
	move_and_slide()
	
	position = position.clamp(Vector2.ZERO, screen_size)	
	


func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
func shot():
	var bullet = BULLET_SCENE.instantiate()
	bullet.global_position = global_position + Vector2(4, 0)
	add_child(bullet)

func get_direction():
	return position
