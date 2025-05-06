SMODS.Joker({
    key = "koko",
    atlas = "jokers",
    pos = {x = 2, y = 12},
    soul_pos = {x = 3, y = 12},
    rarity = 4,
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {zodiacs = {}, increase = 1}},
    artist_credits = {'gappie'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.increase}}
    end,
    set_ability = function(self, card, initial, delay)
        for k, _ in pairs(G.ZODIACS) do
            card.ability.extra.zodiacs[#card.ability.extra.zodiacs+1] = k
        end
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
           
            return {
                func = function()
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.4,
                        func = function()
                            ease_background_colour{new_colour = G.C.BLUE, contrast = 1}                
                            return true
                        end
                    }))
                end,
                extra = {
                    func = function()
                        for _, key in ipairs(card.ability.extra.zodiacs) do
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.1,
                                func = function()
                                    if G.zodiacs and G.zodiacs[key] then
                                        G.zodiacs[key].config.extra.temp_level = G.zodiacs[key].config.extra.temp_level + (card.ability.extra.increase * G.GAME.ortalab.zodiacs.temp_level_mod)
                                    else
                                        add_zodiac(Zodiac(key), true)
                                    end
                                    return true
                                end
                            }))
                        end
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.7,
                            func = function()
                                ease_background_colour{new_colour = G.C.BLIND['Small'], contrast = 1}                
                                return true
                            end
                        }))
                    end,
                    message = 'Hee hee!',
                    colour = G.C.BLUE,
                }
            }
        end
    end    
})

