SMODS.Joker({
    key = "gloomy_gus",
    atlas = "jokers",
    pos = {x = 9, y = 14},
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {hand_size = 3, discard_limit = 3}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo'} end
        return {vars = {card.ability.extra.hand_size, card.ability.extra.discard_limit + G.GAME.ortalab.extra_discard_size}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            Ortalab.change_hand_size(card.ability.extra.hand_size)
        end
    end,
})

local can_disc = G.FUNCS.can_discard
G.FUNCS.can_discard = function(e)
    can_disc(e)
    local gloomy = SMODS.find_card('j_ortalab_gloomy_gus')
    if next(gloomy) then
        if #G.hand.highlighted > gloomy[1].ability.extra.discard_limit + G.GAME.ortalab.extra_discard_size then 
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        end
    end
end