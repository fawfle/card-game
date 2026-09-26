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

enum PilePositionType {
	NONE,
	TOP, ## Add to top of deck
	BOTTOM, ## Add to bottom of deck
	RANDOM, ## Add to random position in deck
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

## A keyword for a card (like fragile). Handled externally.
enum CardKeyword {
	NONE,
	FRAGILE, ## cancelled after the player is hit by an attack (not just unblocked damage).
}

enum Rarity {
	NONE,
	COMMON,
	UNCOMMON,
	RARE
}

const ATTACK_ANIMATION = "attack"

enum MapPointType {
	NONE,
	DEBATE,
	BOSS,
	UPGRADE,
	SHOP,
}

## A reason for a cardplay not being playable
enum UnplayableReason {
	NONE,
	NOT_ENOUGH_PATHOS,
	NOT_ENOUGH_LOGOS,
	NOT_ENOUGH_PATHOS_OR_LOGOS,
}

## Presets for the alignment of tool tips and tool tip sets.
enum Alignment {
	NONE,
	LEFT, ## Top left going left
	RIGHT, ## Top right going right
	CENTER_TOP, ## Centered, above
}
