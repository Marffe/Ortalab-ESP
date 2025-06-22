SMODS.Atlas({
    key = 'stakes',
    path = 'stakes.png',
    px = '29',
    py = '29'
})

SMODS.Atlas({
    key = 'stickers',
    path = 'stake_stickers.png',
    px = 71,
    py = 95
})

SMODS.Stake({
    key = "one",
    applied_stakes = {},
    above_stake = 'gold',
    prefix_config = {above_stake = {false}},
    atlas = 'stakes',
    pos = {x = 0, y = 0},
    shiny = true,
    sticker_pos = {x = 0, y = 0},
    sticker_atlas = 'stickers',
    modifiers = function()
        G.GAME.modifiers.ortalab_only = Ortalab.config.ortalab_only
        G.GAME.ortalab.double_blind = true
        -- Modify vanilla shop rates
        if Ortalab.config.ortalab_only then
            G.GAME.planet_rate = 0
            G.GAME.tarot_rate = 0
            G.GAME.loteria_rate = 4
            G.GAME.zodiac_rate = 2.8
            -- G.GAME.mythos_rate = 1.2
        end
    end,
})

Ortalab.ortalab_only_inclusion = { -- Vanilla objects that are allowed in Ortalab only mode
    'e_negative',
    'Red',
    'Gold'
}

SMODS.Atlas({
    key = 'seals',
    path = 'seals.png',
    px = 71,
    py = 95
})

SMODS.Seal({
    key = 'cyan',
    atlas = 'seals',
    pos = {x=0,y=0},
    config = {extra = {levels = 2}},
    no_collection = true,
    badge_colour = HEX('7e94ba'),
    in_pool = function(self)
        return G.GAME.modifiers.ortalab_only
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.seal.extra.levels}}
    end,
    calculate = function(self, card, context)
        if context.playing_card_end_of_round and context.cardarea == G.hand then
            local _poker_hands = {}
            for k, v in pairs(G.GAME.hands) do
                if v.visible then _poker_hands[#_poker_hands+1] = k end
            end
            local hand_to_level = pseudorandom_element(_poker_hands, pseudoseed('cyanseal'))
            return {
                message = localize(hand_to_level, 'poker_hands'),
                colour = G.ARGS.LOC_COLOURS.Zodiac,
                level_up = card.ability.seal.extra.levels,
                level_up_hand = hand_to_level
            }
        end
    end
})

SMODS.Seal({
    key = 'fuchsia',
    atlas = 'seals',
    pos = {x=1,y=0},
    config = {},
    no_collection = true,
    badge_colour = HEX('A85D7C'),
    in_pool = function(self)
        return G.GAME.modifiers.ortalab_only
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card == card and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            return {
                message = localize('ortalab_loteria_add'),
                colour = G.C.SECONDARY_SET.Loteria,
                func = function()
                    SMODS.add_card({set = 'Loteria'})
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer - 1
                end
            }
        end
    end
})

SMODS.Stake({
    key = "two",
    applied_stakes = {'one'},
    above_stake = 'one',
    atlas = 'stakes',
    pos = {x = 1, y = 0},
    shiny = true,
    sticker_pos = {x = 1, y = 0},
    sticker_atlas = 'stickers',
    modifiers = function()
        G.GAME.ortalab.blind_rewards = G.GAME.ortalab.blind_rewards - 1
    end,
})

SMODS.Stake({
    key = "three",
    applied_stakes = {'two'},
    above_stake = 'two',
    atlas = 'stakes',
    pos = {x = 2, y = 0},
    shiny = true,
    sticker_pos = {x = 2, y = 0},
    sticker_atlas = 'stickers',
    modifiers = function()
        G.GAME.modifiers.scaling = (G.GAME.modifiers.scaling or 1) + 1
        G.GAME.win_ante = G.GAME.win_ante + 1
    end,
})

SMODS.Stake({
    key = "four",
    applied_stakes = {'three'},
    above_stake = 'three',
    atlas = 'stakes',
    pos = {x = 3, y = 0},
    shiny = true,
    sticker_pos = {x = 3, y = 0},
    sticker_atlas = 'stickers',
    modifiers = function()
        G.GAME.ortalab.skips_required = true
        G.GAME.ortalab.skips = 3
    end,
})

local ortalab_blind_choice_handler = G.FUNCS.blind_choice_handler
G.FUNCS.blind_choice_handler = function(e)
    ortalab_blind_choice_handler(e)
    local _blind_choice_box = e.UIBox:get_UIE_by_ID('select_blind_button')
    if e.config.id ~= 'Boss' and _blind_choice_box and G.GAME.round_resets.blind_states[e.config.id] == 'Select' and G.GAME.ortalab.skips_required and G.GAME.ortalab.skips > 0 and Ortalab.rounds_left(e.config.id) == G.GAME.ortalab.skips then
        G.GAME.round_resets.loc_blind_states[e.config.id] = localize('b_skip_blind')
        _blind_choice_box.config.colour = darken(G.C.RED, 0.2)
        _blind_choice_box.config.outline = 1
        _blind_choice_box.config.outline_colour = G.C.RED
        _blind_choice_box.config.button = 'skip_blind'
    end
end

function Ortalab.rounds_left(blind)
    local antes_left = G.GAME.win_ante - G.GAME.round_resets.ante
    local rounds_left = (antes_left * 2) + (blind == 'Small' and 2 or blind == 'Big' and 1 or 0)
    if G.GAME.ortalab.finisher_ante then rounds_left = rounds_left - 2 end
    return rounds_left
end

SMODS.Stake({
    key = "five",
    applied_stakes = {'four'},
    above_stake = 'four',
    atlas = 'stakes',
    pos = {x = 4, y = 0},
    shiny = true,
    sticker_pos = {x = 4, y = 0},
    sticker_atlas = 'stickers',
    modifiers = function()
        G.GAME.ortalab.round_decay = 1
        G.GAME.modifiers.scaling = (G.GAME.modifiers.scaling or 1) + 1
    end,
})

SMODS.Stake({
    key = "six",
    applied_stakes = {'five'},
    above_stake = 'five',
    atlas = 'stakes',
    pos = {x = 5, y = 0},
    shiny = true,
    sticker_pos = {x = 5, y = 0},
    sticker_atlas = 'stickers',
    modifiers = function()
        G.GAME.ortalab.shop_curses = true
    end,
})

SMODS.Stake({
    key = "seven",
    applied_stakes = {'six'},
    above_stake = 'six',
    atlas = 'stakes',
    pos = {x = 6, y = 0},
    shiny = true,
    sticker_pos = {x = 6, y = 0},
    sticker_atlas = 'stickers',
    modifiers = function()
        G.GAME.ortalab.ante_showdown = true
    end,
})

SMODS.Stake({
    key = "eight",
    applied_stakes = {'seven'},
    above_stake = 'seven',
    atlas = 'stakes',
    pos = {x = 7, y = 0},
    shiny = true,
    sticker_pos = {x = 7, y = 0},
    sticker_atlas = 'stickers',
    modifiers = function()
        G.GAME.ortalab.finisher_ante = true
    end,
})

function get_pack(_key, _type)
    if not G.GAME.first_shop_buffoon and not G.GAME.banned_keys['p_buffoon_normal_1'] then
        G.GAME.first_shop_buffoon = true
        return G.P_CENTERS['p_buffoon_normal_'..(math.random(1, 2))]
    end
    local cume, it, center = 0, 0, nil
	local temp_in_pool = {}
    for k, v in ipairs(G.P_CENTER_POOLS['Booster']) do
		local add
		v.current_weight = v.get_weight and v:get_weight() or v.weight or 1
        if (not _type or _type == v.kind) then add = true end
		if v.in_pool and type(v.in_pool) == 'function' then 
			local res, pool_opts = v:in_pool()
			pool_opts = pool_opts or {}
			add = res and (add or pool_opts.override_base_checks)
		end
        if v.kind ~= 'Buffoon' and v.kind ~= 'Standard' and G.GAME.modifiers.ortalab_only then
            if not v.mod or v.mod.id ~= 'ortalab' then add = false end
        end
		if add and not G.GAME.banned_keys[v.key] then cume = cume + (v.current_weight or 1); temp_in_pool[v.key] = true end
    end
    local poll = pseudorandom(pseudoseed((_key or 'pack_generic')..G.GAME.round_resets.ante))*cume
    for k, v in ipairs(G.P_CENTER_POOLS['Booster']) do
        if temp_in_pool[v.key] then 
            it = it + (v.current_weight or 1)
            if it >= poll and it - (v.current_weight or 1) <= poll then center = v; break end
        end
    end
   if not center then center = G.P_CENTERS['p_buffoon_normal_1'] end  return center
end

local card_open = Card.open
function Card:open()
    if self.ability.set == 'Booster' and G.GAME.modifiers.ortalab_only and self.ability.name:find('Standard') then
        stop_use()
        G.STATE_COMPLETE = false 
        self.opening = true

        if not self.config.center.discovered then
            discover_card(self.config.center)
        end
        self.states.hover.can = false
    
        G.STATE = G.STATES.STANDARD_PACK
        G.GAME.pack_size = self.ability.extra

        G.GAME.pack_choices = self.config.center.config.choose or 1

        if self.cost > 0 then 
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
                inc_career_stat('c_shop_dollars_spent', self.cost)
                self:juice_up()
            return true end }))
            ease_dollars(-self.cost) 
       else
           delay(0.2)
       end

        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            self:explode()
            local pack_cards = {}

            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 1.3*math.sqrt(G.SETTINGS.GAMESPEED), blockable = false, blocking = false, func = function()
                local _size = self.ability.extra
                
                for i = 1, _size do
                    local card = create_card((pseudorandom(pseudoseed('stdset'..G.GAME.round_resets.ante)) > 0.6) and "Enhanced" or "Base", G.pack_cards, nil, nil, nil, true, nil, 'sta')
                        local edition_rate = 2
                        local edition = poll_edition('standard_edition'..G.GAME.round_resets.ante, edition_rate, true, nil, {'e_ortalab_greyscale','e_ortalab_fluorescent','e_ortalab_anaglyphic'})
                        card:set_edition(edition)
                        card:set_seal(SMODS.poll_seal({mod = 10}))
                   
                    card.T.x = self.T.x
                    card.T.y = self.T.y
                    card:start_materialize({G.C.WHITE, G.C.WHITE}, nil, 1.5*G.SETTINGS.GAMESPEED)
                    pack_cards[i] = card
                end
                return true
            end}))

            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 1.3*math.sqrt(G.SETTINGS.GAMESPEED), blockable = false, blocking = false, func = function()
                if G.pack_cards then 
                    if G.pack_cards and G.pack_cards.VT.y < G.ROOM.T.h then 
                    for k, v in ipairs(pack_cards) do
                        G.pack_cards:emplace(v)
                    end
                    return true
                    end
                end
            end}))

            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({open_booster = true, card = self})
            end

            if G.GAME.modifiers.inflation then 
                G.GAME.inflation = G.GAME.inflation + 1
                G.E_MANAGER:add_event(Event({func = function()
                  for k, v in pairs(G.I.CARD) do
                      if v.set_cost then v:set_cost() end
                  end
                  return true end }))
            end

        return true end }))
    else
        card_open(self)
    end
end

-- Override get_next_tag_key to disable skipping the final ante blinds
local get_next_tag_key_ortalab_ref = get_next_tag_key
function get_next_tag_key(append)
    if G.GAME.ortalab.finisher_ante and G.GAME.round_resets.ante == G.GAME.win_ante then
        return nil
    end
    return get_next_tag_key_ortalab_ref(append)
end