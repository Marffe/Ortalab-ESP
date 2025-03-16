SMODS.Joker({
    key = "rea",
    atlas = "jokers",
    pos = {x = 0, y = 12},
    soul_pos = {x = 1, y = 12},
    rarity = 4,
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {xmult = 5}},
    loc_vars = function(self, info_queue, card)
        if card and not card.fake_card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.xmult}}
    end,
    calculate = function(self, card, context)
        if context.joker_main and not G.GAME.blind.boss then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end    
})