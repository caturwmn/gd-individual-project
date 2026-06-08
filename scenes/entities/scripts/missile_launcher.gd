extends  Node2D
@export var bullet_scene: PackedScene
@export var fire_rate: float = 5

var targets: Array[Node2D] = []
var can_shoot = true

func _process(delta):
	look_at(get_global_mouse_position())

	if Input.is_action_pressed("launch_missile") and can_shoot:
		shoot()

func shoot():
	can_shoot = false
	var missile
	for i in range(targets.size()):
		missile = bullet_scene.instantiate()
		missile.target = targets.get(i)
		missile.global_position = $Muzzle.global_position
		var aim_angle = (targets.get(i).global_position - missile.global_position)
		missile.intial_direction = aim_angle
		get_tree().current_scene.add_child(missile)

	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != null:
		if body.has_method("locked"):
			body.locked(true)
		targets.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body != null:
		if targets.has(body):
			if body.has_method("locked"):
				body.locked(false)
			targets.erase(body)
