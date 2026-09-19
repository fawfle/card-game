class_name CardSelectCommand

## TODO: Have upgrades filter what cards they can't apply to
## Select a card from a grid for a card upgrade.
static func select_card_for_upgrade(player: Player, upgrade: UpgradeModel) -> CardModel:
	var upgradeable_cards: Array[CardModel] = player.deck.cards.filter(can_upgrade).filter(func(card: CardModel): return upgrade.can_apply(card))
	if upgradeable_cards.size() == 0: return null
	
	var card_grid_selection_screen: CardGridSelectionScreen = CardGridSelectionScreen.create(upgradeable_cards, 1)
	RunNode.instance.global_ui.set_overlay_screen(card_grid_selection_screen)
	await card_grid_selection_screen.cards_selected
	RunNode.instance.global_ui.close_overlay_screen_if_active(card_grid_selection_screen)
	return card_grid_selection_screen.selected_cards[0]

static func can_upgrade(card: CardModel) -> bool:
	return card.is_upgradeable
