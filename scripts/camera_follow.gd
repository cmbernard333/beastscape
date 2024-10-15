class_name CameraFollow extends Camera2D

@export var target_node: Node2D
@export var shake_strength: float = 30.0
@export var shake_fade: float = 5.0
var shake_value: float = 0.0

func _ready() -> void:
	SignalBus.player_take_damage.connect(_on_player_damage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	set_position(target_node.get_position())
	
	if shake_value > 0:
		shake_value = lerpf(shake_value, 0, shake_fade * delta)
		self.offset = random_offset()

func apply_shake() -> void:
	shake_value = shake_strength

func random_offset() -> Vector2:
	return Vector2(randf_range(-shake_value, shake_value), randf_range(-shake_value, shake_value))

func _on_player_damage(dmg: int) -> void:
	apply_shake()
