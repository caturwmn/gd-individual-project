extends CharacterBody2D

@export var speed: float = 200.0
@export var acceleration: float = 4.0
@export var mouse_sensitivity: float = 0.3
@export var health: float = 100

@onready var head: Sprite2D = $Head
@onready var leg: Sprite2D = $Legs
@onready var spark: Node2D = $Legs/Spark
@onready var spark2: Node2D = $Legs/Spark2

var current_rotation: Vector2 = Vector2.RIGHT

func _ready():
	if GameState.selected_main_weapon:
		var weapon = GameState.selected_main_weapon.instantiate()
		$MainWeapon.add_child(weapon)

func _physics_process(delta):
	# Slowly rotate to mouse
	var target_angle = (get_global_mouse_position() - global_position).angle()
	rotation = lerp_angle(rotation, target_angle, 4 * delta)
	
	# Rotate head to mouse
	head.global_rotation = target_angle + Vector2.UP.angle()
	
	# Enable move effects
	if velocity.length() > 20:
		spark.get_node("GPUParticles2D").emitting = true
		spark2.get_node("GPUParticles2D").emitting = true
	else:
		spark.get_node("GPUParticles2D").emitting = false
		spark2.get_node("GPUParticles2D").emitting = false

	# Move	
	var movement_vector = Vector2.ZERO

	if Input.is_action_pressed("movement_up"):
		movement_vector += Vector2.UP
	if Input.is_action_pressed("movement_down"):
		movement_vector += Vector2.DOWN
	if Input.is_action_pressed("movement_left"):
		movement_vector += Vector2.LEFT
	if Input.is_action_pressed("movement_right"):
		movement_vector += Vector2.RIGHT

	movement_vector = movement_vector.normalized()
	
	if movement_vector.length() > 0:
		current_rotation = current_rotation.slerp(movement_vector, 6 * delta).normalized()
	_adjust_leg_rotation(current_rotation, leg)
	velocity = velocity.lerp(movement_vector * speed, acceleration * delta)

	move_and_slide()
	
func _adjust_leg_rotation(movement_vector: Vector2, legs: Sprite2D):
	if movement_vector.length() > 0:
		legs.global_rotation = movement_vector.angle() + Vector2.UP.angle()
		
func take_damage(amount: float):
	health -= amount

	if health <= 0:
		die()
		
func die():
	queue_free()
	
	
