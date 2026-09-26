class_name Ponder extends CardModel
## Draw some cards.

func get_target_type() -> Constants.TargetType: return Constants.TargetType.NONE

func get_rarity() -> Constants.Rarity: return Constants.Rarity.COMMON

func get_icon() -> Texture2D: return preload("res://assets/icons/brain_icon.webp")

var draw_amount: int = 2

func _get_base_pathos_cost() -> int: return 2

func get_description() -> String: return "Draw %s cards." % draw_amount

func on_play(card_play: CardPlay) -> void:
	CardPileCommand.draw(owner, draw_amount)
	VfxCommand.play_on_creature_front(owner.creature, preload("res://scenes/vfx/thought_bubble.tscn"))
