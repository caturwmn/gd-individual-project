extends  Node2D
@export var bullet_scene: PackedScene
@export var fire_rate: float = 0.2
@export var bullet_speed: float
@export var max_distance: float
@export var damage: float

var can_shoot = true

func _process(delta):
	look_at(get_global_mouse_position())

	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()

func shoot():
	can_shoot = false

	var bullet = bullet_scene.instantiate()
	bullet.speed = bullet_speed
	bullet.max_distance = max_distance
	bullet.damage = damage
	
	bullet.global_position = $Muzzle.global_position
	
	var aim_angle = (get_global_mouse_position() - bullet.global_position).angle()
	bullet.rotation = aim_angle

	get_tree().current_scene.add_child(bullet)

	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
