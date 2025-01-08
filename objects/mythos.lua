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

G.ARGS.LOC_COLOURS['Mythos'] = HEX("57405f")

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
    collection_rows = {3, 3},
    shop_rate = 0.3,
    default = 'c_ortalab_zod_aries'
})

SMODS.Consumable({
    key = 'excalibur',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=0, y=0},
    discovered = false,
    config = {extra = {select = 1, curse = 'ortalab_infected', method = 'c_ortalab_one_selected',}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        info_queue[#info_queue + 1] = {set = 'Curse', key = card.ability.extra.curse}
        local _handname, _played, _order = 'High Card', -1, 100
        for k, v in pairs(G.GAME.hands) do
            if v.played > _played or (v.played == _played and _order > v.order) then 
                _played = v.played
                _handname = k
            end
        end
        return {vars = {localize(_handname, 'poker_hands')}}
    end,
    can_use = function(self, card)
        if #G.hand.highlighted == card.ability.extra.select and not G.hand.highlighted[1].curse then return true end
    end,
    use = function(self, card, area, copier)
        -- set the curse
        G.hand.highlighted[1]:set_curse(card.ability.extra.curse)
        G.hand.highlighted[1]:juice_up()
        
        -- find most played hand
        local _handname, _played, _order = 'High Card', -1, 100
        for k, v in pairs(G.GAME.hands) do
            if v.played > _played or (v.played == _played and _order > v.order) then 
                _played = v.played
                _handname = k
            end
        end
        -- find zodiac key
        local key = G.P_CENTERS[zodiac_from_hand(_handname or 'High Card')].config.extra.zodiac
        
        -- add zodiac
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 1,
            func = function()
                if G.zodiacs and G.zodiacs[key] then
                    G.zodiacs[key].config.extra.temp_level = G.zodiacs[key].config.extra.temp_level + G.ZODIACS[key].config.extra.temp_level
                    zodiac_text(zodiac_upgrade_text(key), key)
                    G.zodiacs[key]:juice_up(1, 1)
                    delay(0.7)
                else
                    add_zodiac(Zodiac(key))
                end
                return true
            end
        }))

        -- unhighlight card
        G.E_MANAGER:add_event(Event({
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end
})

SMODS.Consumable({
    key = 'tree_of_life',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=1, y=0},
    discovered = false,
    config = {extra = {select = 4, inc = 1, curse = 'ortalab_all_curses', method = 'c_ortalab_mult_random', slots = 1, perish_count = 2}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.slots, card.ability.extra.perish_count}}
    end,
    can_use = function(self, card)
        local uncursed_cards = 0
        for _, card in pairs(G.hand.cards) do
            if not card.curse then uncursed_cards = uncursed_cards + 1 end
        end
        if uncursed_cards >= card.ability.extra.select + G.GAME.ortalab.tree_of_life_count  then
            return true
        end
    end,
    use = function(self, card, area, copier)
        -- curse cards
        G.hand:unhighlight_all()
        local curses = {'corroded', 'infected', 'possessed', 'restrained'}
        local applied = {}

        for i=1, card.ability.extra.select + G.GAME.ortalab.tree_of_life_count  do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    local select = true
                    while select do
                        local p_card = pseudorandom_element(G.hand.cards, pseudoseed('ortalab_tree_of_life'))
                        if not p_card.highlighted and not p_card.curse then 
                            G.hand:add_to_highlighted(p_card)
                            while select do
                                local curse_to_apply = pseudorandom_element(curses, pseudoseed('tree_curse_choice'))
                                if not applied[curse_to_apply] or i > card.ability.extra.select then
                                    applied[curse_to_apply] = true
                                    p_card:set_curse('ortalab_'..curse_to_apply, false, true)
                                    p_card:juice_up()
                                    select = false
                                end
                            end
                        end
                    end
                    return true
                end
            }))
        end

        -- Add Perishable to 2 jokers
        local available_jokers = {}    
        for _, joker in pairs(G.jokers.cards) do
            if not joker.ability.perishable and joker.config.center.perishable_compat then
                available_jokers[#available_jokers + 1] = joker
            end
        end
        for i=1, math.min(#available_jokers, card.ability.extra.perish_count) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.7,
                func = function()
                    local joker, pos = pseudorandom_element(available_jokers, pseudoseed('tree_perish'))
                    SMODS.Stickers.perishable:apply(joker, true)
                    joker:juice_up()
                    table.remove(available_jokers, pos)
                    return true
                end
            }))
        end
        
        -- Add Joker slots
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.5,
            func = function()
                G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
                modify_joker_slot_count(card.ability.extra.slots)
                return true
            end
        }))
        
        -- unhighlight card
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.5,
            func = function()
                G.hand:unhighlight_all()
                G.GAME.ortalab.tree_of_life_count = G.GAME.ortalab.tree_of_life_count + card.ability.extra.inc
                return true
            end
        }))
    end
})



SMODS.Consumable({
    key = 'genie',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=2, y=0},
    discovered = false,
    config = {extra = {select = 2, curse = 'ortalab_restrained', method = 'c_ortalab_mult_random_deck', cards = 3}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        info_queue[#info_queue + 1] = {set = 'Curse', key = card.ability.extra.curse, specific_vars = Ortalab.Curses[card.ability.extra.curse]:loc_vars().vars}
        return {vars = {card.ability.extra.cards}}
    end,
    can_use = function(self, card)
        if #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards then
            local uncursed = 0
            local i = 1
            while (uncursed <= card.ability.extra.select and i <= #G.deck.cards) do
                if not G.deck.cards[i].curse then uncursed = uncursed + 1 end
                i = i + 1
            end
            if uncursed >= card.ability.extra.select then return true end
        end
    end,
    use = function(self, card, area, copier)
        -- Curse random cards in deck
        for i=1, card.ability.extra.select do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    local select = true
                    while select do
                        local p_card = pseudorandom_element(G.deck.cards, pseudoseed('ortalab_genie'))
                        if not p_card.curse then 
                            p_card:set_curse(card.ability.extra.curse, true)
                            G.deck.cards[1]:juice_up()
                            select = false
                        end
                    end
                    return true
                end
            }))
        end

        -- Give random editions
        for i=1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    local new_edition = poll_edition('mythos_genie', nil, false, true)
                    G.hand.highlighted[i]:set_edition(new_edition, true)
                    G.hand.highlighted[i]:juice_up()
                    return true
                end
            }))
        end

        -- Unhighlight cards
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.5,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end
})

SMODS.Consumable({
    key = 'pandora',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=3, y=0},
    discovered = false,
    config = {extra = {select = 4, curse = 'ortalab_all_curses', method = 'c_ortalab_mult_random', choose = 1, copies = 6}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        card.ability.extra.select = math.ceil(#G.hand.cards / 2)
        return {vars = {card.ability.extra.copies}}
    end,
    set_ability = function(self, card)
        -- set card.ability.extra.select to half of hand size
    end,
    can_use = function(self, card)
        if #G.hand.highlighted == card.ability.extra.choose then
            local uncursed_cards = 0
            local cursed_cards = 0
            for _, card in pairs(G.hand.cards) do
                if not card.curse then uncursed_cards = uncursed_cards + 1 else cursed_cards = cursed_cards + 1 end
            end
            if uncursed_cards >= cursed_cards  then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
        -- curse cards
        local used_card = G.hand.highlighted[1]
        draw_card(G.hand, G.play, nil, nil, nil, used_card)
        G.hand:unhighlight_all()
        local curses = {'corroded', 'infected', 'possessed', 'restrained'}
        local applied = {}

        for i=1, math.ceil(#G.hand.cards / 2) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    local select = true
                    while select do
                        local p_card = pseudorandom_element(G.hand.cards, pseudoseed('ortalab_pandora'))
                        if not p_card.highlighted and not p_card.curse then 
                            G.hand:add_to_highlighted(p_card)
                            while select do
                                local curse_to_apply = pseudorandom_element(curses, pseudoseed('tree_curse_choice'))
                                if not applied[curse_to_apply] or i > card.ability.extra.select then
                                    applied[curse_to_apply] = true
                                    p_card:set_curse('ortalab_'..curse_to_apply, false, true)
                                    p_card:juice_up()
                                    select = false
                                end
                            end
                        end
                    end
                    return true
                end
            }))
        end

        -- Add new copies to deck
        for i=1, card.ability.extra.copies do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    local new_card = copy_card(used_card)
                    new_card:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(G.playing_cards, new_card)
                    G.deck:emplace(new_card)
                    G.deck:shuffle('pandora')
                    used_card:juice_up()
                    
                    return true
                end
            }))
        end
        draw_card(G.play, G.hand, nil, nil, nil, used_card)

    end
})

SMODS.Consumable({
    key = 'holy_grail',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=4, y=0},
    discovered = false,
    config = {extra = {select = 2, curse = 'ortalab_infected', method = 'c_ortalab_mult_random_deck', cards = 1}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
    end,
    can_use = function(self, card)
        if #G.hand.highlighted == card.ability.extra.cards then
            local uncursed = 0
            local i = 1
            while (uncursed <= card.ability.extra.select and i <= #G.deck.cards) do
                if not G.deck.cards[i].curse then uncursed = uncursed + 1 end
                i = i + 1
            end
            if uncursed >= card.ability.extra.select then return true end
        end
    end,
    use = function(self, card, area, copier)
        -- Curse random cards in deck
        for i=1, card.ability.extra.select do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    local select = true
                    while select do
                        local p_card = pseudorandom_element(G.deck.cards, pseudoseed('ortalab_holy_grail'))
                        if not p_card.curse then 
                            p_card:set_curse(card.ability.extra.curse, true)
                            G.deck.cards[1]:juice_up()
                            select = false
                        end
                    end
                    return true
                end
            }))
        end

        -- Add overexposed
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.5,
            func = function()
                G.hand.highlighted[1]:set_edition('e_ortalab_overexposed', true)
                return true
            end
        }))
    end
})

SMODS.Consumable({
    key = 'talaria',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=0, y=3},
    discovered = false,
    config = {extra = {select = 3, curse = 'ortalab_restrained', method = 'c_ortalab_mult_random'}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
    end,
    can_use = function(self, card)
        local uncursed_cards = 0
        for _, card in pairs(G.hand.cards) do
            if not card.curse then uncursed_cards = uncursed_cards + 1 end
        end
        if uncursed_cards >= card.ability.extra.select + G.GAME.ortalab.tree_of_life_count  then
            return true
        end
    end,
    use = function(self, card, area, copier)
        -- curse cards
        G.hand:unhighlight_all()

        for i=1, card.ability.extra.select  do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    local select = true
                    while select do
                        local p_card = pseudorandom_element(G.hand.cards, pseudoseed('ortalab_talaria_curse'))
                        if not p_card.highlighted and not p_card.curse then 
                            G.hand:add_to_highlighted(p_card)
                            p_card:set_curse(card.ability.extra.curse, false, true)
                            p_card:juice_up()
                            select = false
                        end
                    end
                    return true
                end
            }))
        end

        -- unhighlight card
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.5,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))

        local _pool = get_current_pool('Voucher')
        local voucher = pseudorandom_element(_pool, pseudoseed('ortalab_talaria_voucher'))
        local it = 1
        while voucher == 'UNAVAILABLE' do
            it = it + 1
            voucher = pseudorandom_element(_pool, pseudoseed('ortalab_talaria_resample'..it))
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.5,
            func = function()
                local voucher_card = SMODS.create_card({area = G.play, key = voucher})
                voucher_card:start_materialize()
                voucher_card.cost = 0
                G.play:emplace(voucher_card)
                delay(0.8)
                voucher_card:redeem()
                
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.5,
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

SMODS.Consumable({
    key = 'basilisk',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=0, y=1},
    discovered = false,
    config = {extra = {select = 1, curse = 'ortalab_infected', method = 'c_ortalab_one_selected', cards = 3}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'eremel'} end
        return {vars = {card.ability.extra.cards}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        sendDebugMessage("Not yet implemented")
    end
})

SMODS.Consumable({
    key = 'abaia',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=4, y=2},
    discovered = false,
    config = {extra = {select = 1, curse = 'ortalab_restrained', method = 'c_ortalab_one_selected', cards = 3, rank = 7}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        return {vars = {card.ability.extra.cards, card.ability.extra.rank}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        sendDebugMessage("Not yet implemented")
    end
})

SMODS.Consumable({
    key = 'jormungand',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=1, y=2},
    discovered = false,
    config = {extra = {select = 1, curse = 'ortalab_corroded', method = 'c_ortalab_one_selected', cards = 3}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        return {vars = {card.ability.extra.cards}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        sendDebugMessage("Not yet implemented")
    end
})

SMODS.Consumable({
    key = 'gnome',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=3, y=2},
    discovered = false,
    config = {extra = {select = 1, money_gain = 2, curse = 'ortalab_corroded', method = 'c_ortalab_one_selected'}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.money_gain, 20}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        sendDebugMessage("Not yet implemented")
    end
})

SMODS.Consumable({
    key = 'crawler',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=3, y=1},
    discovered = false,
    config = {extra = {select = 1, curse = 'ortalab_possessed', method = 'c_ortalab_one_selected'}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        sendDebugMessage("Not yet implemented")
    end
})

SMODS.Consumable({
    key = 'kraken',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=3, y=2},
    discovered = false,
    config = {extra = {select = 2, curse = 'ortalab_corroded', method = 'c_ortalab_mult_random_deck', cards = 4}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.cards}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        sendDebugMessage("Not yet implemented")
    end
})

SMODS.Consumable({
    key = 'wendigo',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=1, y=1},
    discovered = false,
    config = {extra = {select = 2, curse = 'ortalab_possessed', method = 'c_ortalab_mult_random_deck'}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        sendDebugMessage("Not yet implemented")
    end
})

SMODS.Consumable({
    key = 'jackalope',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=2, y=2},
    discovered = false,
    config = {extra = {select = 2, curse = 'ortalab_corroded', method = 'c_ortalab_mult_random', hands = 1}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.hands}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        sendDebugMessage("Not yet implemented")
    end
})

SMODS.Consumable({
    key = 'ya_te_veo',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=0, y=2},
    discovered = false,
    config = {extra = {select = 2, curse = 'ortalab_possessed', method = 'c_ortalab_mult_random', handsize = 1}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.handsize}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        sendDebugMessage("Not yet implemented")
    end
})

SMODS.Consumable({
    key = 'anubis',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=4, y=1},
    discovered = false,
    config = {extra = {select = 2, curse = 'ortalab_infected', method = 'c_ortalab_mult_random'}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        sendDebugMessage("Not yet implemented")
    end
})

SMODS.Consumable({
    key = 'corpus',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=1, y=3},
    soul_pos = {x=2, y=3},
    discovered = false,
    config = {extra = {select = 2, curse = 'ortalab_corroded', method = 'c_ortalab_mult_random_deck', cards = 4}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.cards}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        sendDebugMessage("Not yet implemented")
    end
})

SMODS.Consumable({
    key = 'ophiuchus',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=3, y=3},
    discovered = false,
    config = {extra = {select = 2, curse = 'ortalab_corroded', method = 'c_ortalab_mult_random_deck', cards = 4}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.cards}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        sendDebugMessage("Not yet implemented")
    end
})

local gcui = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    local ui = gcui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    if _c.set == 'Mythos' and _c.discovered then 
        local colour = Ortalab.Curses[card.ability.extra.curse] and Ortalab.Curses[card.ability.extra.curse].badge_colour or G.ARGS.LOC_COLOURS.Mythos
        local mythos_nodes = {background_colour = lighten(colour, 0.75)}
        -- ui.main.background_colour = lighten(G.C.GREEN, 0.75)
        local vars = {
            card.ability.extra.select,
            localize({type = 'name_text', set = 'Curse', key = card.ability.extra.curse}),
            colours = {colour}
        }
        if _c.key == 'c_ortalab_tree_of_life' then
            vars[1] = vars[1] + G.GAME.ortalab.tree_of_life_count
        end
        localize{type = 'descriptions', set = _c.set, key = card.ability.extra.method, nodes = mythos_nodes, vars = vars}
        ui.mythos = mythos_nodes
    end
    return ui
end