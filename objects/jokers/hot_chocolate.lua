SMODS.Joker({
	key = "hot_chocolate",
	atlas = "jokers",
	pos = {x=3,y=3},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,
	config = {extra = {chips = 0, change = 15, limit = 180}},
    artist_credits = {'gappie'},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.chips, card.ability.extra.change, card.ability.extra.limit}}
	end,
	calculate = function(self, card, context)
        if context.before then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.change
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.change}}
            }
        end
		if context.joker_main and card.ability.extra.chips > 0 then
            return {
                chips = card.ability.extra.chips
            }
        end
        if context.after and not context.blueprint then
            if card.ability.extra.limit == card.ability.extra.chips then
                SMODS.destroy_cards(card)
                return {
                    message = localize('k_eaten_ex'),
                }
            end
            
        end
    end
})