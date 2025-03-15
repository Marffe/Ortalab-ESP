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
    loc_vars = function(self, info_queue, card)
        if card and not card.fake_card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo'} end
        return {vars = {card.ability.extra.hand_size, card.ability.extra.hands}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            Ortalab.change_hand_size(-card.ability.extra.hand_size)
            ease_hands_played(card.ability.extra.hands)
        end
    end
})