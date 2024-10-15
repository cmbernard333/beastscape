class_name HitBox extends Area2D

###
## A Hitbox is an area that does damage entering a hurtbox
###

@export var damage: int = 1

signal hit(node: Node2D)

func _on_hurtbox_area_entered(area: Area2D):
	if area == null:
		return
	if area is HurtBox:
		print("Hurtbox %s entered hitbox %s" % [area.owner, owner])
		var hurtbox = area as HurtBox
		hit.emit(hurtbox.owner)
	
func _ready() -> void:
	area_entered.connect(_on_hurtbox_area_entered)
