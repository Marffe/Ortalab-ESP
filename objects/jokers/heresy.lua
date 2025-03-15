SMODS.Joker({
    key = "heresy",
    atlas = "jokers",
    pos = {x = 9, y = 7},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    config = {extra = {chips = 0, mult = 0, chip_gain = 20, mult_gain = 5}},
    loc_vars = function(self, info_queue, card)
        if card and not card.fake_card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.chip_gain, card.ability.extra.mult_gain, card.ability.extra.chips, card.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        if context.playing_card_added and not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips + (card.ability.extra.chip_gain * #context.cards)
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.BLUE
            }
        end
        if context.remove_playing_cards then
            card.ability.extra.mult = card.ability.extra.mult + (card.ability.extra.mult_gain * #context.removed)
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.RED
            }
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
    end    
})