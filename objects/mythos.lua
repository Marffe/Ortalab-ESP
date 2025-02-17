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
    shop_rate = 0.6,
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
        if #G.hand.highlighted == card.ability.extra.select + G.GAME.ortalab.mythos.extra_select then
            for _, selected in pairs(G.hand.highlighted) do
                if selected.curse then return false end
            end
            return true
        end
    end,
    use = function(self, card, area, copier)
        -- set the curse
        for _, curse_card in pairs(G.hand.highlighted) do
            curse_card:set_curse(card.ability.extra.curse)
        end
        
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
    config = {extra = {select = 4, inc = 2, curse = 'ortalab_all_curses', method = 'c_ortalab_mult_random', slots = 1, perish_count = 3}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.slots, card.ability.extra.perish_count + G.GAME.ortalab.mythos.tree_of_life_count}}
    end,
    can_use = function(self, card)
        local uncursed_cards = 0
        for _, hand_card in pairs(G.hand.cards) do
            if not hand_card.curse then uncursed_cards = uncursed_cards + 1 end
        end
        local unperish = 0
        for _, joker in pairs(G.jokers.cards) do
            if not joker.ability.perishable and joker.config.center.perishable_compat then unperish = unperish + 1 end
        end
        if uncursed_cards >= math.min(G.hand.config.card_limit, card.ability.extra.select + G.GAME.ortalab.mythos.extra_select) and unperish >= card.ability.extra.perish_count + G.GAME.ortalab.mythos.tree_of_life_count then
            return true
        end
    end,
    use = function(self, card, area, copier)
        -- curse 
        G.hand:unhighlight_all()
        local curses = {'corroded', 'infected', 'possessed', 'restrained'}
        local applied = {}

        for i=1, math.min(G.hand.config.card_limit, card.ability.extra.select + G.GAME.ortalab.mythos.extra_select) do
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
        for i=1,card.ability.extra.perish_count + G.GAME.ortalab.mythos.tree_of_life_count do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.7,
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
        
        -- Add Joker slots
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.5,
            func = function()
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
                G.GAME.ortalab.mythos.tree_of_life_count = G.GAME.ortalab.mythos.tree_of_life_count + card.ability.extra.inc
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
    config = {extra = {select = 2, curse = 'ortalab_possessed', method = 'c_ortalab_mult_random_deck', cards = 3}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.cards}}
    end,
    can_use = function(self, card)
        if #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards then
            local uncursed = 0
            local i = 1
            while (uncursed <= card.ability.extra.select + G.GAME.ortalab.mythos.extra_select and i <= #G.deck.cards) do
                if not G.deck.cards[i].curse then uncursed = uncursed + 1 end
                i = i + 1
            end
            if uncursed >= card.ability.extra.select + G.GAME.ortalab.mythos.extra_select then return true end
        end
    end,
    use = function(self, card, area, copier)
        -- Curse random cards in deck
        for i=1, card.ability.extra.select + G.GAME.ortalab.mythos.extra_select do
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
                    card:juice_up(0.3, 0.5)
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
    config = {extra = {select = 6, curse = 'ortalab_all_curses', method = 'c_ortalab_mult_random', choose = 1, copies = 4}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.copies}}
    end,
    can_use = function(self, card)
        if #G.hand.highlighted == card.ability.extra.choose then
            local uncursed_cards = 0
            local cursed_cards = 0
            for _, card in pairs(G.hand.cards) do
                if not card.curse then uncursed_cards = uncursed_cards + 1 else cursed_cards = cursed_cards + 1 end
            end
            if uncursed_cards >= card.ability.extra.select + G.GAME.ortalab.mythos.extra_select then
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

        for i=1, card.ability.extra.select + G.GAME.ortalab.mythos.extra_select do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    local select = true
                    while select do
                        local p_card = pseudorandom_element(G.hand.cards, pseudoseed('ortalab_pandora'))
                        if not p_card.highlighted and not p_card.curse then 
                            while select do
                                local curse_to_apply = pseudorandom_element(curses, pseudoseed('tree_curse_choice'))
                                if not applied[curse_to_apply] or i > 4 then
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
                    play_sound('tarot1')
                    card:juice_up(0.3, 0.5)
                    
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
            while (uncursed <= card.ability.extra.select + G.GAME.ortalab.mythos.extra_select and i <= #G.deck.cards) do
                if not G.deck.cards[i].curse then uncursed = uncursed + 1 end
                i = i + 1
            end
            if uncursed >= card.ability.extra.select + G.GAME.ortalab.mythos.extra_select then return true end
        end
    end,
    use = function(self, card, area, copier)
        -- Curse random cards in deck
        for i=1, card.ability.extra.select + G.GAME.ortalab.mythos.extra_select do
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
                            card:juice_up(0.3, 0.5)
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
                card:juice_up(0.3, 0.5)
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
        if uncursed_cards >= card.ability.extra.select + G.GAME.ortalab.mythos.talaria_count + G.GAME.ortalab.mythos.extra_select then
            return true
        end
    end,
    use = function(self, card, area, copier)
        -- curse cards
        G.hand:unhighlight_all()

        for i=1, card.ability.extra.select + G.GAME.ortalab.mythos.talaria_count + G.GAME.ortalab.mythos.extra_select do
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
                            card:juice_up(0.3, 0.5)
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
        G.GAME.ortalab.mythos.talaria_count = G.GAME.ortalab.mythos.talaria_count + 1
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
        if #G.hand.highlighted == card.ability.extra.select + G.GAME.ortalab.mythos.extra_select then
            for _, selected in pairs(G.hand.highlighted) do
                if selected.curse then return false end
            end
            return true
        end
    end,
    use = function(self, card, area, copier)
        -- set the curse
        for _, curse_card in pairs(G.hand.highlighted) do
            curse_card:set_curse(card.ability.extra.curse)
        end
        -- unhighlight card
        G.E_MANAGER:add_event(Event({
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        -- add 3 enhanced/editioned Face cards
        local cards = {}
        for i=1, card.ability.extra.cards do
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()
                    local _suit = pseudorandom_element(SMODS.Suits, pseudoseed('ortalab_basilisk_suit')).card_key
                    local faces = {}
                        for _, v in ipairs(SMODS.Rank.obj_buffer) do
                            local r = SMODS.Ranks[v]
                            if r.face then table.insert(faces, r) end
                        end
                    local _rank = pseudorandom_element(faces, pseudoseed('ortalab_basilisk_rank')).card_key
                    
                    local enhancement = SMODS.poll_enhancement({guaranteed = true, key = 'ortalab_basilisk', no_replace = true})
                    local new_card = create_playing_card({front = G.P_CARDS[_suit..'_'.._rank], center = G.P_CENTERS[enhancement]}, G.hand, nil, i ~= 1, {G.C.SET.Mythos, darken(G.C.SET.Mythos, 0.5), G.C.RED, darken(G.C.SET.Mythos, 0.2), G.ARGS.LOC_COLOURS['mythos_alt']})
                    new_card:set_edition(poll_edition('ortalab_basilisk_edition', nil, false, true), true)
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
        if #G.hand.highlighted == card.ability.extra.select + G.GAME.ortalab.mythos.extra_select then
            for _, selected in pairs(G.hand.highlighted) do
                if selected.curse then return false end
            end
            return true
        end
    end,
    use = function(self, card, area, copier)
        -- set the curse
        for _, curse_card in pairs(G.hand.highlighted) do
            curse_card:set_curse(card.ability.extra.curse)
        end
        -- unhighlight card
        G.E_MANAGER:add_event(Event({
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        -- add 3 enhanced/editioned Face cards
        local cards = {}
        for i=1, card.ability.extra.cards do
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()
                    local _suit = pseudorandom_element(SMODS.Suits, pseudoseed('ortalab_abaia_suit')).card_key
                
                    local enhancement = SMODS.poll_enhancement({guaranteed = true, key = 'ortalab_abaia', no_replace = true})
                    local new_card = create_playing_card({front = G.P_CARDS[_suit..'_'.._rank], center = G.P_CENTERS[enhancement]}, G.hand, nil, i ~= 1, {G.C.SET.Mythos, darken(G.C.SET.Mythos, 0.5), G.C.RED, darken(G.C.SET.Mythos, 0.2), G.ARGS.LOC_COLOURS['mythos_alt']})
                    new_card:set_edition(poll_edition('ortalab_abaia_edition', nil, false, true), true)
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
            
    end
})

SMODS.Consumable({
    key = 'jormungand',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=1, y=2},
    discovered = false,
    config = {extra = {select = 1, curse = 'ortalab_corroded', method = 'c_ortalab_one_selected', cards = 3, rank = 'A'}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        return {vars = {card.ability.extra.cards}}
    end,
    can_use = function(self, card)
        if #G.hand.highlighted == card.ability.extra.select + G.GAME.ortalab.mythos.extra_select then
            for _, selected in pairs(G.hand.highlighted) do
                if selected.curse then return false end
            end
            return true
        end
    end,
    use = function(self, card, area, copier)
        -- set the curse
        for _, curse_card in pairs(G.hand.highlighted) do
            curse_card:set_curse(card.ability.extra.curse)
        end
        -- unhighlight card
        G.E_MANAGER:add_event(Event({
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        -- add 3 enhanced/editioned Face cards
        local cards = {}
        for i=1, card.ability.extra.cards do
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()
                    local _suit = pseudorandom_element(SMODS.Suits, pseudoseed('ortalab_jormungand_suit')).card_key
                
                    local enhancement = SMODS.poll_enhancement({guaranteed = true, key = 'ortalab_jormungand', no_replace = true})
                    local new_card = create_playing_card({front = G.P_CARDS[_suit..'_'.._rank], center = G.P_CENTERS[enhancement]}, G.hand, nil, i ~= 1, {G.C.SET.Mythos, darken(G.C.SET.Mythos, 0.5), G.C.RED, darken(G.C.SET.Mythos, 0.2), G.ARGS.LOC_COLOURS['mythos_alt']})
                    new_card:set_edition(poll_edition('ortalab_jormungand_edition', nil, false, true), true)
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
    end
})

SMODS.Consumable({
    key = 'gnome',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=3, y=2},
    discovered = false,
    config = {extra = {select = 1, money_gain = 2, curse = 'ortalab_corroded', method = 'c_ortalab_mult_random_joker'}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        local total_value = 0
        if G.jokers then
            for k=1, #G.jokers.cards + #G.consumeables.cards do
                local _card = G.jokers.cards[k] or G.consumeables.cards[k - #G.jokers.cards]
                if _card.config.center.set == 'Joker' then
                    total_value = total_value + _card.sell_cost
                end
            end
        end
        return {vars = {card.ability.extra.money_gain, total_value}}
    end,
    can_use = function(self, card)
        local uncursed = 0
        local i = 1
        while (uncursed <= card.ability.extra.select and i <= #G.jokers.cards) do
            if not G.jokers.cards[i].curse then uncursed = uncursed + 1 end
            i = i + 1
        end
        if uncursed >= card.ability.extra.select then return true end
    end,
    use = function(self, card, area, copier)
        -- Curse random joker
        local select = true
        while select do
            local p_card = pseudorandom_element(G.jokers.cards, pseudoseed('ortalab_gnome'))
            if not p_card.curse then 
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.7,
                    func = function()                
                        p_card:set_curse(card.ability.extra.curse, false, true)
                        p_card:juice_up()
                        play_sound('tarot1')
                        card:juice_up(0.3, 0.5)
                        return true
                    end
                }))
                select = false
            end
        end

        -- unhighlight card
        G.E_MANAGER:add_event(Event({
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))

        local total_value = 0
        for k=1, #G.jokers.cards + #G.consumeables.cards do
            local _card = G.jokers.cards[k] or G.consumeables.cards[k - #G.jokers.cards]
            if _card.config.center.set == 'Joker' then
                total_value = total_value + _card.sell_cost
                _card.ability.extra_value = _card.ability.extra_value + card.ability.extra.money_gain
                _card:set_cost()
            end
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()
                ease_dollars(total_value, true)                
                return true
            end
        }))
        for k=1, #G.jokers.cards + #G.consumeables.cards do
            local _card = G.jokers.cards[k] or G.consumeables.cards[k - #G.jokers.cards]
            if _card.config.center.set == 'Joker' then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.5,
                    func = function()                
                        play_sound('coin1')
                        card:juice_up(0.3, 0.5)
                        SMODS.calculate_effect({message = '+$'..card.ability.extra.money_gain, colour = G.C.GOLD, instant = true}, _card)
                        _card:juice_up()
                        return true
                    end
                }))
            end
        end
    end
})

SMODS.Consumable({
    key = 'crawler',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=3, y=1},
    discovered = false,
    config = {extra = {select = 1, curse = 'ortalab_possessed', method = 'c_ortalab_mult_random_joker'}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
    end,
    can_use = function(self, card)
        local uncursed = 0
        local i = 1
        while (uncursed <= card.ability.extra.select and i <= #G.jokers.cards) do
            if not G.jokers.cards[i].curse then uncursed = uncursed + 1 end
            i = i + 1
        end
        if uncursed >= card.ability.extra.select then return true end
    end,
    use = function(self, card, area, copier)
        -- Curse random joker
        local select = true
        while select do
            local p_card = pseudorandom_element(G.jokers.cards, pseudoseed('ortalab_crawler'))
            if not p_card.curse then 
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.7,
                    func = function()                
                        p_card:set_curse(card.ability.extra.curse, false, true)
                        p_card:juice_up()
                        play_sound('tarot1')
                        card:juice_up(0.3, 0.5)
                        return true
                    end
                }))
                select = false
            end
        end
        -- unhighlight card
        G.E_MANAGER:add_event(Event({
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        
        -- Edition on joker
        local valid_jokers = {}
        for k=1, #G.jokers.cards + #G.consumeables.cards do
            local _card = G.jokers.cards[k] or G.consumeables.cards[k - #G.jokers.cards]
            if _card.config.center.set == 'Joker' and not _card.edition then
                valid_jokers[#valid_jokers + 1] = _card
            end
        end
        local edition = poll_edition('ortalab_crawler_edition',nil,false,true)
        local selected = pseudorandom_element(valid_jokers, pseudoseed('ortalab_crawler'))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()
                card:juice_up(0.3, 0.5)
                selected:set_edition(edition, true)
                return true
            end
        }))
        SMODS.calculate_effect({message = localize{type = 'name_text', set = 'Edition', key = edition}, colour = G.C.DARK_EDITION}, selected)
    end
})

SMODS.Consumable({
    key = 'kraken',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=2, y=1},
    discovered = false,
    config = {extra = {select = 2, curse = 'ortalab_corroded', method = 'c_ortalab_mult_random_deck', cards = 4}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.cards}}
    end,
    can_use = function(self, card)
        if #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards then
            local uncursed = 0
            local i = 1
            while (uncursed <= card.ability.extra.select + G.GAME.ortalab.mythos.extra_select and i <= #G.deck.cards) do
                if not G.deck.cards[i].curse then uncursed = uncursed + 1 end
                i = i + 1
            end
            if uncursed >= card.ability.extra.select + G.GAME.ortalab.mythos.extra_select then return true end
        end
    end,
    use = function(self, card, area, copier)
        -- Curse random cards in deck
        for i=1, card.ability.extra.select + G.GAME.ortalab.mythos.extra_select do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    local select = true
                    while select do
                        local p_card = pseudorandom_element(G.deck.cards, pseudoseed('ortalab_kraken'))
                        if not p_card.curse then 
                            p_card:set_curse(card.ability.extra.curse, true)
                            G.deck.cards[1]:juice_up()
                            card:juice_up(0.3, 0.5)
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
    key = 'wendigo',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=1, y=1},
    discovered = false,
    config = {extra = {select = 1, curse = 'ortalab_restrained', method = 'c_ortalab_mult_random_joker', cards = 1}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
    end,
    can_use = function(self, card)
        if #G.jokers.highlighted > 0 and #G.jokers.highlighted <= card.ability.extra.cards then
            local uncursed = 0
            local i = 1
            while (uncursed <= card.ability.extra.select and i <= #G.jokers.cards) do
                if not G.jokers.cards[i].curse then uncursed = uncursed + 1 end
                i = i + 1
            end
            if uncursed >= card.ability.extra.select then return true end
        end
    end,
    use = function(self, card, area, copier)
        -- Curse random joker
        local select = true
        while select do
            local p_card = pseudorandom_element(G.jokers.cards, pseudoseed('ortalab_wendigo'))
            if not p_card.curse then 
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.7,
                    func = function()                
                        p_card:set_curse(card.ability.extra.curse, false, true)
                        p_card:juice_up()
                        play_sound('tarot1')
                        card:juice_up(0.3, 0.5)
                        return true
                    end
                }))
                select = false
            end
        end

        -- Edition on joker
        local edition = poll_edition('ortalab_crawler_edition',nil,false,true,{'e_ortalab_greyscale','e_ortalab_overexposed'})
        local selected = G.jokers.highlighted[1]
         --  local selected = pseudorandom_element(valid_jokers, pseudoseed('ortalab_crawler'))
         G.E_MANAGER:add_event(Event({
             trigger = 'after',
             delay = 0.7,
             func = function()
                 card:juice_up(0.3, 0.5)
                 selected:set_edition(edition, true)
                 return true
             end
         }))
         SMODS.calculate_effect({message = localize{type = 'name_text', set = 'Edition', key = edition}, colour = G.C.DARK_EDITION}, selected)
    end
})

SMODS.Consumable({
    key = 'jackalope',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=2, y=2},
    discovered = false,
    config = {extra = {select = 4, curse = 'ortalab_corroded', method = 'c_ortalab_mult_random', hands = 1}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        return {vars = {card.ability.extra.hands}}
    end,
    can_use = function(self, card)
        local uncursed_cards = 0
        for _, card in pairs(G.hand.cards) do
            if not card.curse then uncursed_cards = uncursed_cards + 1 end
        end
        if uncursed_cards >= math.min(G.hand.config.card_limit, card.ability.extra.select * G.GAME.ortalab.mythos.jackalope_count + G.GAME.ortalab.mythos.extra_select) then
            return true
        end
    end,
    use = function(self, card, area, copier)
        -- curse cards
        G.hand:unhighlight_all()

        for i=1, math.min(G.hand.config.card_limit, card.ability.extra.select * G.GAME.ortalab.mythos.jackalope_count + G.GAME.ortalab.mythos.extra_select) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    local select = true
                    while select do
                        local p_card = pseudorandom_element(G.hand.cards, pseudoseed('ortalab_jackalope_curse'))
                        if not p_card.highlighted and not p_card.curse then 
                            G.hand:add_to_highlighted(p_card)
                            p_card:set_curse(card.ability.extra.curse, false, true)
                            p_card:juice_up()
                            card:juice_up(0.3, 0.5)
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

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()
                ease_discard(card.ability.extra.hands)
                G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.hands  
                G.GAME.ortalab.mythos.jackalope_count = G.GAME.ortalab.mythos.jackalope_count + 1             
                SMODS.calculate_effect({message = localize('ortalab_cardist'), colour = G.C.BLUE}, card) 
                return true
            end
        }))
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
        local uncursed_cards = 0
        for _, card in pairs(G.hand.cards) do
            if not card.curse then uncursed_cards = uncursed_cards + 1 end
        end
        if uncursed_cards >= math.min(G.hand.config.card_limit, card.ability.extra.select + G.GAME.ortalab.mythos.extra_select + G.GAME.ortalab.mythos.ya_te_veo_count)  then
            return true
        end
    end,
    use = function(self, card, area, copier)
        -- curse cards
        G.hand:unhighlight_all()

        for i=1, math.min(G.hand.config.card_limit, card.ability.extra.select + G.GAME.ortalab.mythos.extra_select + G.GAME.ortalab.mythos.ya_te_veo_count) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    local select = true
                    while select do
                        local p_card = pseudorandom_element(G.hand.cards, pseudoseed('ortalab_jackalope_curse'))
                        if not p_card.highlighted and not p_card.curse then 
                            G.hand:add_to_highlighted(p_card)
                            p_card:set_curse(card.ability.extra.curse, false, true)
                            p_card:juice_up()
                            card:juice_up(0.3, 0.5)
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

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()
                G.hand.config.card_limit = G.hand.config.card_limit + card.ability.extra.handsize
                SMODS.calculate_effect({message = localize('ortalab_hand_size_gain'), colour = G.C.BLUE}, card)
                draw_card(G.deck, G.hand)
                G.GAME.ortalab.mythos.ya_te_veo_count = G.GAME.ortalab.mythos.ya_te_veo_count + 1
                return true
            end
        }))
    end
})

SMODS.Consumable({
    key = 'anubis',
    set = 'Mythos',
    atlas = 'mythos_cards',
    pos = {x=4, y=1},
    discovered = false,
    config = {extra = {select = 1, curse = 'ortalab_infected', method = 'c_ortalab_mult_random_joker', cards = 1}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
    end,
    can_use = function(self, card)
        if #G.jokers.highlighted > 0 and #G.jokers.highlighted <= card.ability.extra.cards then
            local uncursed = 0
            local i = 1
            while (uncursed <= card.ability.extra.select and i <= #G.jokers.cards) do
                if not G.jokers.cards[i].curse then uncursed = uncursed + 1 end
                i = i + 1
            end
            if uncursed >= card.ability.extra.select then return true end
        end
    end,
    use = function(self, card, area, copier)
        -- Curse random joker
        local select = true
        while select do
            local p_card = pseudorandom_element(G.jokers.cards, pseudoseed('ortalab_anubis'))
            if not p_card.curse then 
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.7,
                    func = function()                
                        p_card:set_curse(card.ability.extra.curse, false, true)
                        p_card:juice_up()
                        play_sound('tarot1')
                        card:juice_up(0.3, 0.5)
                        return true
                    end
                }))
                select = false
            end
        end

        -- Move joker
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()
                draw_card(G.jokers, G.consumeables, nil, nil, nil, G.jokers.highlighted[1])                
                return true
            end
        }))
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
            card.ability.extra.select + G.GAME.ortalab.mythos.extra_select,
            localize({type = 'name_text', set = 'Curse', key = card.ability.extra.curse}),
            colours = {colour}
        }
        if _c.key == 'c_ortalab_jackalope' then
            vars[1] = math.min((vars[1] - G.GAME.ortalab.mythos.extra_select) * G.GAME.ortalab.mythos.jackalope_count + G.GAME.ortalab.mythos.extra_select, G.hand and G.hand.config.card_limit or 100)
        elseif _c.key == 'c_ortalab_ya_te_veo' then
            vars[1] = vars[1] + G.GAME.ortalab.mythos.ya_te_veo_count
        elseif _c.key == 'c_ortalab_talaria' then
            vars[1] = vars[1] + G.GAME.ortalab.mythos.talaria_count
        end
        localize{type = 'descriptions', set = _c.set, key = card.ability.extra.method, nodes = mythos_nodes, vars = vars}
        ui.mythos = mythos_nodes
    end
    return ui
end