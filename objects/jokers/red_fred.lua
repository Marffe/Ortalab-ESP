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
	config = {extra = {mult = 3}},
	artist_credits = {'flare'},
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and (context.other_card:is_suit('Hearts') or context.other_card:is_suit('Diamonds')) then
            return {
                mult = card.ability.extra.mult,
                card = card
            }
        end
    end
})