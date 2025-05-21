SMODS.Joker({
    key = "rockstar",
    atlas = "jokers",
    pos = {x = 6, y = 14},
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {hand_size = 2, hands = 3}},
    artist_credits = {'joey'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.hand_size, card.ability.extra.hands}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            Ortalab.change_hand_size(-card.ability.extra.hand_size)
            ease_hands_played(card.ability.extra.hands)
        end
    end
})