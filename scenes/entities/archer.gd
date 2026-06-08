extends CharacterBody2D

@export var bullet_scene: PackedScene
@export var speed: float = 150
@export var acceleration = 30
@export var health: float = 100

var can_shoot = true
var odd = true
@onready var animation_tree: AnimationTree = $Sprite2D/AnimationTree
@onready var muzzle_1 = $Sprite2D/Node2D
@onready var muzzle_2 = $Sprite2D/Node2D2
@onready var locked_sprite = $Sprite2D2
var player: Node2D = null

func _ready():
	get_tree().current_scene.get_node("MissionManager").register_enemy()

func _physics_process(delta):
	var state = "idle"
	if player:
		var player_pos = player.global_position
		var pos = global_position
		var distance = pos.distance_squared_to(player_pos)
		var direction = (player_pos - pos).normalized()
		if distance < 200*200:
			global_rotation = direction.angle()
			velocity = velocity.lerp(
				direction.rotated(deg_to_rad(90)) * speed, acceleration * delta
			)
			if can_shoot:
				shoot(player_pos)
		elif distance > 300*300:
			global_rotation = direction.angle()
			velocity = velocity.lerp(direction * speed, acceleration * delta)
		
	else:
		velocity = velocity.lerp(Vector2.ZERO, acceleration * delta)
	
	if velocity.length() > 20:
		state = "walk"
	
	animation_tree.set(
		"parameters/Transition/transition_request",
		state
	)

	move_and_slide()

func _on_detection_body_entered(body):
	if body.name == "Player":
		player = body

func _on_detection_body_exited(body):
	if body == player:
		player = null

func shoot(player_pos):
	can_shoot = false

	var fire_rate = 0.1
	var bullet = bullet_scene.instantiate()
	bullet.speed = 200
	bullet.max_distance = 500
	bullet.damage = 10
	
	if odd:
		bullet.global_position = muzzle_1.global_position
		odd = false
	else:
		bullet.global_position = muzzle_2.global_position
		odd = true
	
	var aim_angle = (player_pos - bullet.global_position).angle()
	bullet.rotation = aim_angle

	get_tree().current_scene.add_child(bullet)

	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true

func take_damage(amount):
	health -= amount
	animation_tree.set(
		"parameters/OneShot/request", 
		AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	)

	if health <= 0:
		die()
		
func die():
	get_tree().current_scene.get_node("MissionManager").unregister_enemy()
	queue_free()
	
func locked(state: bool):
	locked_sprite.visible = state
