SMODS.Joker({
    key = "other_half",
    atlas = "jokers",
    pos = {x = 5, y = 0},
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {chips = 75, cards = 3}},
    artist_credits = {'no_demo'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.cards}}
    end,
    calculate = function(self, card, context)
        if context.joker_main and #context.scoring_hand >= card.ability.extra.cards then
            return {
                chips = card.ability.extra.chips
            }
        end
    end    
})