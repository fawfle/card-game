@abstract
class_name CardEffect extends Resource
## Class for effects cards can have. Allowed to have side effects because it makes things a lot easier :(

enum Phase {
	START,
	IN_PLAY_PROCESS,
	END
}

## Called to reset very temporary changes to cards, like sustained shield damage.
func reset() -> void:
	pass

## Called when card is initially played
func on_play_start(_card: Card) -> void:
	pass

## Called when card exits play
func on_play_end(_card: Card) -> void:
	pass

## Called while card is in play, similar to [method _process].
func in_play_process(_card: Card, _delta: float) -> void:
	pass

## Called when this card clashes
func on_clash(_card: Card, _attack: Attack) -> void:
	pass

## Called when the card is destroyed as a result of clashing or another effect.
func on_destroy(_card: Card) -> void:
	pass
