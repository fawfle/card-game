class_name CreatureVisuals extends Node2D
## A class that manages a creature's visuals and animations.

@onready var animation_player: AnimationPlayer = %AnimationPlayer

## Try to play an animation on the creature. If it fails, do nothing.
func try_play_animation(animation_name: String) -> void:
	if not animation_player.has_animation(animation_name): return
	animation_player.play(animation_name)
