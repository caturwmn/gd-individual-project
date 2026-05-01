extends Area2D
@export var speed: float = 500
@export var max_distance: float = 400
@export var damage: float = 10
@export var hit_effect: PackedScene

var start_position
func _ready():
	start_position = global_position

func _physics_process(delta):
	position += Vector2.RIGHT.rotated(rotation) * speed * delta
	
	# Check distance traveled
	if global_position.distance_to(start_position) > max_distance:
		queue_free()

func spawn_hit_effect():
	if hit_effect == null:
		return

	var effect = hit_effect.instantiate()
	effect.global_position = global_position
	effect.global_rotation = rotation

	get_tree().current_scene.add_child(effect)

	# Start emitting
	var particles = effect.get_node("GPUParticles2D")
	particles.emitting = true

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		
	spawn_hit_effect()
	queue_free()
