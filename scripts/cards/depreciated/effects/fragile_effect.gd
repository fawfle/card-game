class_name FragileEffect extends CardEffect
## If present, this card will be destroyed on clashes.

func on_clash(card: Card, _attack: Attack):
	card.exit_play()
