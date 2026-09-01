class_name TestConvincingCard extends CardModel

func get_target_type() -> Constants.TargetType: return Constants.TargetType.SELF

var convincing_amount: int = 5

func get_description() -> String: return "Applies %d convincing to self." % convincing_amount

func on_play(card_play: CardPlay) -> void:
	EffectCommand.new(ConvincingEffect, card_play.target, convincing_amount).from_card(self).execute()
	EffectCommand.new(ConvincingEffect, card_play.target, convincing_amount).from_card(self).with_duration(5.0).execute()
	
	VfxCommand.play_on_creature_front(owner.creature, preload("res://scenes/vfx/speech_bubble.tscn"))
