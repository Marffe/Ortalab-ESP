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
	config = {extra = {Xmult = 1.15}},
	artist_credits = {'flowwey'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult}}
    end,
	calculate = function(self, card, context) --Logic
        if context.individual and context.cardarea == G.play and (context.other_card:get_id() == 14 or context.other_card:get_id() == 10 or context.other_card:get_id() == 9 or context.other_card:get_id() == 8 or context.other_card:get_id() == 6 or context.other_card:get_id() == 4) and not SMODS.has_no_rank(context.other_card) then
            return {
                Xmult = card.ability.extra.Xmult,
                card = card
            }
        end
    end
})
--[[if context.individual and context.cardarea == G.play and (context.other_card:get_id() == 14 or context.other_card:get_id() <=10 or context.other_card:get_id() >= 8 or context.other_card:get_id() == 6 and context.other_card:get_id() == 4) and not SMODS.has_no_rank(context.other_card) then]]

	--[[
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
}]]