SMODS.Joker({
    key = "kopi",
    atlas = "jokers",
    pos = {x = 8, y = 11},
    soul_pos = {x = 9, y = 11},
    rarity = 4,
    cost = 20,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {drawn_size = 3}},
    artist_credits = {'gappie'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.drawn_size}}
    end,
    set_ability = function(self, card, initial, delay)
        card.ability.extra.drawn_size = pseudorandom('ortalab_kopi', 1, 5)
    end,
    calculate = function(self, card, context)
        if context.hand_drawn and #context.hand_drawn == card.ability.extra.drawn_size then
            SMODS.calculate_effect({message = 'Kopied!', colour = G.C.MONEY}, card)
            local created_cards = {}
            for _, _card in pairs(context.hand_drawn) do
                created_cards[#created_cards + 1] = copy_card(_card, nil, nil, G.playing_card)
                _card:juice_up()
            end
            for i, _card in ipairs(created_cards) do
                _card:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                table.insert(G.playing_cards, _card)
                G.deck:emplace(_card)
            end
            G.deck:shuffle('ortalab_kopi')
            playing_card_joker_effects(created_cards)
            card.ability.extra.drawn_size = pseudorandom('ortalab_kopi', 1, 5)
            return {
                message = 'Draw '.. card.ability.extra.drawn_size,
                colour = G.C.MONEY
            }
        end
    end    
})