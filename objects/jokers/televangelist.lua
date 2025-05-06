SMODS.Joker({
	key = "televangelist",
	atlas = "jokers",
	pos = {x=1,y=10},
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {xmult = 1.2, gain = 0.1}},
	artist_credits = {'gappie'},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.gain, card.ability.extra.xmult}}
	end,
	calculate = function(self, card, context)
		if context.using_consumeable and context.consumeable.ability.set == 'Loteria' and not context.blueprint then
			card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.gain
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult}}})
		end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
})