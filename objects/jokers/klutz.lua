SMODS.Joker({
    key = "klutz",
    atlas = "jokers",
    pos = {x = 2, y = 14},
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {hand_size = 8}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo'} end
        return {vars = {card.ability.extra.hand_size}}
    end,
    calculate = function(self, card, context)
        if context.open_booster then
            G.hand.config.card_limit = G.hand.config.card_limit + card.ability.extra.hand_size
            return {
                message = '+8 hand size!'
            }
        end
        if context.ending_booster then
            G.hand.config.card_limit = G.hand.config.card_limit - card.ability.extra.hand_size
            return {
                message = '-8 hand size!'
            }
        end
    end    
})
