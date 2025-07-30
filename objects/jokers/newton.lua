SMODS.Joker({
    key = "newton",
    atlas = "jokers",
    pos = {x = 3, y = 15},
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {gain = 100, loss = -100}},
    artist_credits = {'gappie'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.gain, card.ability.extra.loss}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local extra
            if G.GAME.current_round.hands_played == 0 then extra = {chips = card.ability.extra.loss} end
            return {
                chips = card.ability.extra.gain,
                extra = extra
            }
        end
    end    
})