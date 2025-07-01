SMODS.Joker({
    key = "kopi",
    atlas = "jokers",
    pos = {x = 8, y = 11},
    soul_pos = {x = 9, y = 11},
    rarity = 4,
    cost = 20,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {target = 3, current = 0}},
    artist_credits = {'gappie'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.target, card.ability.extra.current}}
    end,
    calculate = function(self, card, context)
        if context.using_consumeable then
            card.ability.extra.current = card.ability.extra.current + 1
            if card.ability.extra.current == card.ability.extra.target then
                SMODS.calculate_effect({message = localize('ortalab_kopi'), colour = HEX('dfb958')}, card)
                card.ability.extra.current = 0
                local joker = pseudorandom_element(G.jokers.cards, 'ortalab_kopi')
                while (joker.config.center_key == 'j_ortalab_kopi' or joker.ability.kopi) do
                    joker = pseudorandom_element(G.jokers.cards, 'ortalab_kopi_resample')
                end
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.7,
                    func = function()
                        local copy = copy_card(joker, nil, nil, nil, true) -- strips edition
                        copy:set_curse()
                        G.jokers:emplace(copy)
                        copy:add_to_deck()
                        copy:start_materialize({HEX('dc9d6c')})
                        copy.ability.kopi = true
                        copy.ignore_base_shader = {kopi = true}
                        copy.ignore_shadow = {kopi = true}
                        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
                        return true
                    end
                }))
            else
                SMODS.calculate_effect({message = card.ability.extra.current..'/'..card.ability.extra.target, colour = HEX('dc9d6c')}, card)
            end
        end
        if context.end_of_round and context.main_eval then
            for _, joker in ipairs(G.jokers.cards) do
                if joker.ability.kopi then
                    SMODS.destroy_cards(joker)
                    G.jokers.config.card_limit = G.jokers.config.card_limit - 1
                end
            end
        end
        -- if context.hand_drawn and #context.hand_drawn == card.ability.extra.drawn_size then
        --     SMODS.calculate_effect({message = 'Kopied!', colour = G.C.MONEY}, card)
        --     local created_cards = {}
        --     for _, _card in pairs(context.hand_drawn) do
        --         created_cards[#created_cards + 1] = copy_card(_card, nil, nil, G.playing_card)
        --         _card:juice_up()
        --     end
        --     for i, _card in ipairs(created_cards) do
        --         _card:add_to_deck()
        --         G.deck.config.card_limit = G.deck.config.card_limit + 1
        --         table.insert(G.playing_cards, _card)
        --         G.deck:emplace(_card)
        --     end
        --     G.deck:shuffle('ortalab_kopi')
        --     playing_card_joker_effects(created_cards)
        --     card.ability.extra.drawn_size = pseudorandom('ortalab_kopi', 1, 5)
        --     return {
        --         message = 'Draw '.. card.ability.extra.drawn_size,
        --         colour = G.C.MONEY
        --     }
        -- end
    end    
})

local ortalab_start_dissolve = Card.start_dissolve
function Card:start_dissolve(dissolve_colours, silent, dissolve_time_fac, no_juice)
    if self.ability.kopi then dissolve_colours = {HEX('dc9d6c')} end
    ortalab_start_dissolve(self, dissolve_colours, silent, dissolve_time_fac, no_juice)
end

SMODS.DrawStep {
    key = 'kopi',
    order = 100,
    func = function(self)
        if self.ability.kopi then
            self.children.center:draw_shader('ortalab_kopi', nil, self.ARGS.send_to_shader)
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}

SMODS.Shader({key = 'kopi', path = 'kopi.fs'})

G.ARGS.LOC_COLOURS['kopi'] = HEX('dfb958')