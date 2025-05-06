SMODS.Joker({
    key = "purple",
    atlas = "jokers",
    pos = {x = 8, y = 3},
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {chips = 40, chip_change = 20, mult = 10, mult_change = 5}},
    artist_credits = {'no_demo'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chip_change, card.ability.extra.mult_change, card.ability.extra.chips, card.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        if context.pre_discard and card.ability.extra.mult > 0 then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_change
            card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_change
            return {
                message = localize({type = 'variable', key = 'a_chips', vars = {card.ability.extra.chip_change}}),
                colour = G.C.BLUE,
                extra = {
                    message = localize({type = 'variable', key = 'a_mult_minus', vars = {card.ability.extra.mult_change}}),
                    colour = G.C.RED
                }
            }
        end
        if context.after and card.ability.extra.chips > 0 then
            card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_change
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_change
            return {
                message = localize({type = 'variable', key = 'a_chips_minus', vars = {card.ability.extra.chip_change}}),
                colour = G.C.BLUE,
                extra = {
                    message = localize({type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult_change}}),
                    colour = G.C.RED
                }
            }
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
    end    
})