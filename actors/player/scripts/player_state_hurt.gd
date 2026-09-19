class_name PlayerStateHurt
extends PlayerState

@export var hurt_time: float
@export var invincibility_time: float
@export var hurt_shader: Resource

var body: Damageful
var can_take_damage: bool = true

func enter() -> void:
	if (can_take_damage):
		player.health_component.take_damage(1.0)
		player.camera.screen_shake(5, 0.5)
		player.sprites.material.set_shader_parameter("active", true)
		get_tree().create_timer(invincibility_time).timeout.connect(func(): 
			player.sprites.material.set_shader_parameter("active", false)
			can_take_damage = true
			)
		
	can_take_damage = false
	get_tree().create_timer(hurt_time).timeout.connect(transitioned.emit.bind(self, "PlayerStateFree"))

func physics_update(_delta: float) -> void:
	player.movement_component.direction = body.global_position.direction_to(player.global_position)
