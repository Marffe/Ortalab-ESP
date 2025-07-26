SMODS.Joker({
	key = "televangelist",
	atlas = "jokers",
	pos = {x=1,y=10},
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {chance = 4}},
	artist_credits = {'gappie'},
	loc_vars = function(self, info_queue, card)
		return {vars = {SMODS.get_probability_vars(card, 1, card.ability.extra.chance)}}
	end,
	calculate = function(self, card, context)
		if context.using_consumeable and context.consumeable.ability.set == 'Loteria' and not context.blueprint then
			card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.gain
            SMODS.calculate_effect({message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult}}}, card)
		end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
})