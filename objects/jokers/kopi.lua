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
                card.ability.extra.current = 0
                if #G.jokers.cards == 1 then SMODS.calculate_effect({message = localize('ortalab_kopi_no'), colour = HEX('dfb958')}, card); return end
                SMODS.calculate_effect({message = localize('ortalab_kopi'), colour = HEX('dfb958')}, card)
                local joker = pseudorandom_element(G.jokers.cards, 'ortalab_kopi')
                while (joker == card or joker.ability.kopi) do
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
                        copy:set_cost()
                        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
                        return true
                    end
                }))
            else
                SMODS.calculate_effect({message = card.ability.extra.current..'/'..card.ability.extra.target, colour = HEX('dc9d6c')}, card)
            end
        end
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