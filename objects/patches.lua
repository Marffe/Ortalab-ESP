SMODS.Atlas({
    key = 'patches',
    path = 'patches.png',
    px = '34',
    py = '34'
})

SMODS.Tag({
    key = 'common',
    atlas = 'patches',
    pos = {x = 2, y = 2},
    discovered = false,
    config = {type = 'ortalab_shop_add', extra = {amount = 2}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = '5381'} end
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        return {vars = {card.config.extra.amount}}
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            G.shop_jokers.config.card_limit = G.shop_jokers.config.card_limit + 2
            G.shop_jokers.T.w = math.min((G.GAME.shop.joker_max + 2)*1.02*G.CARD_W,4.08*G.CARD_W)
            G.shop:recalculate()
            for i=1, tag.config.extra.amount do
                local card = create_card('Joker', context.area, nil, 0, nil, nil, nil, 'uta')
                if not card.edition then
                    card:set_edition(poll_edition('ortalab_common_patch', nil, false, true))
                end
                G.shop_jokers:emplace(card)
                create_shop_card_ui(card, 'Joker', context.area)
                card.states.visible = false
                card:start_materialize()
                card.ability.couponed = true
                card:set_cost()
            end
            tag:yep('+', G.C.GREEN,function() 
                return true
            end)
            tag.triggered = true
        end
    end
})

SMODS.Tag({
    key = 'anaglyphic',
    atlas = 'patches',
    pos = {x = 4, y = 2},
    discovered = false,
    config = {type = 'store_joker_modify', edition = 'e_ortalab_anaglyphic'},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        info_queue[#info_queue+1] = G.P_CENTERS[self.config.edition]
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            if not context.card.edition and not context.card.temp_edition and context.card.ability.set == 'Joker' then
                context.card.temp_edition = true
                tag:yep('+', G.C.DARK_EDITION,function() 
                    context.card:set_edition(tag.config.edition, true)
                    context.card.ability.couponed = true
                    context.card:set_cost()
                    context.card.temp_edition = nil
                    return true
                end)
                tag.triggered = true
            end
        end
    end
})

SMODS.Tag({
    key = 'fluorescent',
    atlas = 'patches',
    pos = {x = 0, y = 3},
    discovered = false,
    config = {type = 'store_joker_modify', edition = 'e_ortalab_fluorescent'},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        info_queue[#info_queue+1] = G.P_CENTERS[self.config.edition]
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            if not context.card.edition and not context.card.temp_edition and context.card.ability.set == 'Joker' then
                context.card.temp_edition = true
                tag:yep('+', G.C.DARK_EDITION,function() 
                    context.card:set_edition(tag.config.edition, true)
                    context.card.ability.couponed = true
                    context.card:set_cost()
                    context.card.temp_edition = nil
                    return true
                end)
                tag.triggered = true
            end
        end
    end
})

SMODS.Tag({
    key = 'greyscale',
    atlas = 'patches',
    pos = {x = 1, y = 3},
    discovered = false,
    config = {type = 'store_joker_modify', edition = 'e_ortalab_greyscale'},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'coro'} end
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        info_queue[#info_queue+1] = G.P_CENTERS[self.config.edition]
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            if not context.card.edition and not context.card.temp_edition and context.card.ability.set == 'Joker' then
                context.card.temp_edition = true
                tag:yep('+', G.C.DARK_EDITION,function() 
                    context.card:set_edition(tag.config.edition, true)
                    context.card.ability.couponed = true
                    context.card:set_cost()
                    context.card.temp_edition = nil
                    return true
                end)
                tag.triggered = true
            end
        end
    end
})

SMODS.Tag({
    key = 'overexposed',
    atlas = 'patches',
    pos = {x = 3, y = 2},
    discovered = false,
    config = {type = 'store_joker_modify', edition = 'e_ortalab_overexposed'},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        info_queue[#info_queue+1] = G.P_CENTERS[self.config.edition]
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            if not context.card.edition and not context.card.temp_edition and context.card.ability.set == 'Joker' then
                context.card.temp_edition = true
                tag:yep('+', G.C.DARK_EDITION,function() 
                    context.card:set_edition(tag.config.edition, true)
                    context.card.ability.couponed = true
                    context.card:set_cost()
                    context.card.temp_edition = nil
                    return true
                end)
                tag.triggered = true
            end
        end
    end
})

SMODS.Tag({
    key = 'rewind',
    atlas = 'patches',
    pos = {x = 0, y = 0},
    discovered = false,
    in_pool = function(self)
        if G.GAME.last_selected_tag and G.GAME.last_selected_tag.key ~= 'tag_ortalab_rewind' then
            return true
        end
        return false
    end,
    config = {type = 'immediate'},
    loc_vars = function(self, info_queue, card)
        if card and not card.fake_card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        if card and not card.fake_card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        return {vars = {G.GAME.last_selected_tag and localize({type = 'name_text', set = 'Tag', key = G.GAME.last_selected_tag.key}) or localize('ortalab_no_tag')}}
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            if G.GAME.last_selected_tag and G.GAME.last_selected_tag.key then
                tag:yep('+', G.C.GREEN,function() 
                    return true
                end)
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        local tag = Tag(G.GAME.last_selected_tag.key, false, G.GAME.last_selected_tag.ability.blind_type)
                        if G.GAME.last_selected_tag.key == 'tag_orbital' then
                            local _poker_hands = {}
                            for k, v in pairs(G.GAME.hands) do
                                if v.visible then _poker_hands[#_poker_hands+1] = k end
                            end
                            tag.ability.orbital_hand = pseudorandom_element(_poker_hands, pseudoseed('rewind_orbital'))
                        end
                        add_tag(tag)
                        return true
                end}))
                tag.triggered = true
                return true
            end
            tag:nope()
            return true
        end
    end
})

-- SMODS.Tag({
--     key = 'recycle',
--     atlas = 'patches',
--     pos = {x = 1, y = 0},
--     discovered = false,
-- })

-- SMODS.Tag({
--     key = 'dfour',
--     atlas = 'patches',
--     pos = {x = 2, y = 0},
--     discovered = false,
-- })

-- SMODS.Tag({
--     key = 'bargain',
--     atlas = 'patches',
--     pos = {x = 3, y = 0},
--     discovered = false,
-- })

SMODS.Tag({
    key = 'minion',
    atlas = 'patches',
    pos = {x = 4, y = 0},
    discovered = false,
    config = {type = 'round_start_bonus', modifier = 0.5},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            if G.GAME.blind:get_type() == 'Boss' then return end
            tag:yep('+', G.C.GREEN ,function() 
                return true
            end)
            G.E_MANAGER:add_event(Event({
                delay = 0.2,
                trigger = 'after',
                func = function()
            G.GAME.blind.chips = G.GAME.blind.chips * tag.config.modifier
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            return true
                end}))
            tag.triggered = true
        end
    end
})

SMODS.Tag({
    key = 'slipup',
    atlas = 'patches',
    pos = {x = 0, y = 1},
    discovered = false,
    config = {type = 'round_start_bonus', discards = 3, hands = 3},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {self.config.discards, self.config.hands}}
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            tag:yep('+', G.C.RED ,function() 
                return true
            end)
            ease_discard(tag.config.discards)
            ease_hands_played(tag.config.hands)
            tag.triggered = true
        end
    end
})

-- SMODS.Tag({
--     key = 'extraordinary',
--     atlas = 'patches',
--     pos = {x = 1, y = 1},
--     discovered = false,
-- })

-- SMODS.Tag({
--     key = 'charm',
--     atlas = 'patches',
--     pos = {x = 2, y = 1},
--     discovered = false,
-- })

-- SMODS.Tag({
--     key = 'buffoon',
--     atlas = 'patches',
--     pos = {x = 3, y = 1},
--     discovered = false,
-- })

-- SMODS.Tag({
--     key = 'jackpot',
--     atlas = 'patches',
--     pos = {x = 4, y = 1},
--     discovered = false,
-- })

SMODS.Tag({
    key = 'soul',
    atlas = 'patches',
    pos = {x = 0, y = 2},
    soul_pos = {x = 1, y = 2},
    discovered = false,
    min_ante = 3,
    config = {type = 'store_joker_create'},
    in_pool = function(self)
        local chance = pseudoseed('ortalab_soul_patch')
        if chance < 0.25 then
            return true
        end
        return false
    end,
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        return {vars = {self.config.cost}}
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            local card = create_card('Joker', context.area, true, 1, nil, nil, nil, 'uta')
            create_shop_card_ui(card, 'Joker', context.area)
            card.states.visible = false
            tag:yep('+', G.C.GREEN,function() 
                card:start_materialize()
                card.ability.couponed = true
                card:set_cost()
                return true
            end)
            tag.triggered = true
            return card
        end
    end
})

SMODS.Tag({
    key = 'slayer',
    atlas = 'patches',
    pos = {x = 0, y = 4},
    discovered = false,
    min_ante = 2,
    config = {type = 'immediate', dollars = 3},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        return {vars = {self.config.dollars, (G.GAME.blinds_defeated or 0)*self.config.dollars}}
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            tag:yep('+', G.C.MONEY,function() 
                G.CONTROLLER.locks[tag.ID] = nil
                return true
            end)
            ease_dollars((G.GAME.blinds_defeated or 0)*tag.config.dollars)
            tag.triggered = true
            return true
        end
    end
})

SMODS.Tag({
    key = 'dandy',
    atlas = 'patches',
    pos = {x = 3, y = 3},
    discovered = false,
    min_ante = 2,
    config = {type = 'immediate', dollars = 1},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        return {vars = {self.config.dollars, (G.GAME.unused_hands or 0)*self.config.dollars}}
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            tag:yep('+', G.C.MONEY,function() 
                return true
            end)
            ease_dollars((G.GAME.unused_hands or 0)*tag.config.dollars)
            tag.triggered = true
            return true
        end
    end
})

SMODS.Tag({
    key = 'loteria',
    atlas = 'patches',
    pos = {x = 2, y = 4},
    discovered = false,
    config = {type = 'shop_final_pass', packs = 2},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        info_queue[#info_queue + 1] = G.P_CENTERS['p_ortalab_big_loteria_1']
        return {vars = {self.config.packs}}
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            tag:yep('+', G.C.GREEN,function()
                for i=1, tag.config.packs do
                    local pack = Card(G.shop_booster.T.x + G.shop_booster.T.w/2,
                    G.shop_booster.T.y, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS['p_ortalab_big_loteria_'..i], {bypass_discovery_center = true, bypass_discovery_ui = true})
                    create_shop_card_ui(pack, 'Booster', G.shop_booster)
                    pack.ability.booster_pos = #G.shop_booster.cards + 1
                    pack.ability.couponed = true
                    pack:start_materialize()
                    G.shop_booster:emplace(pack)
                    pack:set_cost()
                end
                return true
            end)
        end
    end
})

SMODS.Tag({
    key = 'crater',
    atlas = 'patches',
    pos = {x = 2, y = 3},
    discovered = false,
    config = {type = 'shop_final_pass', packs = 2},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        info_queue[#info_queue + 1] = G.P_CENTERS['p_ortalab_mid_zodiac_1']
        return {vars = {self.config.packs}}
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            tag:yep('+', G.C.GREEN,function()
                for i=1, tag.config.packs do
                    local pack = Card(G.shop_booster.T.x + G.shop_booster.T.w/2,
                    G.shop_booster.T.y, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS['p_ortalab_mid_zodiac_'..i], {bypass_discovery_center = true, bypass_discovery_ui = true})
                    create_shop_card_ui(pack, 'Booster', G.shop_booster)
                    pack.ability.booster_pos = #G.shop_booster.cards + 1
                    pack.ability.couponed = true
                    pack:start_materialize()
                    G.shop_booster:emplace(pack)
                    pack:set_cost()
                end
                return true
            end)
        end 
    end
})

local skip_blind = G.FUNCS.skip_blind
G.FUNCS.skip_blind = function(e)
    local _tag = e.UIBox:get_UIE_by_ID('tag_container').config.ref_table
    skip_blind(e)
    if _tag.key == 'tag_ortalab_rewind' then return end
    G.GAME.last_selected_tag = _tag or G.GAME.last_selected_tag
end

SMODS.Tag({
    key = 'constellation',
    atlas = 'patches',
    pos = {x = 1, y = 4},
    discovered = false,
    config = {type = 'round_start_bonus', extra = {zodiacs = 3}},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        if card.ability.zodiac_hands and G.ZODIACS[card.ability.zodiac_hands[1]] then
            return {vars = {
                localize(G.ZODIACS[card.ability.zodiac_hands[1]].config.extra.hand_type, 'poker_hands'), card.config and card.config.extra and card.config.extra.zodiacs or card.ability.extra.zodiacs
            }}
        else
            return {vars = {'['..localize('k_poker_hand')..']', card.config.extra.zodiacs}}
        end
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            tag:yep('+', G.C.GREEN,function()
                tag.triggered = true
                return true
            end)
            local key = tag.ability.zodiac_hands[1]
            G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 1,
                    func = function()
                        if G.zodiacs and G.zodiacs[key] then
                            G.zodiacs[key].config.extra.temp_level = G.zodiacs[key].config.extra.temp_level + (G.ZODIACS[key].config.extra.temp_level * tag.config.extra.zodiacs)
                            zodiac_text(zodiac_upgrade_text(key), key)
                            G.zodiacs[key]:juice_up(1, 1)
                            delay(0.7)
                        else
                            print(tag.config.extra.zodiacs)
                            add_zodiac(Zodiac(key), nil, nil, tag.config.extra.zodiacs)
                        end
                        return true
                    end
                }))
            end
    end,
    set_ability = function(self, tag)
        if not tag.ability.blind_type then tag.ability.blind_type = 'Small' end
        if G.zodiac_choices then
            tag.ability.zodiac_hands = G.zodiac_choices
        elseif tag.ability.blind_type then
            if G.GAME.zodiac_choices and G.GAME.zodiac_choices[G.GAME.round_resets.ante] and G.GAME.zodiac_choices[G.GAME.round_resets.ante][tag.ability.blind_type] then
                tag.ability.zodiac_hands = G.GAME.zodiac_choices[G.GAME.round_resets.ante][tag.ability.blind_type]
            else
                local _poker_hands = {}
                for k, _ in pairs(G.ZODIACS) do
                    _poker_hands[#_poker_hands+1] = k
                end
            
                local zodiac1 = pseudorandom_element(_poker_hands, pseudoseed('constellation_patch'))
                tag.ability.zodiac_hands = {zodiac1}
            end
        end
    end
})

SMODS.Tag({
    key = 'stock',
    atlas = 'patches',
    pos = {x = 3, y = 4},
    discovered = false,
    config = {type = 'immediate', vouchers = 1},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo'} end
    end,
    apply = function(self, tag, context)
        if context.type == tag.config.type then
            tag:yep('+', G.C.GREEN,function()
                for i=1, tag.config.vouchers do
                    local _pool = get_current_pool('Voucher')
                    local voucher = pseudorandom_element(_pool, pseudoseed('ortalab_stock_patch'))
                    local it = 1
                    while voucher == 'UNAVAILABLE' do
                        it = it + 1
                        voucher = pseudorandom_element(_pool, pseudoseed('ortalab_stock_patch_resample'..it))
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
                return true
            end)
            return true
        end
        
    end
})

SMODS.Tag({
    key = 'recycle',
    atlas = 'patches',
    pos = {x = 1, y = 0},
    discovered = false,
    min_ante = 2,
    config = {type = 'immediate', sell_inc = 2},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        return {vars = {card.config.sell_inc, card.config.sell_inc * (G.GAME.skips + 1)}}
    end,
    apply = function(self, tag, context)
        if context.type == tag.config.type then
            tag:yep('+', G.C.MONEY,function() 
                local inc_amount = tag.config.sell_inc * G.GAME.skips
                for k=1, #G.jokers.cards + #G.consumeables.cards do
                    local _card = G.jokers.cards[k] or G.consumeables.cards[k - #G.jokers.cards]
                    if _card.config.center.set == 'Joker' then
                        _card.ability.extra_value = _card.ability.extra_value + inc_amount
                        _card:set_cost()
                    end
                end
                return true
            end)
            tag.triggered = true
            return true
        end
    end
})

SMODS.Tag({
    key = 'mythical',
    atlas = 'patches',
    pos = {x = 4, y = 3},
    discovered = false,
    min_ante = 3,
    config = {type = 'shop_final_pass', packs = 2},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
        info_queue[#info_queue + 1] = G.P_CENTERS['p_ortalab_big_mythos']
        return {vars = {self.config.packs}}
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            tag:yep('+', G.C.GREEN,function()
                for i=1, tag.config.packs do
                    local pack = Card(G.shop_booster.T.x + G.shop_booster.T.w/2,
                    G.shop_booster.T.y, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS['p_ortalab_big_mythos'], {bypass_discovery_center = true, bypass_discovery_ui = true})
                    create_shop_card_ui(pack, 'Booster', G.shop_booster)
                    pack.ability.booster_pos = #G.shop_booster.cards + 1
                    pack.ability.couponed = true
                    pack:start_materialize()
                    G.shop_booster:emplace(pack)
                    pack:set_cost()
                end
                return true
            end)
        end 
    end
})

SMODS.Tag({
    key = 'immolate',
    atlas = 'patches',
    pos = {x = 4, y = 4},
    discovered = false,
    config = {type = 'immediate', cards = 5, dollars = 20},
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo'} end
        return {vars = {card.config.cards, card.config.dollars}}
    end,
    apply = function(self, tag, context)
        if context.type == self.config.type then
            tag:yep('+', G.C.GREEN,function()
                local destroyed = {}
                local start_point = pseudorandom(pseudoseed('ortalab_immolate_patch'), 1, #G.deck.cards)
                for i=1, tag.config.cards do
                    destroyed[i] = G.deck.cards[((start_point + i) % #G.deck.cards)+1]
                    draw_card(G.deck, G.play, nil, nil, nil, destroyed[i])
                end
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.7,
                    func = function()
                        attention_text({
                            scale = 1.4, text = '+$'..tag.config.dollars, hold = 1, align = 'cm', offset = {x = 0,y = -2.7},major = G.play,backdrop_colour = G.C.MONEY
                        })
                        return true
                    end
                }))
                ease_dollars(tag.config.dollars)
                for i=1, #destroyed do
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.4,
                        func = function() 
                            local card = destroyed[i]
                            if SMODS.shatters(card) then
                                card:shatter()
                            else
                                card:start_dissolve(nil, i == #destroyed)
                        end
                        return true 
                    end }))
                end
                SMODS.calculate_context({ remove_playing_cards = true, removed = destroyed })
                return true
            end)
            return true
        end 
    end
})