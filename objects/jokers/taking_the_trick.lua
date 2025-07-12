SMODS.Joker({
    key = "taking_the_trick",
    atlas = "jokers",
    pos = {x = 2, y = 15},
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    config = {extra = {mult = 0, gain = 2}},
    artist_credits = {'no_demo'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.gain, card.ability.extra.mult, localize(card.ability.extra.suit, 'suits_singular'), localize(card.ability.extra.rank..'', 'ranks'), colours = {G.C.SUITS[card.ability.extra.suit]}}}
    end,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.suit = pseudorandom_element(SMODS.Suits, pseudoseed('ortalab_trick_suit')).name
        card.ability.extra.rank = pseudorandom_element(SMODS.Ranks, pseudoseed('ortalab_trick_rank')).key
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            for _, _card in pairs(context.scoring_hand) do
                if _card:is_suit(card.ability.extra.suit) and _card.base.id > SMODS.Ranks[card.ability.extra.rank].id then
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.RED
                    }
                end
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.end_of_round and context.main_eval and not context.blueprint then
            card.ability.extra.suit = pseudorandom_element(SMODS.Suits, pseudoseed('ortalab_trick_suit')).name
            card.ability.extra.rank = pseudorandom_element(SMODS.Ranks, pseudoseed('ortalab_trick_rank')).key
            return {
                message = localize(card.ability.extra.rank ..'', 'ranks') .. ' of ' .. localize(card.ability.extra.suit, 'suits_plural'),
                no_retrigger = true
            }
        end
    end    
})