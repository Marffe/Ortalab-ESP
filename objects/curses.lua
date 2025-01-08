SMODS.Atlas({
    key = 'curses',
    path = 'curses.png',
    px = 71,
    py = 95
})

Ortalab.Curses = {}
Ortalab.curse_sprites = {}
G.P_CENTER_POOLS.Curse = {}
Ortalab.Curse = SMODS.GameObject:extend {
    obj_table = Ortalab.Curses,
    obj_buffer = {},
    badge_to_key = {},
    set = 'Curse',
    atlas = 'curses',
    pos = { x = 0, y = 0 },
    discovered = false,
    badge_colour = HEX('FFFFFF'),
    required_params = {
        'key',
        'pos',
    },
    inject = function(self)
        Ortalab.Curses[self.key] = self
        Ortalab.curse_sprites[self.key] = Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS[self.atlas] or G.ASSET_ATLAS['ortalab_curses'], self.pos)
        self.badge_to_key[self.key:lower()] = self.key
        if not G.P_CENTER_POOLS.Curse then G.P_CENTER_POOLS.Curse = {} end
        SMODS.insert_pool(G.P_CENTER_POOLS[self.set], self)
    end,
    process_loc_text = function(self)
        SMODS.process_loc_text(G.localization.descriptions.Curse, self.key:lower(), self.loc_txt)
        SMODS.process_loc_text(G.localization.misc.labels, self.key:lower(), self.loc_txt, 'label')
    end,
    get_obj = function(self, key) return Ortalab.Curses[key] end,    
}

SMODS.current_mod.custom_collection_tabs = function()
	return {
		UIBox_button({button = 'your_collection_curses', label = {'Curses'}, count = G.ACTIVE_MOD_UI and modsCollectionTally(Ortalab.Curses) or G.DISCOVER_TALLIES.Curse, minw = 5, minh = 1, id = 'your_collection_curses', focus_args = {snap_to = true}})
	}
end

G.FUNCS.your_collection_curses = function(e)
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu{
		definition = create_UIBox_your_collection_curses(),
	}
end

function create_UIBox_your_collection_curses(exit)
	local deck_tables = {}
	local curse_pool = SMODS.collection_pool(G.P_CENTER_POOLS.Curse)
	local rows, cols = (#curse_pool > 4 and 2 or 1), 4
	local page = 0

	G.your_collection = {}
	for j = 1, rows do
		G.your_collection[j] = CardArea(G.ROOM.T.x + 0.2 * G.ROOM.T.w / 2, G.ROOM.T.h, 5.3 * G.CARD_W, 1.03 * G.CARD_H,
			{card_limit = cols, type = 'title', highlight_limit = 0, collection = true})
		table.insert(deck_tables, {n = G.UIT.R, config = {align = "cm", padding = 0, no_fill = true}, nodes = {{n = G.UIT.O, config = {object = G.your_collection[j]}}}})
	end

	table.sort(curse_pool, function(a, b) return a.order < b.order end)

	local count = math.min(cols * rows, #curse_pool)
	local index = 1 + (rows * cols * page)
	for j = 1, rows do
		for i = 1, cols do
			local curse = curse_pool[index]

			if not curse then break end
			local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w / 2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS.c_base)
			card:set_curse(curse.key, true, true)
			G.your_collection[j]:emplace(card)
			index = index + 1
		end
		if index > count then break end
	end

	local curse_page_options = {}

	local t = create_UIBox_generic_options({
		back_func = G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or exit or 'your_collection',
		snap_back = true,
		contents = { 
			{n = G.UIT.R, config = {align = "cm", minw = 2.5, padding = 0.1, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes = deck_tables}}
	})

	if #curse_pool > rows * cols then
		for i = 1, math.ceil(#curse_pool / (rows * cols)) do
			table.insert(curse_page_options, localize('k_page') .. ' ' .. tostring(i) .. '/' ..
				tostring(math.ceil(#curse_pool / (rows * cols))))
		end
		t = create_UIBox_generic_options({
			back_func = G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or exit or 'your_collection',
			snap_back = true,
			contents = {
				{n = G.UIT.R, config = {align = "cm", minw = 2.5, padding = 0.1, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes = deck_tables},
				{n = G.UIT.R, config = {align = "cm"}, nodes = { 
					create_option_cycle({options = curse_page_options, w = 4.5, cycle_shoulders = true, opt_callback = 'your_collection_curse_page',
						focus_args = { snap_to = true, nav = 'wide' }, current_option = 1, r = rows, c = cols, colour = G.C.RED, no_pips = true})
                }}
			}
		})
	end
	return t
end

G.FUNCS.your_collection_curse_page = function(args)
	if not args or not args.cycle_config then return end
	local curse_pool = SMODS.collection_pool(G.P_CENTER_POOLS.Curse)
	local rows, cols = (#curse_pool > 4 and 2 or 1), 4
	local page = args.cycle_config.current_option
	if page > math.ceil(#curse_pool / (rows * cols)) then
		page = page - math.ceil(#curse_pool / (rows * cols))
	end
	local count = rows * cols
	local offset = (rows * cols) * (page - 1)

	for j = 1, #G.your_collection do
		for i = #G.your_collection[j].cards, 1, -1 do
			if G.your_collection[j] ~= nil then
				local c = G.your_collection[j]:remove_card(G.your_collection[j].cards[i])
				c:remove()
				c = nil
			end
		end
	end

	for j = 1, rows do
		for i = 1, cols do
			if count % rows > 0 and i <= count % rows and j == cols then
				offset = offset - 1
				break
			end
			local idx = i + (j - 1) * cols + offset
			if idx > #curse_pool then return end
			local curse = curse_pool[idx]
			local card = Card(G.your_collection[j].T.x + G.your_collection[j].T.w / 2, G.your_collection[j].T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS.c_base)
			card:set_curse(curse.key, true)
			G.your_collection[j]:emplace(card)
		end
	end
end

function Card:set_curse(_curse, silent, immediate, spread, message)
    if self.ability.forced_selection == 'ortalab_possessed' then self.ability.forced_selection = nil end
    if _curse then
        self.ability.curse = {}
        for k, v in pairs(Ortalab.Curses[_curse].config or {}) do
            if type(v) == 'table' then
                self.ability.curse[k] = copy_table(v)
            else
                self.ability.curse[k] = v
            end
        end

        G.CONTROLLER.locks.seal = true
        local sound = Ortalab.Curses[_curse].sound or {sound = 'gold_seal', per = 1.2, vol = 0.4}
        if immediate then 
            self.curse = nil
            self:juice_up(0.3, 0.3)
            if not silent then play_sound(sound.sound, sound.per, sound.vol) end
            if not silent then card_eval_status_text(self, 'extra', nil, nil, nil, {instant = true, message = message or localize({type = 'name_text', set = 'Curse', key = _curse})..'!', colour = Ortalab.Curses[_curse].badge_colour}) end
            self.curse = _curse
            G.CONTROLLER.locks.seal = false
        else
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                func = function()
                    self.curse = nil
                    self:juice_up(0.3, 0.3)
                    self.curse = _curse
                    if not silent then
                        play_sound(sound.sound, sound.per, sound.vol)
                        card_eval_status_text(self, 'extra', nil, nil, nil, {instant = true, message = message or localize({type = 'name_text', set = 'Curse', key = _curse})..'!', colour = Ortalab.Curses[_curse].badge_colour})
                    end
                return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.CONTROLLER.locks.seal = false
                return true
                end
            }))
        end
    else
        self.curse = nil
    end
    self:set_cost()
end

function Card:calculate_curse(context)
    if self.debuff then return nil end
    local obj = Ortalab.Curses[self.curse] or {}
    if obj.calculate and type(obj.calculate) == 'function' then
    	local o = obj:calculate(self, context)
    	if o then return o end
    end
end

Ortalab.Curse({
    key = 'corroded',
    atlas = 'curses',
    pos = {x = 0, y = 0},
    badge_colour = HEX('dc2e33'),
    config = {extra = {base = 3, gain = 1}},
    in_pool = function(self)
        return false
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
		return {vars = {self.config.extra.base, self.config.extra.gain}}
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card == card then
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize({type = 'name_text', set = 'Curse', key = self.key})..'!', colour = self.badge_colour})
            card.ability.curse.extra.base = card.ability.curse.extra.base + card.ability.curse.extra.gain
            card.corroded_discard = true
        end
        if context.cardarea == G.play and context.main_scoring and not context.repetition and not context.individual then
            return {
                p_dollars = -card.ability.curse.extra.base,
            }
        end
    end
})

Ortalab.Curse({
    key = 'possessed',
    atlas = 'curses',
    pos = {x = 1, y = 0},
    badge_colour = HEX('82b4f4'),
    config = {extra = {force = true}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
    end,
})

Ortalab.Curse({
    key = 'restrained',
    atlas = 'curses',
    pos = {x = 2, y = 0},
    badge_colour = HEX('d78532'),
    config = {extra = {level_loss = 2}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {self.config.extra.level_loss}}
    end,
    calculate = function(self, card, context)
        if context.before and context.cardarea == G.hand then
            G.GAME.ortalab.temp_levels = G.GAME.ortalab.temp_levels - card.ability.curse.extra.level_loss
            return {
                message = localize({type = 'name_text', set = 'Curse', key = self.key})..'!',
                colour = self.badge_colour,
            }
        end
    end
})


G.ARGS.LOC_COLOURS.infected = HEX('849a3f')

SMODS.Sound({
    key = 'infected',
    path = 'infected.ogg'
})

Ortalab.Curse({
    key = 'infected',
    atlas = 'curses',
    pos = {x = 3, y = 0},
    badge_colour = HEX('849a3f'),
    sound = {sound = 'ortalab_infected', per = 1.2, vol = 0.4},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card == card then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    G.E_MANAGER:add_event(Event({func = function()
                        local uncursed_hand_cards = {}
                        for _, card in ipairs(G.hand.cards) do
                            if not card.ability.curse then uncursed_hand_cards[#uncursed_hand_cards + 1] = card end
                        end
                        if #uncursed_hand_cards == 0 then return true end
                        local card_to_spread = pseudorandom_element(uncursed_hand_cards, pseudoseed('ortalab_infected_spread'))
                        card_to_spread:set_curse('ortalab_infected', nil, nil, true)
                        card:set_curse()
                        return true
                    end}))
                    return true
                end
            }))
        end
    end
})

local dfdtd = G.FUNCS.draw_from_discard_to_deck
G.FUNCS.draw_from_discard_to_deck = function(e)
    for _, card in pairs(G.discard.cards) do
        card.no_score = nil
    end
    dfdtd(e)
end