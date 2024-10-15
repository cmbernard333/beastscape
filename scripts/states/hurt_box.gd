class_name HurtBox extends Area2D

###
## A Hurtbox is an area that takes damage from a hitbox
###

signal hurt(damage: int)

func _on_hit_box_entered(area: Area2D):
	if area == null:
		return
	if area is HitBox:
		print("Hitbox %s entered hurtbox %s" % [area.owner, owner])
		var hitbox = area as HitBox
		hurt.emit(hitbox.damage)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_hit_box_entered)
