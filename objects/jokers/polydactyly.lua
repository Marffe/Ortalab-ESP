SMODS.Joker({
	key = "polydactyly",
	atlas = "jokers",
	pos = {x=7,y=0},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {cards = 3, hand_1 = 'Flush', hand_2 = 'Straight'}},
	artist_credits = {'eremel','grassy'},
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.cards, localize(card.ability.extra.hand_1, 'poker_hands'), localize(card.ability.extra.hand_2, 'poker_hands')}}
	end,
	calculate = function(self, card, context)
		if context.after then
			Ortalab.polydactyly.cards = {}
		end
	end
})

Ortalab.polydactyly = {cards = {}}