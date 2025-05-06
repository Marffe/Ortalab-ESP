SMODS.Joker({
	key = "black_cat",
	atlas = "jokers",
	pos = {x=2,y=9},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {num = 3, chance = 4}},
	artist_credits = {'kosze'},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.num*math.max(1,G.GAME.probabilities.normal), card.ability.extra.chance / math.min(G.GAME.probabilities.normal, 1)}}
	end
})