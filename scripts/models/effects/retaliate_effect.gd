class_name RetaliateEffect extends EffectModel
## Thorns effect when shields are broken
##
## NOTE: if I ever add an actual "thorns" status to the game, that should probably be called Retaliate and this should be renamed.

func get_title() -> String: return "Retaliate"

func get_description() -> String: return "When a shield is destroyed, deal %d damage." % amount

func get_icon() -> Texture2D: return load("res://assets/icons/broken_shield.png")

func after_shield_destroyed(shield: Shield, dealer: Creature) -> void:
	if shield.creature == owner:
		await AttackCommand.new(amount).from(owner).targeting(dealer).execute()
