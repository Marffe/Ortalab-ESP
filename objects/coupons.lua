SMODS.Atlas({
    key = 'coupons',
    path = 'coupons.png',
    px = '71',
    py = '95'
})

SMODS.Voucher({
	key = "catalog",
	atlas = "coupons",
	pos = {x = 0, y = 0},
	cost = 10,
	unlocked = true,
	discovered = false,
	available = true,
	config = {extra = {booster_gain = 1}},
	redeem = function(self, card)
        G.GAME.modifiers.ortalab_boosters = (G.GAME.modifiers.ortalab_boosters or 0) + card.ability.extra.booster_gain
        if G.STATE == G.STATES.SHOP then Ortalab.spawn_booster() end
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {card.ability.extra.booster_gain}}
    end,
})

SMODS.Voucher({
	key = "ad_campaign",
	atlas = "coupons",
	pos = {x = 1, y = 0},
	cost = 10,
	unlocked = true,
	discovered = false,
	available = false,
    requires = {'v_ortalab_catalog'},
	config = {extra = {voucher_gain = 1}},
	redeem = function(self, card)
        G.GAME.current_round.voucher_2 = get_next_voucher_key()
        if G.shop_vouchers then
            G.shop_vouchers.config.card_limit = G.shop_vouchers.config.card_limit + card.ability.extra.voucher_gain
            if G.GAME.current_round.voucher_2 and G.P_CENTERS[G.GAME.current_round.voucher_2] then
                local card = Card(G.shop_vouchers.T.x + G.shop_vouchers.T.w/2,
                G.shop_vouchers.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[G.GAME.current_round.voucher_2],{bypass_discovery_center = true, bypass_discovery_ui = true})
                card.shop_voucher = true
                create_shop_card_ui(card, 'Voucher', G.shop_vouchers)
                card:start_materialize()
                G.shop_vouchers:emplace(card)
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {card.ability.extra.voucher_gain}}
    end,
})

SMODS.Voucher({
	key = "home_delivery",
	atlas = "coupons",
	pos = {x = 2, y = 0},
	cost = 10,
	unlocked = true,
	discovered = false,
	available = true,
	redeem = function(self, card)
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
    end,
})

SMODS.Voucher({
	key = "hoarding",
	atlas = "coupons",
	pos = {x = 3, y = 0},
	cost = 10,
	unlocked = true,
	discovered = false,
	available = false,
    requires = {'v_ortalab_home_delivery'},
	redeem = function(self, card)
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
    end,
})

SMODS.Voucher({
	key = "window_shopping",
	atlas = "coupons",
	config = {extra = {free_rerolls = 1}},
	pos = {x = 4, y = 0},
	cost = 10,
	unlocked = true,
	discovered = false,
	available = true,
	redeem = function(self, card)
        G.E_MANAGER:add_event(Event({func = function()
            window_infinite(card)
            return true 
        end }))
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {card.ability.extra.free_rerolls}}
    end,
})

SMODS.Voucher({
	key = "infinite_scroll",
	atlas = "coupons",
	pos = {x = 5, y = 0},
	cost = 10,
	unlocked = true,
	discovered = false,
	available = false,
	requires = {'v_ortalab_window_shopping'},
	config = {extra = {free_rerolls = 2}},
	redeem = function(self, card)
        G.E_MANAGER:add_event(Event({func = function()
            window_infinite(card)
            return true 
        end }))
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {card.ability.extra.free_rerolls}}
    end,
})

SMODS.Voucher({
	key = "horoscope",
	atlas = "coupons",
	pos = {x = 2, y = 2},
	cost = 10,
	unlocked = true,
	discovered = false,
	available = true,
    config = {extra = {extra_choices = 1}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.extra_choices}}
    end,
    redeem = function(self, voucher)
        G.GAME.ortalab.vouchers.horoscope = G.GAME.ortalab.vouchers.horoscope + voucher.ability.extra.extra_choices
    end
})

SMODS.Voucher({
	key = "natal_sign",
	atlas = "coupons",
	pos = {x = 3, y = 2},
	cost = 10,
	unlocked = true,
	discovered = false,
	available = true,
    config = {extra = {xmult = 1.1, per = 4}},
    requires = {'v_ortalab_horoscope'},
	redeem = function(self, card)
        G.GAME.natal_sign_rate = card.ability.extra.xmult
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.xmult, card.ability.extra.per}}
    end,
})

SMODS.Voucher({
	key = "abacus",
	atlas = "coupons",
	pos = {x = 2, y = 1},
	cost = 10,
	unlocked = true,
	discovered = false,
	available = true,
	config = {extra = {ante_gain = 1, dollars = 25, hand_size = 1}},
	redeem = function(self, card)
        G.GAME.win_ante = G.GAME.win_ante + card.ability.extra.ante_gain
        G.hand:change_size(card.ability.extra.hand_size)
        ease_dollars(card.ability.extra.dollars)
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.ante_gain, card.ability.extra.dollars, card.ability.extra.hand_size}}
    end,
})

SMODS.Voucher({
	key = "calculator",
	atlas = "coupons",
	pos = {x = 3, y = 1},
	cost = 10,
	unlocked = true,
	discovered = false,
	available = false,
    requires = {'v_ortalab_abacus'},
	config = {extra = {ante_gain = 2, joker_slots = 2}},
	redeem = function(self, card)
        G.GAME.win_ante = G.GAME.win_ante + card.ability.extra.ante_gain
        modify_joker_slot_count(card.ability.extra.joker_slots)
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.ante_gain, card.ability.extra.joker_slots}}
    end,
})

-- SMODS.Voucher({
-- 	key = "shady_trading",
-- 	atlas = "coupons",
-- 	pos = {x = 0, y = 1},
-- 	cost = 10,
-- 	unlocked = true,
-- 	discovered = false,
-- 	available = true,
-- 	redeem = function(self, card)
--         if G.GAME.spectral_rate < 2 then
--             G.GAME.spectral_rate = 2
--         end
--         G.GAME.pool_flags.shady_trading_redeemed = true
--     end,
--     loc_vars = function(self, info_queue, card)
--         if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
--     end,
-- })

-- SMODS.Voucher({
-- 	key = "illegal_imports",
-- 	atlas = "coupons",
-- 	pos = {x = 1, y = 1},
-- 	cost = 10,
-- 	unlocked = true,
-- 	discovered = false,
-- 	available = false,
-- 	requires = {'v_ortalab_shady_trading'},
--     config = {extra = {rate = 2}},
-- 	redeem = function(self, card)
--         G.GAME.spectral_rate = G.GAME.spectral_rate * card.ability.extra.rate
--     end,
--     loc_vars = function(self, info_queue, card)
--         if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
--         return {vars = {card.ability.extra.rate}}
--     end,
-- })

SMODS.Voucher({
	key = "cantor",
	atlas = "coupons",
	pos = {x = 6, y = 1},
	cost = 10,
	unlocked = true,
	discovered = false,
	available = true,
    config = {extra = {bonus_cards = 1}},
	redeem = function(self, voucher)
        G.GAME.ortalab.vouchers.cantor = voucher.ability.extra.bonus_cards
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'crimson'} end
        return {vars = {card.ability.extra.bonus_cards}}
    end,
})

SMODS.Voucher({
	key = "tabla",
	atlas = "coupons",
	pos = {x = 7, y = 1},
	cost = 10,
	unlocked = true,
	discovered = false,
	available = true,
    config = {extra = {bonus_cards = 1}},
    requires = {'v_ortalab_cantor'},
	redeem = function(self, card)
        G.GAME.ortalab.vouchers.tabla = card.ability.extra.bonus_cards
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'crimson'} end
        return {vars = {card.ability.extra.bonus_cards}}
    end,
})

SMODS.Voucher({
	key = "leap_year",
	atlas = "coupons",
	pos = {x = 0, y = 2},
	cost = 10,
	unlocked = true,
	discovered = false,
	available = true,
    config = {extra = {bonus_level = 1}},
	redeem = function(self, card)
        G.GAME.ortalab.vouchers.leap_year = card.ability.extra.bonus_level
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.bonus_level}}
    end,
})

SMODS.Voucher({
	key = "chronomancy",
	atlas = "coupons",
	pos = {x = 1, y = 2},
	cost = 10,
	unlocked = true,
	discovered = false,
	available = true,
    config = {extra = {level_decrease_mod = 2}},
    requires = {'v_ortalab_leap_year'},
	redeem = function(self, card)
        G.GAME.ortalab.zodiacs.reduction = G.GAME.ortalab.zodiacs.reduction / card.ability.extra.level_decrease_mod
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.level_decrease_mod}}
    end,
})

SMODS.Voucher({
	key = "edition_1",
	atlas = "coupons",
	pos = {x = 0, y = 1},
	cost = 10,
	unlocked = true,
	discovered = false,
	available = true,
    config = {extra = {edition_reps = 1}},
	redeem = function(self, card)
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo'} end
        return {vars = {card.ability.extra.edition_reps}}
    end,
})

SMODS.Voucher({
	key = "edition_2",
	atlas = "coupons",
	pos = {x = 1, y = 1},
	cost = 10,
	unlocked = true,
	discovered = false,
	available = false,
    requires = {'v_ortalab_edition_1'},
    config = {extra = {edition_reps = 2}},
	redeem = function(self, card)
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo'} end
        return {vars = {card.ability.extra.edition_reps}}
    end,
})

SMODS.Voucher({
	key = "grabber_inv",
	atlas = "coupons",
	pos = {x = 6, y = 2},
	cost = 10,
	unlocked = true,
	discovered = false,
	available = true,
    config = {extra = {hands = 2, discards = -1}},
	redeem = function(self, card)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
        ease_hands_played(card.ability.extra.hands)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discards
        ease_discard(card.ability.extra.discards)
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo'} end
        return {vars = {card.ability.extra.hands, card.ability.extra.discards}}
    end,
})

SMODS.Voucher({
	key = "nacho_inv",
	atlas = "coupons",
	pos = {x = 7, y = 2},
	cost = 10,
	unlocked = true,
	discovered = false,
	available = false,
    requires = {'v_ortalab_grabber_inv'},
    config = {extra = {extra_dollars = 1}},
	redeem = function(self, card)
        G.GAME.modifiers.money_per_hand = G.GAME.modifiers.money_per_hand + card.ability.extra.extra_dollars
    end,
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'no_demo'} end
        return {vars = {card.ability.extra.extra_dollars}}
    end,
})

local BackApply_to_run_ref = Back.apply_to_run
function Back.apply_to_run(self)
	BackApply_to_run_ref(self)
    G.GAME.modifiers.booster_count = 2
    G.GAME.modifiers.voucher_count = 1
end

function window_infinite(card)
    G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls + card.ability.extra.free_rerolls
    G.GAME.current_round["ortalab_rerolls"] = (G.GAME.current_round["ortalab_rerolls"] or 0) + card.ability.extra.free_rerolls
    calculate_reroll_cost(true)
end

function Ortalab.spawn_booster()
    local card = Card(G.shop_booster.T.x + G.shop_booster.T.w/2,
    G.shop_booster.T.y, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[get_pack('shop_pack').key], {bypass_discovery_center = true, bypass_discovery_ui = true})
    create_shop_card_ui(card, 'Booster', G.shop_booster)
    card.ability.booster_pos = #G.shop_booster.cards + 1
    card:start_materialize()
    G.shop_booster:emplace(card)
end

local skip_blind = G.FUNCS.skip_blind
G.FUNCS.skip_blind = function(e)
    if G.GAME.used_vouchers['v_ortalab_hoarding'] then
        local _tag = e.UIBox:get_UIE_by_ID('tag_container')
        if _tag then
            local tag = Tag(_tag.config.ref_table.key, false, _tag.config.ref_table.ability.blind_type)
            tag:set_ability()
            add_tag(tag)
        end
    end
    skip_blind(e)
end