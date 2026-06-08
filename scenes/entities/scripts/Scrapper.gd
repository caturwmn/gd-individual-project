extends CharacterBody2D

@export var speed: float = 150
@export var acceleration = 30
@export var health: float = 100
@onready var animation_tree: AnimationTree = $Sprite2D/AnimationTree
@onready var locked_sprite = $Sprite2D2

var player: Node2D = null

func _ready():
	get_tree().current_scene.get_node("MissionManager").register_enemy()

func _physics_process(delta):
	var state = "idle"
	if player:
		var direction = (player.global_position - global_position).normalized()
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
