SMODS.Joker({
	key = "jester",
	atlas = "jokers",
	pos = {x = 0, y = 0},
	rarity = 1,
	cost = 2,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {chips = 25}},
    artist_credits = {'crimson'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips, 
            }
        end
    end
})