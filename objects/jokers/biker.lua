SMODS.Joker({
    key = "biker",
    atlas = "jokers",
    pos = {x = 5, y = 8},
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {gain = 1}},
    loc_vars = function(self, info_queue, card)
        if card and not card.fake_card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo'} end
        return {vars = {card.ability.extra.gain}}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult + 1
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.RED
            }
        end
    end    
})