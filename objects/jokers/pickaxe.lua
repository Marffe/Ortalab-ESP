SMODS.Joker({
	key = "pickaxe",
	atlas = "jokers",
	pos = {x = 9, y = 5},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
    config = {extra = {xmult = 1, gain = 0.2}},
    artist_credits = {'gappie'},
    enhancement_gate = 'm_ortalab_ore',
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult, card.ability.extra.gain}}
    end,
    calculate = function(self, card, context)
        if context.destroying_card and (context.destroying_card.config.center.no_rank or context.destroying_card.config.center_key == 'm_stone') then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.gain
            return {
                remove = true,
                message = '+X'..card.ability.extra.gain,
                colour = G.C.RED,
                message_card = card
            }
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult,
            }
        end
    end
})