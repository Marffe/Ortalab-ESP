SMODS.Joker({
    key = "crowd_pleaser",
    atlas = "jokers",
    pos = {x = 5, y = 1},
    rarity = 2,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {hands = {}, amount = 3}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo'} end
        return {vars = {card.ability.extra.amount, not card.ability.extra.hands.triggered and table.size(card.ability.extra.hands) .. '/' .. card.ability.extra.amount or localize('ortalab_crowd_pleaser_success'), localize(G.GAME.current_round.most_played_poker_hand, 'poker_hands')}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.extra.hands = {}
        end
        if context.after and not card.ability.extra.hands.triggered then
            card.ability.extra.hands[context.scoring_name] = true
            if table.size(card.ability.extra.hands) == card.ability.extra.amount then
                card.ability.extra.hands.triggered = true
                return {
                    message = localize('k_level_up_ex'),
                    level_up = true,
                    level_up_hand = G.GAME.current_round.most_played_poker_hand
                }
            end
            return {
                message = table.size(card.ability.extra.hands) .. '/' .. card.ability.extra.amount
            }
        end
    end    
})