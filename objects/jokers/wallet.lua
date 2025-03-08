SMODS.Joker({
    key = "wallet",
    atlas = "jokers",
    pos = {x = 8, y = 0},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'eremel'} end
        return {vars = {}}
    end,
    calculate = function(self, card, context)
        
    end    
})