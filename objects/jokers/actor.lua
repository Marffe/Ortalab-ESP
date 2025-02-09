SMODS.Joker({
    key = "actor",
    atlas = "jokers",
    pos = {x = 1, y = 15},
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {xmult = 1, gain = 1}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo'} end
        local handsize = G.hand.config.card_limit - count_negatives(G.hand.cards)
        return {vars = {card.ability.extra.gain, card.ability.extra.xmult + (math.abs(G.GAME.starting_params.hand_size - handsize) * card.ability.extra.gain), G.GAME.starting_params.hand_size}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local handsize = G.hand.config.card_limit - count_negatives(G.hand.cards)
            return {
                xmult = card.ability.extra.xmult + (math.abs(G.GAME.starting_params.hand_size - handsize) * card.ability.extra.gain)
            }
        end
    end    
})

function count_negatives(table)
    local extra = 0
    for _, card in pairs(table) do
        if card.edition and card.edition.card_limit then
            extra = extra + card.edition.card_limit
        end
    end
    return extra
end