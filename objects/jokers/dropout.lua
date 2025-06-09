SMODS.Joker({
	key = "dropout",
	atlas = "jokers",
	pos = {x=4,y=13},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {rank = "Ace", mult = 18, hand = 'Straight'}},
	artist_credits = {'crimson'},
	loc_vars = function(self, info_queue, card)
		return {vars = {localize(card.ability.extra.hand, 'poker_hands'), localize(card.ability.extra.rank, 'ranks'), card.ability.extra.mult}}
	end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.base.value == card.ability.extra.rank and next(context.poker_hands[card.ability.extra.hand]) then
            return {
                mult = card.ability.extra.mult,
                message_card = context.other_card
            }
        end
    end
})