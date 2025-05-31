SMODS.Joker({
	key = "graffiti",
	atlas = "jokers",
	pos = {x = 1,y = 1},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {mult_add = 6}},
    artist_credits = {'flare', 'gappie'},
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult_add, card.ability.extra.mult_add*G.GAME.current_round.hands_left}}
    end,
    calculate = function (self, card, context) --Graffiti logic
        if context.joker_main then
            if G.GAME.current_round.hands_left > 0 then
                return {
                    mult = card.ability.extra.mult_add*G.GAME.current_round.hands_left,
                    colour = G.C.MULT
                }
            end
        end
    end
})
