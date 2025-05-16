SMODS.Joker({
    key = "false_phd",
    atlas = "jokers",
    pos = {x = 7, y = 14},
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {cards = 2}},
    artist_credits = {'rowan'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.cards}}
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then 
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.7,
                func = function()     
                    local _suit = pseudorandom_element(SMODS.Suits, pseudoseed('ortalab_false_phd_suit')).card_key
                    local _rank = pseudorandom_element(SMODS.Ranks, pseudoseed('ortalab_false_phd_rank')).card_key
                    
                    local enhancement = SMODS.poll_enhancement({key = 'ortalab_false_phd_enhance'}) or 'c_base'
                    local edition = poll_edition('ortalab_false_phd_edition', nil, false)
                    local curse = pseudorandom_element(Ortalab.Curses, pseudoseed('ortalab_false_phd_curse')).key
                    for i=1, card.ability.extra.cards do
                        local new_card = create_playing_card({front = G.P_CARDS[_suit..'_'.._rank], center = G.P_CENTERS[enhancement]}, G.hand, nil, nil, {G.C.SET.Mythos, darken(G.C.SET.Mythos, 0.5), G.C.RED, darken(G.C.SET.Mythos, 0.2), G.ARGS.LOC_COLOURS['mythos_alt']})
                        new_card:set_edition(edition, true)
                        new_card:set_curse(curse, true, true)
                    end
                    card:juice_up()
                    return true
                end
            }))
            return nil, true            
        end
    end    
})