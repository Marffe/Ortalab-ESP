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
    loc_vars = function(self, info_queue, card)
        if card and not card.fake_card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.hand and context.individual and context.scoring_hand and context.other_card:is_numbered() then
            return {
                mult = context.other_card.base.nominal
            }
        end
    end    
})