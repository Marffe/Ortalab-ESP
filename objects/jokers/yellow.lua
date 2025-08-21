SMODS.Joker({
    key = "yellow",
    atlas = "jokers",
    pos = {x = 0, y = 14},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {gain = 1, mult = 0}},
    artist_credits = {'kosze'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.gain, card.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        if context.before or context.pre_discard and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + (card.ability.extra.gain * (context.scoring_hand and #context.scoring_hand or #context.full_hand))
            return {
                message = localize('k_upgrade_ex'),
                message_card = card
            }
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.end_of_round and context.main_eval and not context.blueprint then
            card.ability.extra.mult = 0
            return {
                message = localize('ortalab_joker_miles_reset')
            }
        end
    end    
})