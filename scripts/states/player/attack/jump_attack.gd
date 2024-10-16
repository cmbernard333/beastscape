class_name JumpAttack extends State

@export var attack_idle_state_name: String = "AttackIdle"

###
## JumpAttack state needs to keep the animation going until its finished
## JumpAttack also has a hitbox that can collide with enemies
###

func physics_update(_delta: float) -> void:
	if !animation_playing:
		transitioned.emit(attack_idle_state_name)
	
func _ready() -> void:
	animation_name = "SpriteAnimations_jump_attack"
