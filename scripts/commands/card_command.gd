class_name CardCommand extends StaticClass
## Commands for interacting with cards themselves like upgrading or applying effects.
##
## Static class.

## This should be the only way cards are played. [br][br]
## NOTE: Unlike STS2, we don't separate player actions into GameActions (I assume its a multiplayer thing) so inputs can/do directly call Commands.
static func play(card: CardModel, target: Creature) -> void:
	var combat_state: CombatState = card.combat_state
	if not combat_state:
		push_error("card must have combat_state to be played")
		return
	
	if not card.can_play():
		push_warning("do not have resources to play card. stopping play...")
		return
	
	card.spend_resources()
	
	var card_play: CardPlay = CardPlay.create_from_properties({ "card": card, "target": target, "play_duration": card.get_play_duration() })
	await Hook.before_card_played(combat_state, card_play)
	card.card_play = card_play
	card.on_play(card_play)
	while(card_play.play_time_left > 0) and CombatManager.instance.is_in_progress:
		# Not 100% sure about order of waiting/processing, but awaiting before in_play_process seems fine.
		await RunNode.instance.get_tree().process_frame
		var delta: float = RunNode.instance.get_process_delta_time()
		card_play.play_time_left -= delta
		card.in_play_process(delta)
	card.on_exit_play()
	card.card_play = null
	await Hook.after_card_played(combat_state, card_play)
	card.exited_play.emit()
	
	var result_pile: Constants.PileType = card.get_play_result_pile()
	CardPileCommand.add_to_pile(card.owner.get_pile(result_pile), card)

## Use to remove a card from play from an external source. Only works if that card was already in play.
static func remove_from_play(card: CardModel) -> void:
	if not card.card_play: push_error("card is not in play")
	card.card_play.stop()

## To discard multiple cards at once, use [method discard_multiple] directly.
static func discard(card: CardModel) -> void:
	discard_multiple(TypedHelper.card_model_array(card))

static func discard_multiple(cards: Array[CardModel]) -> void:
	if cards.is_empty(): return
	
	var discard_pile: CardPile = cards[0].owner.get_pile(Constants.PileType.DISCARD)
	for card: CardModel in cards:
		await CardPileCommand.add_to_pile(discard_pile, card)
