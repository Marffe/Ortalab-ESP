SMODS.Joker({
    key = "pinkprint",
    atlas = "jokers",
    pos = {x = 7, y = 7},
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    config = {extra = {}},
    artist_credits = {'crimson'},
    loc_vars = function(self, info_queue, card)
        if card.ability.extra.last_joker then
            local vars = {}
            if card.ability.pinkprint.config.center.loc_vars then
                vars = card.ability.pinkprint.config.center:loc_vars({}, card.ability.pinkprint).vars
            else
                vars = Card.generate_UIBox_ability_table({ability = card.ability.pinkprint.ability, config = card.ability.pinkprint.config, bypass_lock = true}, true)
            end
            info_queue[#info_queue+1] = {pinkprint = true, set = 'Joker', key = card.ability.extra.last_joker, vars = vars}
        end
        return {vars = {card.ability.extra.last_joker and localize({type = 'name_text', set = 'Joker', key = card.ability.extra.last_joker}) or localize('ortalab_none')}}
    end,
    calculate = function(self, card, context)
        if context.selling_card and context.card.ability.set == 'Joker' and context.card.config.center_key ~= 'j_ortalab_pinkprint' then
            if card.ability.pinkprint then
                Card.remove_from_deck(card.ability.pinkprint)
            end
            card.ability = copy_table(context.card.ability)
            card.ability.extra.last_joker = context.card.config.center_key
            card.ability.pinkprint = {
                fake_card = true,
                pinkprint = card.ID,
                ID = card.ID,
                ability = copy_table(context.card.ability),
                config = {
                    center = G.P_CENTERS[card.ability.extra.last_joker]
                },
            }
            return {
                func = function()
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.7,
                        func = function()
                            Card.add_to_deck(card.ability.pinkprint)        
                            return true
                        end
                    }))
                end,
                message = 'Copied!',
                colour = G.C.PALE_GREEN
            }
        end
        if card.ability.extra.last_joker then
            local ret, trig = Card.calculate_joker(card.ability.pinkprint, context)
            if ret and ret.card and ret.card == card.ability.pinkprint then
                ret.card = card
            end
            return ret, trig
        end
    end,
    calc_dollar_bonus = function(self, card)
        if card.ability.extra.last_joker then
            return Card.calculate_dollar_bonus(card.ability.pinkprint)
        end
	end,
    load = function(self, card, table, other)
        if table.ability.pinkprint then table.ability.pinkprint.config.center = G.P_CENTERS[table.ability.extra.last_joker] end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if card.ability.pinkprint then
            Card.remove_from_deck(card.ability.pinkprint)
        end
    end
})

local ortalab_find_card = SMODS.find_card
function SMODS.find_card(key, count_debuffed)
    local results = ortalab_find_card(key, count_debuffed)
    if not G.jokers or not G.jokers.cards then return {} end
    for _, area in ipairs(SMODS.get_card_areas('jokers')) do
        if area.cards then
            for _, v in pairs(area.cards) do
                if v and type(v) == 'table' and v.ability and v.ability.pinkprint and v.ability.extra.last_joker == key and (count_debuffed or not v.debuff) then
                    table.insert(results, v)
                end
            end
        end
    end
    return results
end
