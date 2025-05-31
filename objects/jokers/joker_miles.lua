SMODS.Joker({
	key = "joker_miles",
	atlas = "jokers",
	pos = {x = 4, y = 1},
	rarity = 1,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {mult = 0, mult_gain = 8, chance = 6}},
    artist_credits = {'logan'},'flare',
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult_gain, card.ability.extra.mult, math.max(1, G.GAME.probabilities.normal), card.ability.extra.chance / math.min(G.GAME.probabilities.normal, 1)}}
    end,
    calculate = function(self, card, context)
        if context.before then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            return {
                message = localize('ortalab_joker_miles'),
                colour = G.C.RED
            }
        end
        if context.end_of_round and context.main_eval and not context.blueprint then
            if pseudorandom(pseudoseed('ortalab_joker_miles')) < G.GAME.probabilities.normal / card.ability.extra.chance then
                card.ability.extra.mult = 0
                return {
                    message = localize('ortalab_joker_miles_reset'),
                    colour = G.C.RED
                }
            end
        end
        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                mult = card.ability.extra.mult,
            }
        end
    end
})