SMODS.Joker({
    key = "proletaire",
    atlas = "jokers",
    pos = {x = 0, y = 15},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    config = {extra = {xmult = 1, gain = 0.1}},
    loc_vars = function(self, info_queue, card)
        if card and not card.fake_card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo'} end
        return {vars = {card.ability.extra.gain, card.ability.extra.xmult}}
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local upgrade = false
            for _, pcard in pairs(G.play.cards) do
                if pcard.ability.was_flipped or card.debuffed then
                    pcard.ability.was_flipped = nil
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.gain
                    upgrade = true
                end
            end
            if upgrade then return {message = localize('k_upgrade_ex'), colour = G.C.RED} end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end    
})