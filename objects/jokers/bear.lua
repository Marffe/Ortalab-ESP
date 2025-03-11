SMODS.Joker({
    key = "bear",
    atlas = "jokers",
    pos = {x = 4, y = 14},
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    config = {extra = {dollars = 20, spent = 0, mult = 0, gain = 3}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo'} end
        return {vars = {card.ability.extra.gain, card.ability.extra.dollars, card.ability.extra.mult, card.ability.extra.spent}}
    end,
    calculate = function(self, card, context)
        if context.buying_card or context.open_booster and not context.blueprint then
            card.ability.extra.spent = card.ability.extra.spent + context.card.cost
            while card.ability.extra.spent > card.ability.extra.dollars do
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
                card.ability.extra.spent = card.ability.extra.spent - card.ability.extra.dollars
                SMODS.calculate_effect({message = localize('k_upgrade_ex'), colour = G.C.RED}, card)
            end
        end
        if context.reroll_shop and not context.blueprint then
            card.ability.extra.spent = card.ability.extra.spent + context.cost
            while card.ability.extra.spent > card.ability.extra.dollars do
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
                card.ability.extra.spent = card.ability.extra.spent - card.ability.extra.dollars
                SMODS.calculate_effect({message = localize('k_upgrade_ex'), colour = G.C.RED}, card)
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end    
})