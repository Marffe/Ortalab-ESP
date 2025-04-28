SMODS.Joker({
	key = "polydactyly",
	atlas = "jokers",
	pos = {x=7,y=0},
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {cards = 3, hand_1 = 'Flush', hand_2 = 'Straight'}},
	loc_vars = function(self, info_queue, card)
        if card and not card.fake_card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'eremel'}; info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'grassy'} end
        return {vars = {card.ability.extra.cards, localize(card.ability.extra.hand_1, 'poker_hands'), localize(card.ability.extra.hand_2, 'poker_hands')}}
	end,
	calculate = function(self, card, context)
		if context.after then
			Ortalab.polydactyly.cards = {}
		end
	end
})

Ortalab.polydactyly = {cards = {}}