SMODS.Joker({
    key = "belmont",
    atlas = "jokers",
    pos = {x = 8, y = 8},
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {mult = 4}},
    loc_vars = function(self, info_queue, card)
        if card and not card.fake_card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo'} end
        local count = 0
        if G.playing_cards then count = Ortalab.curses_in_deck() end
        return {vars = {card.ability.extra.mult, card.ability.extra.mult * count}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local count = Ortalab.curses_in_deck()
            return {
                mult = card.ability.extra.mult * count
            }
        end
    end    
})