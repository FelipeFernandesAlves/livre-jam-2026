class_name Damageable extends Area2D

@warning_ignore("unused_signal")
signal damaged(body: Damageful)

var can_take_damage: bool = true
