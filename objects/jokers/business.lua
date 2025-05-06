SMODS.Joker({
	key = "business",
	atlas = "jokers",
	pos = {x=9,y=1},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {reroll_gain = 2}},
	artist_credits = {'alex'},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.reroll_gain}}
	end,
	calculate = function(self, card, context)
		if context.reroll_shop then
			return {
				dollars = card.ability.extra.reroll_gain
			}
		end
	end
})