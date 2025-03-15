SMODS.Joker({
    key = "driver",
    atlas = "jokers",
    pos = {x = 4, y = 4},
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    config = {extra = {gain = 1, mult = 0}},
    loc_vars = function(self, info_queue, card)
        if card and not card.fake_card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo'} end
        return {vars = {card.ability.extra.gain, card.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        if context.before and #context.full_hand > 1 then
            local rank = context.full_hand[1]:get_id()
            for i=2, #context.full_hand do
                if rank ~= context.full_hand[i]:get_id() then
                    return
                end
            end
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
            return {
                message = localize('k_upgrade_ex')
            }
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end    
})