extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var particles = $GPUParticles2D
	await get_tree().create_timer(particles.lifetime).timeout
	queue_free()
