SMODS.Joker({
	key = "prediction_dice",
	atlas = "jokers",
	pos = {x = 6, y = 13},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {num = 3, chance = 4}},
	artist_credits = {'gappie'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.num*math.max(G.GAME.probabilities.normal, 1), card.ability.extra.chance/math.min(G.GAME.probabilities.normal, 1)}}
    end,
	
})