SMODS.Joker({
	key = "mixtape",
	atlas = "jokers",
	pos = {x = 1, y = 7},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {xmult = 1.5, gain = 0.2}},
    artist_credits = {'flare'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.gain, card.ability.extra.xmult}}
    end,
	calculate = function (self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult,
            }
        end
        if context.end_of_round and not context.repetition and not context.individual and not context.blueprint and G.GAME.current_round.hands_played == 1 then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.gain
            return {
                message = localize('k_upgrade_ex')
            }
        end
    end
})