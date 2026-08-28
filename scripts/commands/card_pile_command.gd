class_name CardPileCommand extends StaticClass
## Commands for interacting with card piles. For example, [method draw] or [method discard].
##
## Static class.

## Add a card to a pile. To add multiple at once, use [method add_to_pile_multiple] directly.
static func add_to_pile(new_pile: CardPile, card: CardModel) -> void:
	await add_to_pile_multiple(new_pile, TypedHelper.card_model_array(card))

static func add_to_pile_multiple(new_pile: CardPile, cards: Array[CardModel]) -> void:
	for card in cards:
		card.remove_from_current_pile()
		new_pile.add_internal(card)
		var card_node: CardNode = CardNode.create(card)
		if new_pile.type == Constants.PileType.HAND:
			CombatRoomNode.instance.ui.player_hand.add(card_node)

## Returns the number of cards that were successfully drawn.
static func draw(player: Player, count: int) -> int:
	if count <= 0: return 0
	var hand: CardPile = player.get_pile(Constants.PileType.HAND)
	var draw_pile: CardPile = player.get_pile(Constants.PileType.DRAW)
	for i in range(count):
		await shuffle_if_necessary(player)
		if draw_pile.cards.is_empty():
			return i
		add_to_pile(hand, draw_pile.cards.front())
	return count

static func shuffle(player: Player) -> void:
	var draw_pile: CardPile = player.player_combat_state.draw_pile
	var discard_pile: CardPile = player.player_combat_state.discard_pile
	var card_list: Array[CardModel] = []
	card_list.append_array(draw_pile.cards)
	card_list.append_array(discard_pile.cards)
	
	## annoyingly need to store copies of the arrays to remove cards, otherwise the array is modified during removal.
	var draw_pile_cards: Array[CardModel] = []
	var discard_pile_cards: Array[CardModel] = []
	draw_pile_cards.assign(draw_pile.cards)
	discard_pile_cards.assign(discard_pile.cards)
	
	for card: CardModel in draw_pile_cards:
		draw_pile.remove_internal(card)
	for card: CardModel in discard_pile_cards:
		discard_pile.remove_internal(card)
	
	card_list.shuffle()
	for card: CardModel in card_list:
		draw_pile.add_internal(card)

## Shuffle if there are no cards to draw.
static func shuffle_if_necessary(player: Player) -> void:
	var draw_pile: CardPile = player.player_combat_state.draw_pile
	var discard_pile: CardPile = player.player_combat_state.discard_pile
	if draw_pile.cards.is_empty() and not discard_pile.cards.is_empty():
		await shuffle(player)

static func discard():
	pass

static func remove():
	pass
