SMODS.Joker({
    key = "hit_the_gym",
    atlas = "jokers",
    pos = {x = 0, y = 8},
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {gain = 0.75, current = 1}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'akai'} end
        return {vars = {card.ability.extra.gain, card.ability.extra.current, localize('Jack', 'ranks')}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            card.ability.extra.current = 1
            return {
                message = localize('ortalab_joker_miles_reset')
            }
        end
        if context.before then
            for _, _card in pairs(context.scoring_hand) do
                if _card:get_id() == 11 then
                    card.ability.extra.current = card.ability.extra.current + card.ability.extra.gain
                    SMODS.calculate_effect({
                        message = localize('ortalab_joker_miles'),
                        colour = G.C.RED,
                        message_card = card,
                        juice_card = _card
                    }, _card)
                end            
            end
        end
        if context.joker_main and card.ability.extra.current > 1 then
            return {
                xmult = card.ability.extra.current
            }
        end
    end    
})