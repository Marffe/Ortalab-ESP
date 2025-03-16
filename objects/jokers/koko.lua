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
    config = {extra = {zodiacs = {}}},
    loc_vars = function(self, info_queue, card)
        if card and not card.fake_card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
    end,
    set_ability = function(self, card, initial, delay)
        for k, _ in pairs(G.ZODIACS) do
            card.ability.extra.zodiacs[#card.ability.extra.zodiacs+1] = k
        end
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    ease_background_colour{new_colour = G.C.BLUE, contrast = 1}                
                    return true
                end
            }))
            
            for _, key in ipairs(card.ability.extra.zodiacs) do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        if G.zodiacs and G.zodiacs[key] then
                            
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
            return {
                message = 'Hee hee!',
                colour = G.C.BLUE
            }
        end
    end    
})

