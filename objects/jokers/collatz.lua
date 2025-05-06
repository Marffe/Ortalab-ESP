SMODS.Joker({
	key = "collatz",
	atlas = "jokers",
	pos = {x = 0, y = 2},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {x_mult = 3, x_mult_reduction = 0.5}},
	artist_credits = {'flowwey'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.x_mult, card.ability.extra.x_mult_reduction}}
    end,
    calculate = function(self, card, context) --Collatz Logic
        if context.joker_main then
			return {
				xmult = (hand_chips % 2 > to_big(0)) and card.ability.extra.x_mult or card.ability.extra.x_mult_reduction
			}
        end
    end
})