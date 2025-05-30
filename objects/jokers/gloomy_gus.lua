SMODS.Joker({
    key = "gloomy_gus",
    atlas = "jokers",
    pos = {x = 9, y = 14},
    rarity = 3,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {hand_size = 3, discard_limit = 1}},
    artist_credits = {'no_demo'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.hand_size, card.ability.extra.discard_limit + G.GAME.ortalab.extra_discard_size}}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.hand_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.hand_size)
    end
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