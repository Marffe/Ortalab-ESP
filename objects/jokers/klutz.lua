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
    artist_credits = {'no_demo'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.hand_size}}
    end,
    remove_from_deck = function(self, card, from_debuff)
        if card.ability.extra.triggered then
            G.hand:change_size(-card.ability.extra.hand_size)
        end
    end,
    calculate = function(self, card, context)
        if context.open_booster and context.card.config.center.draw_hand then
            G.hand:change_size(card.ability.extra.hand_size)
            card.ability.extra.triggered = true
            return {
                message = '+8 hand size!',
                no_retrigger = true
            }
        end
        if (context.ending_booster or context.skipping_booster) and context.booster and context.booster.draw_hand and card.ability.extra.triggered then
            G.hand:change_size(-card.ability.extra.hand_size)
            card.ability.extra.triggered = false
            return {
                message = '-8 hand size!',
                no_retrigger = true
            }
        end
    end    
})
