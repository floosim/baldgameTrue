extends CharacterBody2D

signal carHit

const SPEED = -500
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	velocity.x = SPEED 
	
	move_and_slide()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

func _on_bouncebox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		carHit.emit()
		body.velocity.y = -1000
		body.velocity.x = SPEED * 1.5
