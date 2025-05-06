SMODS.Joker({
    key = "storm_6",
    atlas = "jokers",
    pos = {x = 7, y = 4},
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {mult = 4, dollars = 2}},
    artist_credits = {'kosze'},
    loc_vars = function(self, info_queue, card)
        local sixes = 0
        if G.playing_cards then    
            for _, card in pairs(G.playing_cards) do
                if card:get_id() == 6 then sixes = sixes + 1 end
            end
        end
        return {vars = {card.ability.extra.mult, card.ability.extra.mult * sixes, card.ability.extra.dollars}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local sixes = 0
            for _, card in pairs(G.playing_cards) do
                if card:get_id() == 6 then sixes = sixes + 1 end
            end
            return {
                mult = card.ability.extra.mult * sixes
            }
        end
        if context.setting_blind then
            local nines = 0
            for _, card in pairs(G.playing_cards) do
                if card:get_id() == 9 then nines = nines + 1 end
            end
            if nines then
                return {
                    dollars = -card.ability.extra.dollars
                }
            end
        end
    end    
})