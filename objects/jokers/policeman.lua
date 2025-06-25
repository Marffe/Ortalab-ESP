SMODS.Joker({
	key = "policeman",
	atlas = "jokers",
	pos = {x = 8, y = 10},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {hands = 1, discards = 4, money = 2}},
	artist_credits = {'gappie'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.hands, card.ability.extra.discards, card.ability.extra.money}}
    end,
	calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced then
            ease_discard(card.ability.extra.discards)
            if not context.blueprint then ease_hands_played(-1 * (G.GAME.round_resets.hands - card.ability.extra.hands)) end
			return {
				message = localize('ortalab_policeman'),
				colour = G.C.BLUE
			}
        end
		if context.end_of_round and context.main_eval then
			if G.GAME.current_round.discards_left > 0 then
				return {
					dollars = G.GAME.current_round.discards_left * card.ability.extra.money
				}
			end
		end
    end
})