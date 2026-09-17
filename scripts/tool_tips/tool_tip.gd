class_name ToolTip

var title: String
var description: String

func _init(tip_title: String, tip_description: String) -> void:
	title = tip_title
	description = tip_description

static func from_keyword(keyword: Constants.CardKeyword) -> ToolTip:
	return ToolTip.new(CardKeywordHelper.get_title(keyword), CardKeywordHelper.get_description(keyword))

## create a generic tooltip for an effect type
static func from_effect_type(effect_type: Script) -> ToolTip:
	var base_model: EffectModel = ModelDb.effect(effect_type)
	return ToolTip.new(base_model.get_title(), base_model.get_generic_description())
