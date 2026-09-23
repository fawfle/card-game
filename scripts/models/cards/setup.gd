class_name Setup extends CardModel
## Makes next attack deal more damage (applies setup)

func get_target_type() -> Constants.TargetType: return Constants.TargetType.NONE

func _get_base_play_duration() -> DurationVariable: return DurationVariable.new(10.0)

var setup_amount: int = 2

func on_play(_card_play: CardPlay) -> void:
	EffectCommand.new(SetupEffect, owner.creature, setup_amount).from_card(self).execute()
