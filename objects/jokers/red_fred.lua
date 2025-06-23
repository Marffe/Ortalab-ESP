SMODS.Joker({
	key = "red_fred",
	atlas = "jokers",
	pos = {x = 6, y = 2},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {mult = 20}},
	artist_credits = {'flare'},
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, localize('Hearts', 'suits_plural'), localize('Diamonds', 'suits_plural'), colours = {G.C.SUITS.Hearts, G.C.SUITS.Diamonds}}}
    end,
    calculate = function(self, card, context)
		if context.joker_main then
			local suits = {}
			for _, _card in pairs(context.scoring_hand) do
				suits[_card.base.suit] = true
			end
			if suits['Hearts'] and suits['Diamonds'] then
				return {
					mult = card.ability.extra.mult
				}
			end
		end
    end
})