extends Area2D
@export var speed: float = 150
@export var max_distance: float = 1000
@export var damage: float = 35
@export var hit_effect: PackedScene
@export var homing: float = 30
var intial_direction: Vector2
var velocity
var target: Node2D = null
var start_position

func _ready():
	start_position = global_position
	if velocity == null:
		velocity = intial_direction.normalized() * speed

func _physics_process(delta):
	if target:
		var target_direction = (target.global_position - global_position).normalized() * speed
		var steering = (target_direction - velocity) * homing * delta
		velocity += steering
	
	# Apply movement and rotate the sprite to look where it is flying
	global_position += velocity * delta
	rotation = velocity.angle()
	
	# Check distance traveled
	if global_position.distance_to(start_position) > max_distance:
		queue_free()

func spawn_hit_effect():
	if hit_effect == null:
		return

	var effect: GPUParticles2D = hit_effect.instantiate()
	effect.scale = Vector2(5.0, 5.0)
	effect.global_position = global_position
	effect.global_rotation = rotation

	get_tree().current_scene.add_child(effect)

	# Start emitting
	var particles = effect.get_node("GPUParticles2D")
	particles.emitting = true

func _on_body_entered(body):
	if (body.name != "Player") and (body.name != "Missile"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		spawn_hit_effect()
		queue_free()
