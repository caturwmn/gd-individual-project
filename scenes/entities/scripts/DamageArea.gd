extends Area2D
@export var damage: float
@export var cooldown: float

var on_ccoldown: bool = false
func _on_body_entered(body: Node2D):
	if body.name == "Player":
		if body.has_method("take_damage") and (not on_ccoldown):
			on_ccoldown = true
			body.take_damage(damage)
			
			await get_tree().create_timer(cooldown).timeout
			on_ccoldown = false
