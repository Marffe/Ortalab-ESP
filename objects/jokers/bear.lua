SMODS.Joker({
    key = "bear",
    atlas = "jokers",
    pos = {x = 4, y = 14},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {gain = 1, mult = 0}},
    artist_credits = {'eremel'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.gain, card.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            card.ability.extra.mult = 0
            return {
                message = localize('ortalab_joker_miles_reset'),
            }
        end
        if (context.buying_card and context.card ~= card) or context.open_booster and not context.blueprint then
            local spent = context.card.cost
                card.ability.extra.mult = card.ability.extra.mult + spent * card.ability.extra.gain
                SMODS.calculate_effect({message = localize('k_upgrade_ex'), colour = G.C.RED}, card)
                return
        end
        if context.reroll_shop and not context.blueprint then
            local spent = context.cost
                card.ability.extra.mult = card.ability.extra.mult + spent * card.ability.extra.gain
                SMODS.calculate_effect({message = localize('k_upgrade_ex'), colour = G.C.RED}, card)
                return
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult;
            }
        end
    end    
})