SMODS.Joker({
    key = "fools",
    atlas = "jokers",
    pos = {x = 3, y = 14},
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {gain = 1}},
    loc_vars = function(self, info_queue, card)
        if card and not card.fake_card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo'} end
        return {vars = {card.ability.extra.gain}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            card.sell_cost = card.sell_cost + (#G.jokers.cards - 1) * card.ability.extra.gain
            juice_card(card)
        end
    end    
})