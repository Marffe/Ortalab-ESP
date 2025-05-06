SMODS.Joker({
	key = "scantron",
	atlas = "jokers",
	pos = {x=0,y=11},
	rarity = 1,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {chance = 2, denom = 4, repetitions = 1}},
	artist_credits = {'gappie'},
	loc_vars = function(self, info_queue, card)
		return {vars = {math.max(G.GAME.probabilities.normal, 1) * card.ability.extra.chance, card.ability.extra.denom / math.min(G.GAME.probabilities.normal, 1), card.ability.extra.repetitions}}
	end,
	calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition then
            if pseudoseed('ortalab_scantron') > (G.GAME.probabilities.normal * card.ability.extra.chance) / card.ability.extra.denom then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.repetitions,
                    card = card
                }
            end
        end
        
    end
})