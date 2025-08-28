SMODS.Joker({
	key = "caffeyne",
	atlas = "jokers",
	pos = {x = 6, y = 11},
    soul_pos = {x = 7, y = 11},
	rarity = 4,
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {xmult = 1, xmult_gain = 1.5, triggers = 23, triggered_cards = 0}},
    artist_credits = {'gappie','crimson'},
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult_gain, card.ability.extra.triggers, card.ability.extra.xmult, card.ability.extra.triggered_cards}}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and not context.blueprint then
            card.ability.extra.triggered_cards = card.ability.extra.triggered_cards + 1
            if card.ability.extra.triggered_cards == card.ability.extra.triggers then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "xmult",
                    scalar_value = "xmult_gain",
                    message_key = 'a_xmult',
                    message_colour = G.C.RED
                })
                card.ability.extra.triggered_cards = 0
            end
        end
        if context.joker_main and card.ability.extra.xmult > 1 then
            return {
                xmult = card.ability.extra.xmult,
            }
        end
    end
})
