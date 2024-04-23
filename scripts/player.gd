extends CharacterBody2D

signal hit
signal laser_shot(lazer)

@export var acceleration := 300
@export var nitro_acceleration := 500
@export var max_speed := 700

var input_vector : Vector2

var rotation_direction : int
@export var rotation_speed := 5

@export var friction_weight := 0.02

@onready var mazzle = $Mazzle
@onready var shifts = { 
	'left': $ShiftLeft,
	'right': $ShiftRight
}

var LAZER_SCENE := preload("res://scenes/laser.tscn")

var shot_cd := false
var is_nitro_active := false

var current_acceleration = acceleration

func _ready():
	hide()

func _process(delta):
	if Input.is_action_pressed("shot"):
		if !shot_cd:
			shot_cd = true
			shot_laser()
			
			await get_tree().create_timer(0.1).timeout
			shot_cd = false

func _physics_process(delta: float):
	current_acceleration = acceleration
	
	if Input.is_action_pressed('shift'):
		current_acceleration = nitro_acceleration
		
	input_vector.y = Input.get_action_strength("move_up") - Input.get_action_strength("move_down")
	rotation_direction = 0

	if Input.is_action_pressed("move_left"):
		rotation_direction += -1
		
		if input_vector.y == 0:
			input_vector.y += 0.5
	
	if Input.is_action_pressed("move_right"):
		rotation_direction += 1
		
		if input_vector.y == 0:
			input_vector.y += 0.5
	
	velocity += Vector2(0, -input_vector.y * current_acceleration * delta).rotated(rotation)
	
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
	
	if (input_vector.x == 0 || input_vector.y == 0) && velocity != Vector2.ZERO:
		velocity = lerp(velocity, Vector2.ZERO, friction_weight)
	
		if abs(velocity.x) <= 0.1:
			velocity.x = 0
			
		if abs(velocity.y) <= 0.1:
			velocity.y = 0
	
	rotation += rotation_direction * rotation_speed * delta
	var speed_ratio := velocity.length() / max_speed
	
	for shift in shifts.values():
		var max_scale := 1.0
		var min_scale := 0.0
		var max_transform_y := 50.0
		var min_transform_y := 10.0
		
		shift.scale.y = lerp(
			min_scale,
			max_scale,
			speed_ratio
		)
		
		shift.position.y = lerp(
			min_transform_y,
			max_transform_y,
			speed_ratio
		)
		
		if shift.scale.y >= max_scale - 0.01:
			shift.scale.y = max_scale
	
		elif shift.scale.y <= min_scale + 0.05:
			shift.scale.y = min_scale
		
		if shift.position.y >= max_transform_y - 0.1:
			shift.position.y = max_transform_y
	
		elif shift.position.y <= min_transform_y + 1:
			shift.position.y = min_transform_y

	move_and_slide()



func shot_laser():
	var l = LAZER_SCENE.instantiate();
	l.global_position = mazzle.global_position
	l.rotation = rotation
	laser_shot.emit(l)

func _on_body_entered():
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func get_direction():
	return position


func _on_hit():
	pass # Replace with function body.
