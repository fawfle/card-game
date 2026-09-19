class_name DrawAndDurationUpgrade extends UpgradeModel

func get_description() -> String: return "When played, draw %d card. Changes duration by %d" % [_draw_amount, _duration_modifier]

func get_card_description() -> String: return "Draw %d card." % [_draw_amount]

var _draw_amount: int = 0
var _duration_modifier: float = 0

func set_amounts(draw_amount: int, duration_modifier: float) -> DrawAndDurationUpgrade:
	_draw_amount = draw_amount
	_duration_modifier = duration_modifier
	return self

func can_apply(_card_model: CardModel) -> bool:
	return _card_model.duration != null

func after_card_played(card_play: CardPlay) -> void:
	CardPileCommand.draw(card_play.card.owner, 1)

func upgrade_duration_additive(_duration_amount: float) -> float:
	return _duration_modifier
