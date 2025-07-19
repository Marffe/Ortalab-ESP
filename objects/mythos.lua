SMODS.Atlas({
    key = 'mythos_cards',
    path = 'mythos.png',
    px = '71',
    py = '95'
})

SMODS.UndiscoveredSprite({
    key = "Mythos",
    atlas = "mythos_cards",
    pos = { x = 4, y = 3 },
    no_overlay = true
})

SMODS.Shader({
    key = 'mythos',
    path = 'mythos.fs'
})

G.ARGS.LOC_COLOURS['Mythos'] = HEX("57405f")
G.ARGS.LOC_COLOURS['mythos_alt'] = HEX('ecde33')

SMODS.ConsumableType({
    key = "Mythos",
    primary_colour = HEX("57405f"),
    secondary_colour = HEX("57405f"),
    loc_txt = {
        name = "Mythos",
        collection = "Mythos Cards",
        undiscovered = {
            name = 'Unknown Mythos Card',
            text = {
                'Find this card in an unseeded',
                'run to find out what it does'
            }
        }
    },
    collection_rows = {5, 4},
    shop_rate = 0,
    default = 'c_ortalab_zod_aries',
})

SMODS.DrawStep {
    key = 'mythos_shine',
    order = 10,
    func = function(self)
        if self.ability.set == 'Mythos' or self.config.center.group_key == 'ortalab_mythos_pack' then
            self.children.center:draw_shader('ortalab_mythos', nil, self.ARGS.send_to_shader)
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}

Ortalab.Mythos_Utils = {}

Ortalab.Mythos_Utils.snakes_modify = {
    function(card, seed) card:set_ability(SMODS.poll_enhancement({guaranteed = true, key = seed..'_enhancement', no_replace = true})) end,
    function(card, seed) card:set_edition(poll_edition(seed..'_edition', nil, false, true), true) end,
    function(card, seed) card:set_seal(SMODS.poll_seal({guaranteed = true, key = seed..'_seal'}), nil, true) end
}

Ortalab.Mythos_Utils.can_curse_in_area = function(area, amount, modifier)
    local uncursed_cards = 0
    for _, card in pairs(area.cards or area) do
        if not card.curse then uncursed_cards = uncursed_cards + 1 end
    end
    if uncursed_cards >= amount + (modifier or 0) + G.GAME.ortalab.mythos.extra_select then
        return true
    end
end

Ortalab.Mythos_Utils.curse_random_hand = function(card, curses, modifier)
    -- unhighlight all cards in hand
    G.E_MANAGER:add_event(Event({
        trigger = 'after', delay = 0.5,
        func = function()
            G.hand:unhighlight_all()
            return true
        end
    }))
    -- apply curse to random cards in hand
    for i=1, card.ability.extra.select + G.GAME.ortalab.mythos.extra_select + (modifier or 0) do
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.5,
            func = function()
                local select = true
                while select do
                    local p_card = pseudorandom_element(G.hand.cards, pseudoseed(card.config.center_key..'_curse'))
                    if not p_card.highlighted and not p_card.curse then 
                        G.hand:add_to_highlighted(p_card)
                        local curse = curses and curses[(i%#curses)+1] or pseudorandom_element(Ortalab.Curses, 'ortalab_curse_default').key
                        p_card:set_curse(curse, false, true)
                        p_card:juice_up()
                        card:juice_up(0.3, 0.5)
                        select = false
                    end
                end
                return true
            end
        }))
    end
    -- unhighlight all cards in hand
    G.E_MANAGER:add_event(Event({
        trigger = 'after', delay = 0.5,
        func = function()
            G.hand:unhighlight_all()
            return true
        end
    }))
end

Ortalab.Mythos_Utils.curse_random_cards = function(card, cards, curses, modifier)
    -- apply curse to random cards in hand
    for i=1, card.ability.extra.select + G.GAME.ortalab.mythos.extra_select + (modifier or 0) do
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.5,
            func = function()
                local select = true
                while select do
                    local p_card = pseudorandom_element(cards, pseudoseed(card.config.center_key..'_curse'))
                    if not p_card.curse then 
                        local curse = curses and curses[(i%#curses)+1] or pseudorandom_element(Ortalab.Curses, 'ortalab_curse_default').key
                        p_card:set_curse(curse, false, true)
                        if p_card.area == G.deck then G.deck.cards[1]:juice_up() else p_card:juice_up() end
                        card:juice_up(0.3, 0.5)
                        select = false
                    end
                end
                return true
            end
        }))
    end
end

-- Excalibur
SMODS.Consumable({
    key = 'excalibur',
    set = 'Mythos',
    atlas = 'mythos_cards',
    cost = 5,
    pos = {x=0, y=0},
    discovered = false,
    config = {extra = {select = 1, curse = 'ortalab_infected', method = 'c_ortalab_one_deck', multiplier = 2}},
    artist_credits = {'gappie'},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {set = 'Curse', key = card.ability.extra.curse}
        return {vars = {localize(G.GAME.last_hand_played or 'High Card', 'poker_hands')}}
    end,
    can_use = function(self, card)
        return G.GAME.last_hand_played and Ortalab.Mythos_Utils.can_curse_in_area(G.deck, card.ability.extra.select)
    end,
    use = function(self, card, area, copier)
        -- Get the name of the last played hand
        local _handname = G.GAME.last_hand_played
        -- Find zodiac key (defaults to High Card if played hand has no zodiac)
        local key = G.P_CENTERS[zodiac_from_hand(_handname) or 'High Card'].config.extra.zodiac
        
        -- Add zodiac for last played hand with twice as many levels
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 1,
            func = function()
                if G.zodiacs and G.zodiacs[key] then
                    G.zodiacs[key].config.extra.temp_level = G.zodiacs[key].config.extra.temp_level + (G.ZODIACS[key].config.extra.temp_level * card.ability.extra.multiplier) -- double the level
                    zodiac_text(zodiac_upgrade_text(key), key)
                    G.zodiacs[key]:juice_up(1, 1)
                    delay(0.7)
                else
                    add_zodiac(Zodiac(key), nil, nil, card.ability.extra.multiplier)
                end
                return true
            end
        }))

        -- Curse a random card in deck
        Ortalab.Mythos_Utils.curse_random_cards(card, G.deck.cards, {card.ability.extra.curse})
    end
})

-- Tree of Life
SMODS.Consumable({
    key = 'tree_of_life',
    set = 'Mythos',
    atlas = 'mythos_cards',
    cost = 5,
    pos = {x=1, y=0},
    discovered = false,
    config = {extra = {select = 4, curse = 'ortalab_all_curses', method = 'c_ortalab_mult_random', slots = 1, perish_count = 5}},
    artist_credits = {'gappie'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.slots, card.ability.extra.perish_count + G.GAME.ortalab.mythos.tree_of_life_count}}
    end,
    can_use = function(self, card)
        local unperish = 0
        for _, joker in pairs(G.jokers.cards) do
            if not joker.ability.perishable then unperish = unperish + 1 end
        end
        if Ortalab.Mythos_Utils.can_curse_in_area(G.hand.cards, card.ability.extra.select) and unperish >= card.ability.extra.perish_count + G.GAME.ortalab.mythos.tree_of_life_count then
            return true
        end
    end,
    use = function(self, card, area, copier)
        -- Add Joker slots
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.5,
            func = function()
                modify_joker_slot_count(card.ability.extra.slots)
                return true
            end
        }))

        -- Add Perishable to jokers
        local available_jokers = {}    
        for _, joker in pairs(G.jokers.cards) do
            if not joker.ability.perishable then
                available_jokers[#available_jokers + 1] = joker
            end
        end
        for i=1, card.ability.extra.perish_count + G.GAME.ortalab.mythos.tree_of_life_count do
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.7,
                func = function()
                    local joker, pos = pseudorandom_element(available_jokers, pseudoseed('tree_perish'))
                    SMODS.Stickers.perishable:apply(joker, true)
                    joker:juice_up()
                    play_sound('tarot1')
                    card:juice_up(0.3, 0.5)
                    table.remove(available_jokers, pos)
                    return true
                end
            }))
        end

        -- Increment perishable modifier for future uses
        G.GAME.ortalab.mythos.tree_of_life_count = G.GAME.ortalab.mythos.tree_of_life_count + 1

        -- Curse cards in hand 
        Ortalab.Mythos_Utils.curse_random_hand(card, {'ortalab_corroded', 'ortalab_infected', 'ortalab_possessed', 'ortalab_restrained'})
    end
})

-- Genie's Lamp
SMODS.Consumable({
    key = 'genie',
    set = 'Mythos',
    atlas = 'mythos_cards',
    cost = 5,
    pos = {x=2, y=0},
    discovered = false,
    config = {extra = {select = 3, curse = 'ortalab_corroded', method = 'c_ortalab_mult_random_deck', hands = 3, levels = 2}},
    artist_credits = {'gappie'},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {set = 'Curse', key = card.ability.extra.curse, specific_vars = {Ortalab.Curses[card.ability.extra.curse].config.extra.base, Ortalab.Curses[card.ability.extra.curse].config.extra.gain}}
        return {vars = {card.ability.extra.hands, card.ability.extra.levels}}
    end,
    can_use = function(self, card)
        return Ortalab.Mythos_Utils.can_curse_in_area(G.deck.cards, card.ability.extra.select)
    end,
    use = function(self, card, area, copier)
        -- Create list of visible hands
        local visible_hands = {}
        for _, v in ipairs(G.handlist) do
            if SMODS.is_poker_hand_visible(v) then
                table.insert(visible_hands, v)
            end
        end
        -- Level up card.ability.extra.hands number of hands
        card.jimbo = true
        for i=1, card.ability.extra.hands do
            local hand, pos = pseudorandom_element(visible_hands, 'ortalab_genie_hand')
            table.remove(visible_hands, pos)
            SMODS.calculate_effect({message = localize(hand, 'poker_hands'), colour = G.ARGS.LOC_COLOURS.mythos_alt}, card)
            SMODS.smart_level_up_hand(card, hand, nil, card.ability.extra.levels)
        end

        -- Curse random cards in deck
        Ortalab.Mythos_Utils.curse_random_cards(card, G.deck.cards, {card.ability.extra.curse})
    end
})

-- Pandora's Box
SMODS.Consumable({
    key = 'pandora',
    set = 'Mythos',
    atlas = 'mythos_cards',
    cost = 5,
    pos = {x=3, y=0},
    discovered = false,
    config = {extra = {select = 4, curse = 'ortalab_all_curses', method = 'c_ortalab_mult_pandora', choose = 1, copies = 4}},
    artist_credits = {'gappie'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.copies}}
    end,
    can_use = function(self, card)
        return #G.hand.highlighted == card.ability.extra.choose and not G.hand.highlighted[1].curse
    end,
    use = function(self, card, area, copier)
        -- create 4 copies in G.play
        local copies = {}
        for i=1, card.ability.extra.copies do
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.7,
                func = function()
                    local new_card = copy_card(G.hand.highlighted[1], nil, nil, G.playing_card)
                    new_card:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(G.playing_cards, new_card)
                    G.play:emplace(new_card)
                    new_card:start_materialize({G.C.SET.Mythos})
                    card:juice_up(0.3, 0.5)
                    copies[i] = new_card
                    return true
                end
            }))
        end
        playing_card_joker_effects(copies)  

        -- destroy original card
        SMODS.destroy_cards(G.hand.highlighted[1])

        -- curse each new copy
        Ortalab.Mythos_Utils.curse_random_cards(card, copies, {'ortalab_corroded', 'ortalab_infected', 'ortalab_possessed', 'ortalab_restrained'})

        -- shuffle into deck
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.4,
            func = function()
                for _, copy in ipairs(copies) do
                    draw_card(G.play, G.deck, nil, nil, nil, copy)
                    print('pla')
                end
                return true
            end
        }))
        G.deck:shuffle()
    end
})

-- Holy Grail
SMODS.Consumable({
    key = 'holy_grail',
    set = 'Mythos',
    atlas = 'mythos_cards',
    cost = 5,
    pos = {x=4, y=0},
    discovered = false,
    config = {extra = {select = 2, curse = 'ortalab_infected', method = 'c_ortalab_mult_random', cards = 1}},
    artist_credits = {'gappie'},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {set = 'Curse', key = card.ability.extra.curse}
    end,
    can_use = function(self, card)
        if #G.hand.highlighted == card.ability.extra.cards then
            return Ortalab.Mythos_Utils.can_curse_in_area(G.hand.cards, card.ability.extra.select)
        end
    end,
    use = function(self, card, area, copier)
        -- Add a random seal
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.5,
            func = function()
                G.hand.highlighted[1]:set_seal(SMODS.poll_seal({guaranteed = true, seed = 'ortalab_holy_grail_seal'}), true)
                G.hand.highlighted[1]:juice_up()
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.4,
            func = function()
                G.hand:unhighlight_all()                
                return true
            end
        }))

        -- Curse cards in hand
        Ortalab.Mythos_Utils.curse_random_hand(card, {card.ability.extra.curse})
    end
})

-- Talaria
SMODS.Consumable({
    key = 'talaria',
    set = 'Mythos',
    atlas = 'mythos_cards',
    cost = 5,
    pos = {x=0, y=3},
    discovered = false,
    config = {extra = {select = 3, curse = 'ortalab_restrained', method = 'c_ortalab_mult_random_deck'}},
    artist_credits = {'gappie'},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {set = 'Curse', key = card.ability.extra.curse, specific_vars = {Ortalab.Curses[card.ability.extra.curse].config.extra.level_loss}}
    end,
    can_use = function(self, card)
        return Ortalab.Mythos_Utils.can_curse_in_area(G.deck.cards, card.ability.extra.select, G.GAME.ortalab.mythos.talaria_count)
    end,
    use = function(self, card, area, copier)
        -- curse cards
        Ortalab.Mythos_Utils.curse_random_cards(card, G.deck.cards, {card.ability.extra.curse}, G.GAME.ortalab.mythos.talaria_count)
        G.GAME.ortalab.mythos.talaria_count = G.GAME.ortalab.mythos.talaria_count + 1
        
        -- Generate a random voucher
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.5,
            func = function()
                local voucher = get_next_voucher_key(true)
                local voucher_card = SMODS.create_card({area = G.play, key = voucher})
                voucher_card:start_materialize({G.C.SET.Mythos})
                voucher_card.cost = 0
                G.play:emplace(voucher_card)
                delay(0.8)
                voucher_card:redeem()
                
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = 0.5,
                    func = function()
                        voucher_card:start_dissolve()                
                        return true
                    end
                }))
                return true
            end
        }))
    end
})

-- Basilisk
SMODS.Consumable({
    key = 'basilisk',
    set = 'Mythos',
    atlas = 'mythos_cards',
    cost = 5,
    pos = {x=0, y=1},
    discovered = false,
    config = {extra = {select = 1, curse = 'ortalab_infected', method = 'c_ortalab_one_selected', cards = 3}},
    artist_credits = {'eremel'},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {set = 'Curse', key = card.ability.extra.curse}
        return {vars = {card.ability.extra.cards}}
    end,
    can_use = function(self, card)
        return Ortalab.Mythos_Utils.can_curse_in_area(G.hand, card.ability.extra.select)
    end,
    use = function(self, card, area, copier)
        -- add 3 enhanced/editioned Face cards
        local cards = {}
        local faces = {}
        for _, v in ipairs(SMODS.Rank.obj_buffer) do
            local r = SMODS.Ranks[v]
            if r.face then table.insert(faces, r) end
        end

        for i=1, card.ability.extra.cards do
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.7,
                func = function()
                    local _suit = pseudorandom_element(SMODS.Suits, pseudoseed('ortalab_basilisk_suit')).card_key
                    local _rank = pseudorandom_element(faces, pseudoseed('ortalab_basilisk_rank')).card_key
                    local new_card = create_playing_card({front = G.P_CARDS[_suit..'_'.._rank]}, G.hand, nil, i ~= 1, {G.C.SET.Mythos, darken(G.C.SET.Mythos, 0.5), G.C.RED, darken(G.C.SET.Mythos, 0.2), G.ARGS.LOC_COLOURS['mythos_alt']})
                    Ortalab.Mythos_Utils.snakes_modify[i](new_card, 'ortalab_basilisk')
                    new_card:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    new_card:juice_up()
                    card:juice_up(0.3, 0.5)
                    cards[i] = new_card
                    return true
                end
            }))
        end
        playing_card_joker_effects(cards)    

        -- set the curse
        Ortalab.Mythos_Utils.curse_random_hand(card, {card.ability.extra.curse})            
    end
})

-- Abaia
SMODS.Consumable({
    key = 'abaia',
    set = 'Mythos',
    atlas = 'mythos_cards',
    cost = 5,
    pos = {x=4, y=2},
    discovered = false,
    config = {extra = {select = 1, curse = 'ortalab_restrained', method = 'c_ortalab_one_selected', cards = 3, rank = 7}},
    artist_credits = {'kosze'},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {set = 'Curse', key = card.ability.extra.curse, specific_vars = {Ortalab.Curses[card.ability.extra.curse].config.extra.level_loss}}
        return {vars = {card.ability.extra.cards, card.ability.extra.rank}}
    end,
    can_use = function(self, card)
        return Ortalab.Mythos_Utils.can_curse_in_area(G.hand, card.ability.extra.select)
    end,
    use = function(self, card, area, copier)
        -- add 3 enhanced/editioned Face cards
        local cards = {}
        for i=1, card.ability.extra.cards do
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.7,
            func = function()
                local _suit = pseudorandom_element(SMODS.Suits, pseudoseed('ortalab_abaia_suit')).card_key
                local new_card = create_playing_card({front = G.P_CARDS[_suit..'_7']}, G.hand, nil, i ~= 1, {G.C.SET.Mythos, darken(G.C.SET.Mythos, 0.5), G.C.RED, darken(G.C.SET.Mythos, 0.2), G.ARGS.LOC_COLOURS['mythos_alt']})
                Ortalab.Mythos_Utils.snakes_modify[i](new_card, 'ortalab_abaia')
                new_card:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                new_card:juice_up()
                card:juice_up(0.3, 0.5)
                cards[i] = new_card
                return true
                end
            }))
        end
        playing_card_joker_effects(cards)  

        -- set the curse
        Ortalab.Mythos_Utils.curse_random_hand(card, {card.ability.extra.curse})              
    end
})

-- Jormungand
SMODS.Consumable({
    key = 'jormungand',
    set = 'Mythos',
    atlas = 'mythos_cards',
    cost = 5,
    pos = {x=1, y=2},
    discovered = false,
    config = {extra = {select = 1, curse = 'ortalab_corroded', method = 'c_ortalab_one_selected', cards = 3, rank = 'A'}},
    artist_credits = {'kosze'},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {set = 'Curse', key = card.ability.extra.curse, specific_vars = {Ortalab.Curses[card.ability.extra.curse].config.extra.base, Ortalab.Curses[card.ability.extra.curse].config.extra.gain}}
        return {vars = {card.ability.extra.cards}}
    end,
    can_use = function(self, card)
        return Ortalab.Mythos_Utils.can_curse_in_area(G.hand, card.ability.extra.select)
    end,
    use = function(self, card, area, copier)
        -- add 3 enhanced/editioned Face cards
        local cards = {}
        for i=1, card.ability.extra.cards do
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()
                local _suit = pseudorandom_element(SMODS.Suits, pseudoseed('ortalab_jormungand_suit')).card_key
                local new_card = create_playing_card({front = G.P_CARDS[_suit..'_A']}, G.hand, nil, i ~= 1, {G.C.SET.Mythos, darken(G.C.SET.Mythos, 0.5), G.C.RED, darken(G.C.SET.Mythos, 0.2), G.ARGS.LOC_COLOURS['mythos_alt']})
                Ortalab.Mythos_Utils.snakes_modify[i](new_card, 'ortalab_jormungand')
                new_card:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                new_card:juice_up()
                card:juice_up(0.3, 0.5)
                cards[i] = new_card
                return true
                end
            }))
        end
        playing_card_joker_effects(cards)  
        
        -- set the curse
        Ortalab.Mythos_Utils.curse_random_hand(card, {card.ability.extra.curse})
    end
})

-- Gnome
SMODS.Consumable({
    key = 'gnome',
    set = 'Mythos',
    atlas = 'mythos_cards',
    cost = 5,
    pos = {x=3, y=2},
    discovered = false,
    config = {extra = {select = 1, money_gain = 2, curse = 'ortalab_corroded', method = 'c_ortalab_mult_random_joker'}},
    artist_credits = {'gappie'},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {set = 'Curse', key = card.ability.extra.curse..'_joker', specific_vars = {Ortalab.Curses[card.ability.extra.curse].config.extra.gain}}
        local total_value = self.total_value(card)
        return {vars = {card.ability.extra.money_gain, total_value}}
    end,
    can_use = function(self, card)
        return Ortalab.Mythos_Utils.can_curse_in_area(G.jokers.cards, card.ability.extra.select)
    end,
    use = function(self, card, area, copier)
        -- Give current sell costs as dollars
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.7,
            func = function()
                ease_dollars(self.total_value(card), true)                
                return true
            end
        }))
        
        -- Increase value of all jokers
        for k=1, #G.jokers.cards + #G.consumeables.cards do
            local _card = G.jokers.cards[k] or G.consumeables.cards[k - #G.jokers.cards]
            if _card.config.center.set == 'Joker' then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = 0.5,
                    func = function()                
                        card:juice_up(0.3, 0.5)
                        _card.ability.extra_value = _card.ability.extra_value + card.ability.extra.money_gain
                        _card:set_cost()
                        SMODS.calculate_effect({message = '+$'..card.ability.extra.money_gain, colour = G.C.GOLD, instant = true, sound = 'coin1'}, _card)
                        _card:juice_up()
                        return true
                    end
                }))
            end
        end

        -- Curse a random joker
        Ortalab.Mythos_Utils.curse_random_cards(card, G.jokers.cards, {card.ability.extra.curse})
    end,
    total_value = function(card)
        local total_value = 0
        if not G.jokers then return total_value end
        for k=1, #G.jokers.cards + #G.consumeables.cards do
            local _card = G.jokers.cards[k] or G.consumeables.cards[k - #G.jokers.cards]
            if _card.config.center.set == 'Joker' then
                total_value = total_value + _card.sell_cost
            end
        end
        return total_value
    end
})

-- Crawler
SMODS.Consumable({
    key = 'crawler',
    set = 'Mythos',
    atlas = 'mythos_cards',
    cost = 5,
    pos = {x=3, y=1},
    discovered = false,
    config = {extra = {select = 1, curse = 'ortalab_restrained', method = 'c_ortalab_mult_random_joker'}},
    artist_credits = {'gappie'},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {set = 'Curse', key = card.ability.extra.curse..'_joker', specific_vars = {Ortalab.Curses[card.ability.extra.curse].config.extra.level_loss}}
    end,
    can_use = function(self, card)
        return Ortalab.Mythos_Utils.can_curse_in_area(G.jokers.cards, card.ability.extra.select) and next(SMODS.Edition:get_edition_cards(G.jokers, true))
    end,
    use = function(self, card, area, copier)
        -- Edition on joker
        local valid_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)
        local selected = pseudorandom_element(valid_jokers, pseudoseed('ortalab_crawler'))
        local edition = poll_edition('ortalab_crawler_edition',nil,false,true)
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.7,
            func = function()
                card:juice_up(0.3, 0.5)
                selected:set_edition(edition, true)
                return true
            end
        }))
        SMODS.calculate_effect({message = localize{type = 'name_text', set = 'Edition', key = edition}, colour = G.C.DARK_EDITION}, selected)
        
        -- Curse random joker
        Ortalab.Mythos_Utils.curse_random_cards(card, G.jokers.cards, {card.ability.extra.curse}) 
    end
})

-- Kraken
SMODS.Consumable({
    key = 'kraken',
    set = 'Mythos',
    atlas = 'mythos_cards',
    cost = 5,
    pos = {x=2, y=1},
    discovered = false,
    config = {extra = {select = 1, curse = 'ortalab_corroded', method = 'c_ortalab_one_selected', cards = 3}},
    artist_credits = {'gappie'},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {set = 'Curse', key = card.ability.extra.curse, specific_vars = {Ortalab.Curses[card.ability.extra.curse].config.extra.base, Ortalab.Curses[card.ability.extra.curse].config.extra.gain}}
        return {vars = {card.ability.extra.cards}}
    end,
    can_use = function(self, card)
        return #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards and Ortalab.Mythos_Utils.can_curse_in_area(G.hand.cards, card.ability.extra.select)
    end,
    use = function(self, card, area, copier)
        -- Give random enhancement
        table.sort(G.hand.highlighted, function (a, b) return a.T.x + a.T.w/2 < b.T.x + b.T.w/2 end)
        for i=1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.5,
                func = function()
                    local enhancement = SMODS.poll_enhancement({key = 'ortalab_kraken', guaranteed = true})
                    card:juice_up(0.3, 0.5)
                    G.hand.highlighted[i]:set_ability(G.P_CENTERS[enhancement])
                    G.hand.highlighted[i]:juice_up()
                    return true
                end
            }))
        end

        -- Unhighlight cards
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.5,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))

        -- Curse random card
        Ortalab.Mythos_Utils.curse_random_hand(card, {card.ability.extra.curse})
    end
})

-- Wendigo
SMODS.Consumable({
    key = 'wendigo',
    set = 'Mythos',
    atlas = 'mythos_cards',
    cost = 5,
    pos = {x=1, y=1},
    discovered = false,
    config = {extra = {select = 1, curse = 'ortalab_wendigo', method = 'c_ortalab_one_joker', cards = 1}},
    artist_credits = {'gappie'},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {set = 'Curse', key = 'ortalab_infected_joker', specific_vars = {SMODS.get_probability_vars(card, 1, Ortalab.Curses["ortalab_infected"].config.extra.denom)}}
        info_queue[#info_queue + 1] = {set = 'Curse', key = 'ortalab_possessed_joker'}
        info_queue[#info_queue+1] = G.P_CENTERS.e_ortalab_greyscale
        info_queue[#info_queue+1] = G.P_CENTERS.e_ortalab_overexposed
    end,
    can_use = function(self, card)
        return #G.jokers.highlighted == card.ability.extra.cards and not G.jokers.highlighted[1].curse
    end,
    use = function(self, card, area, copier)
        -- Edition on joker
        local edition = poll_edition('ortalab_crawler_edition',nil,false,true,{'e_ortalab_greyscale','e_ortalab_overexposed'})
        local selected = G.jokers.highlighted[1]
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.7,
            func = function()
                card:juice_up(0.3, 0.5)
                selected:set_edition(edition, true)
                return true
            end
        }))
        SMODS.calculate_effect({message = localize{type = 'name_text', set = 'Edition', key = edition}, colour = G.C.DARK_EDITION}, selected)

        -- Curse the joker
        selected:set_curse(pseudorandom_element({"ortalab_infected", "ortalab_possessed"}, 'ortalab_crawler_curse'), false)
    end
})

-- Jackalope
SMODS.Consumable({
    key = 'jackalope',
    set = 'Mythos',
    atlas = 'mythos_cards',
    cost = 5,
    pos = {x=2, y=2},
    discovered = false,
    config = {extra = {select = 4, curse = 'ortalab_possessed', method = 'c_ortalab_mult_random_deck', mod = 1, inc = 2}},
    artist_credits = {'kosze'},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {set = 'Curse', key = card.ability.extra.curse}
        return {vars = {card.ability.extra.mod}}
    end,
    can_use = function(self, card)
        local uncursed_cards = 0
        for _, card in pairs(G.hand.cards) do
            if not card.curse then uncursed_cards = uncursed_cards + 1 end
        end
        if uncursed_cards >= math.min(G.hand.config.card_limit, card.ability.extra.select * G.GAME.ortalab.mythos.jackalope_count + G.GAME.ortalab.mythos.extra_select) then
            return true
        end
        return Ortalab.Mythos_Utils.can_curse_in_area(G.hand.cards, card.ability.extra.select, G.GAME.ortalab.mythos.jackalope_count)
    end,
    use = function(self, card, area, copier)
        -- Choose hand size or discard
        card.jimbo = true
        local positive_effect = pseudorandom_element({'hand','discard'}, 'ortalab_jackalope_choice')
        if positive_effect == 'discard' then
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.7,
                func = function()
                    G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.mod  
                    return true
                end
            }))
            SMODS.calculate_effect({message = localize('ortalab_jackalope'), colour = G.C.RED}, card) 
            ease_discard(card.ability.extra.mod)
        else
            SMODS.calculate_effect({message = localize('ortalab_hand_size_gain'), colour = G.C.BLUE}, card)
            G.hand:change_size(card.ability.extra.mod)
            draw_card(G.deck, G.hand)
        end

        -- Curse cards
        Ortalab.Mythos_Utils.curse_random_hand(card, {card.ability.extra.curse}, G.GAME.ortalab.mythos.jackalope_count)
        G.GAME.ortalab.mythos.jackalope_count = G.GAME.ortalab.mythos.jackalope_count + card.ability.extra.inc
    end
})

-- Ya Te Veo
SMODS.Consumable({
    key = 'ya_te_veo',
    set = 'Mythos',
    atlas = 'mythos_cards',
    cost = 5,
    pos = {x=0, y=2},
    discovered = false,
    config = {extra = {select = 3, scale = 2, curse = 'ortalab_random_curses', method = 'c_ortalab_ya_te_veo_curse', tags = 3}},
    artist_credits = {'gappie'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.tags}}
    end,
    can_use = function(self, card)
        return Ortalab.Mythos_Utils.can_curse_in_area(G.jokers.cards, card.ability.extra.select) and Ortalab.Mythos_Utils.can_curse_in_area(G.deck.cards, card.ability.extra.select)
    end,
    use = function(self, card, area, copier)
        -- Add 3 tags
        local pool = get_current_pool('Tag')
        local final_pool = {}
        for _, v in ipairs(pool) do
            if v ~= 'UNAVAILABLE' and v ~= 'tag_ortalab_777' and v~= 'tag_ortalab_rewind' then
                table.insert(final_pool, v)
            end
        end
        local selected = {}
        local cards = {}
        for i=1, card.ability.extra.tags do
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 1.8,
                func = function()
                    local tag, index = pseudorandom_element(final_pool, pseudoseed('ortalab_tag_patch'))
                    final_pool[index] = nil
                    table.insert(selected, tag)
                    cards[i] = SMODS.add_card({set = 'Tag', key = tag, area = G.play, skip_materialize = true})
                    cards[i]:start_materialize({G.C.SET.Mythos})
                    SMODS.calculate_effect({message = localize({type = 'name_text', set = 'Tag', key = tag}), instant = true, delay = 1.5}, cards[i])
                    return true
                end
            }))
        end
        delay(1.5)
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.7,
            func = function()
                for i=1, card.ability.extra.tags do
                    cards[i]:start_dissolve()
                    add_tag(Tag(selected[i]))               
                end
                return true
            end
        }))

        -- Curse jokers and deck
        Ortalab.Mythos_Utils.curse_random_cards(card, G.jokers.cards)
        Ortalab.Mythos_Utils.curse_random_cards(card, G.deck.cards)
    end
})

-- Anubis
SMODS.Consumable({
    key = 'anubis',
    set = 'Mythos',
    atlas = 'mythos_cards',
    cost = 5,
    pos = {x=4, y=1},
    discovered = false,
    config = {extra = {select = 1, curse = 'ortalab_possessed', method = 'c_ortalab_mult_random_joker', cards = 1}},
    artist_credits = {'gappie'},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {set = 'Curse', key = 'ortalab_infected_joker', specific_vars = {SMODS.get_probability_vars(card, 1, Ortalab.Curses["ortalab_infected"].config.extra.denom)}}
        info_queue[#info_queue + 1] = {set = 'Curse', key = 'ortalab_possessed_joker', specific_vars = {G.GAME.probabilities.normal, Ortalab.Curses[card.ability.extra.curse].config.extra.denom}}
    end,
    can_use = function(self, card)
        return #G.jokers.highlighted == card.ability.extra.cards and not G.jokers.highlighted[1].cursed and Ortalab.Mythos_Utils.can_curse_in_area(G.jokers.cards, card.ability.extra.select + 1)
    end,
    use = function(self, card, area, copier)
        -- Move joker
        G.jokers.highlighted[1]:set_curse('ortalab_infected', false)
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                card:juice_up()                
                return true
            end
        }))
        card:juice_up()
        delay(0.7)
        draw_card(G.jokers, G.consumeables, nil, nil, nil, G.jokers.highlighted[1]) 
        delay(0.4)
        Ortalab.Mythos_Utils.curse_random_cards(card, G.jokers.cards, {card.ability.extra.curse})
    end
})

SMODS.Consumable({
    key = 'corpus',
    set = 'Mythos',
    atlas = 'mythos_cards',
    cost = 5,
    pos = {x=1, y=3},
    soul_pos = {x=2, y=3},
    discovered = false,
    config = {extra = {select = 2, curse = 'ortalab_corroded', method = 'c_ortalab_mult_random_deck', cards = 4}},
    artist_credits = {'gappie'},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {set = 'Curse', key = card.ability.extra.curse, specific_vars = {Ortalab.Curses[card.ability.extra.curse].config.extra.base, Ortalab.Curses[card.ability.extra.curse].config.extra.gain}}
        return {vars = {card.ability.extra.cards}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        sendDebugMessage("Not yet implemented")
    end,
    in_pool = function(self, args)
        if pseudorandom('ortalab_corpus_spawn') < 0.3 then
            return true
        end
        return false
    end,
})

-- Ophiuchus
SMODS.Consumable({
    key = 'ophiuchus',
    set = 'Mythos',
    atlas = 'mythos_cards',
    cost = 5,
    pos = {x=3, y=3},
    discovered = false,
    hidden = true,
    soul_set = 'Zodiac',
    soul_rate = 0.03,
    config = {extra = {cards = 4, zodiac = 'zodiac_ortalab_ophiuchus'}},
    artist_credits = {'gappie'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.cards}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        use_zodiac(card)
    end,
    in_pool = function(self, args)
        if pseudorandom('ortalab_ophiuchus_spawn') < 0.3 then
            return true
        end
        return false
    end,
})

-- Ophiuchus Zodiac
Ortalab.Zodiac{
    key = 'ophiuchus',
    pos = {x=0, y=2},
    colour = HEX('57405f'),
    config = {extra = {temp_level = 4, hand_type = 'Any'}},
    loc_vars = function(self, info_queue, card)
        local zodiac = card or self
        local temp_level = (not zodiac.voucher_check and G.GAME.ortalab.zodiacs.temp_level_mod or 1) * zodiac.config.extra.temp_level
        return {vars = {temp_level, localize(zodiac.config.extra.hand_type, 'poker_hands'), zodiac.config.extra.amount}}
    end,
    pre_trigger = function(self, zodiac, context)
        for i=1, #context.scoring_hand do
            if context.scoring_hand[i].curse then
                SMODS.calculate_effect({message = 'Cleansed!', colour = G.C.FILTER}, context.scoring_hand[i]) 
                context.scoring_hand[i]:set_curse(nil, nil, nil, nil, nil, true)
            end
        end
        zodiac_reduce_level(zodiac)
        return context.mult, context.chips
    end
}
