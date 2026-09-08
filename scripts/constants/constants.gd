class_name Constants
## A class storing constants.
##
## Unfortunately, Godot doesn't support global typed enums without a class, so this is the class!

## Keep track of the sides of combat, the allies (player) and enemies.
enum CombatSide {
	NONE,
	ALLY, ## Player side.
	ENEMY ## Enemy side.
}

## Keeps track of the different card piles. Can be used to get references to the "instance" of the PileType.
enum PileType {
	NONE,
	DECK, ## Copy of the card in the deck. Cloned during combat for actual use.
	DRAW, ## Where cards are drawn from.
	HAND, ## Cards currently in your hand.
	DISCARD, ## Cards that have been discarded.
	PLAY, ## Cards actively in play.
}

## What a card will target. Currently only self or enemy.
enum TargetType {
	NONE,
	SELF,
	ENEMY
}

## How much priority a shield has for taking effect over another.
enum ShieldPriority {
	PERMANENT = -1, ## permanent shields should be used last
	NONE = 0, ## default
	COUNTER = 8, ## counters want to actually shield
}

const ATTACK_ANIMATION = "attack"

enum MapPointType {
	NONE,
	DEBATE,
	BOSS,
	SHOP,
}

## A reason for a cardplay not being playable
enum UnplayableReason {
	NONE,
	NOT_ENOUGH_PATHOS,
	NOT_ENOUGH_LOGOS,
	NOT_ENOUGH_PATHOS_OR_LOGOS,
}
