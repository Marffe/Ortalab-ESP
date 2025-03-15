SMODS.Joker({
    key = "newton",
    atlas = "jokers",
    pos = {x = 3, y = 15},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {gain = 100, loss = -200}},
    loc_vars = function(self, info_queue, card)
        if card and not card.fake_card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo'} end
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