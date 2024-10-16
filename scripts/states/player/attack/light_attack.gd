class_name LightAttack extends State

@export var attack_idle_state_name: String = "AttackIdle"

###
## LightAttack state needs to keep the animation going until its finished
## LightAttack state also has a hitbox that can collide with enemies
###

func physics_update(_delta: float) -> void:
	if !animation_playing:
		transitioned.emit(attack_idle_state_name)
	
func _ready() -> void:
	animation_name = "SpriteAnimations_light_attack"
