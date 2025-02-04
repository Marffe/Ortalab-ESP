SMODS.Joker({
    key = "priest",
    atlas = "jokers",
    pos = {x = 5, y = 14},
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {gain = 0.1}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo'} end
        local current_xmult = 1
        if G.jokers then
            for i=1, #G.jokers.cards + #G.consumeables.cards do
                local _card = G.jokers.cards[i] or G.consumeables.cards[i - #G.jokers.cards]
                if _card ~= card then
                    current_xmult = current_xmult + (_card.sell_cost * card.ability.extra.gain)
                end
            end
        end
        return {vars = {card.ability.extra.gain, current_xmult}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local current_xmult = 1
            for i=1, #G.jokers.cards + #G.consumeables.cards do
                local _card = G.jokers.cards[i] or G.consumeables.cards[i - #G.jokers.cards]
                if _card ~= card then
                    current_xmult = current_xmult + (_card.sell_cost * card.ability.extra.gain)
                end
            end
            return {
                xmult = current_xmult
            }
        end
    end    
})