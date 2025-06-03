SMODS.Joker({
	key = "white_flag",
	atlas = "jokers",
	pos = {x = 8,y = 1},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {mult_add = 8}},
    artist_credits = {'gappie'},
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult_add, card.ability.extra.mult_add*G.GAME.current_round.discards_left}}
    end,
    calculate = function (self, card, context) --Graffiti logic
        if context.joker_main and G.GAME.current_round.discards_left > 0 then
            return {
                mult = card.ability.extra.mult_add*G.GAME.current_round.discards_left,
                colour = G.C.MULT
            }
        end
    end
})
