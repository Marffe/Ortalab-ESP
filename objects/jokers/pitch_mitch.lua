SMODS.Joker({
	key = "pitch_mitch",
	atlas = "jokers",
	pos = {x = 7, y = 2},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {chips = 120}},
	artist_credits = {'flare'},
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, localize('Clubs', 'suits_plural'), localize('Spades', 'suits_plural'), colours = {G.C.SUITS.Clubs, G.C.SUITS.Spades}}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
			local suits = {}
			for _, _card in pairs(context.scoring_hand) do
				suits[_card.base.suit] = true
			end
			if suits['Spades'] and suits['Clubs'] then
				return {
					chips = card.ability.extra.chips
				}
			end
		end
    end
})