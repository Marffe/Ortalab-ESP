SMODS.Joker({
    key = "peasant",
    atlas = "jokers",
    pos = {x = 2, y = 10},
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    artist_credits = {'kosze'},
    calculate = function(self, card, context)
        if context.cardarea == G.hand and context.individual and context.scoring_hand and context.other_card:is_numbered() then
            return {
                mult = context.other_card.base.nominal
            }
        end
    end    
})