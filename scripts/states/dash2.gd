class_name Dash2 extends WalkState

###
## Dash is a special state that propels you forward then lets walk take over
###

@export var dash_speed: float = 8.0
@export var dash_timer_duration: float = 0.4
@export var dashing_time: int = 3 # time in seconds

@onready var dash_timer: Timer = $Timer

var dashing: bool = false

func _on_timeout():
	dashing = false

func _dash() -> void:
	dashing = true
	dashing_time = 3
	dash_timer.start(dash_timer_duration)
	var direction: Vector2 = input_component.get_movement_direction()
	if direction.is_zero_approx():
		direction.x = -1.0 if character.get_facing_direction() == 0 else 1.0
	print("Dash Speed: %d" % [(dash_speed * character.move_speed) * direction])
	character.velocity.x = (dash_speed * character.move_speed) * direction

func enter() -> void:
	# no additional animation for dash
	if !dashing:
		_dash()

func physics_update(delta: float) -> void:
	character.move_and_slide()
	dashing_time -= delta
	if dashing_time <= 0:
		transitioned.emit("Walk")

func _ready() -> void:
	dash_timer.timeout.connect(_on_timeout)
