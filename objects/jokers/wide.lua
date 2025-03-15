SMODS.Joker({
    key = "wide",
    atlas = "jokers",
    pos = {x = 8, y = 14},
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    config = {extra = {mult = 4, gain = 2}},
    loc_vars = function(self, info_queue, card)
        if card and not card.fake_card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo'} end
        return {vars = {card.ability.extra.gain, card.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 10 then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
                return {
                    message = localize('k_upgrade_ex'),
                    message_card = card,
                    colour = G.C.RED
                }
            end
        end
    end    
})