SMODS.Joker({
    key = "biker",
    atlas = "jokers",
    pos = {x = 5, y = 8},
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {gain = 1}},
    artist_credits = {'no_demo'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.gain}}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult + 1
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.RED
            }
        end
    end    
})