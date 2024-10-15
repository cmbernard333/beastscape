class_name Attack extends State

###
## Attack state needs to keep the animation going until its finished
## Attack state also has a hitbox that can collide with enemies
###

@export var attack_idle_state_name: String = "AttackIdle"

func physics_update(_delta: float) -> void:
	if !animation_playing:
		transitioned.emit("AttackIdle")
	
func _ready() -> void:
	animation_name = "SpriteAnimations_light_attack"

func enter() -> void:
	super.enter()
	# Audio.play_sfx(Audio.SFX.PlayerAttack)
