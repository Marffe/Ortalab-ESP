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
            if card.ability.extra.last_joker_table.config.center.loc_vars then
                vars = card.ability.extra.last_joker_table.config.center:loc_vars({}, card.ability.extra.last_joker_table).vars
            else
                vars = Card.generate_UIBox_ability_table({ability = card.ability.extra.last_joker_table.ability, config = card.ability.extra.last_joker_table.config, bypass_lock = true}, true)
            end
            info_queue[#info_queue+1] = {pinkprint = true, set = 'Joker', key = card.ability.extra.last_joker, vars = vars}
        end
        return {vars = {card.ability.extra.last_joker and localize({type = 'name_text', set = 'Joker', key = card.ability.extra.last_joker}) or localize('ortalab_none')}}
    end,
    calculate = function(self, card, context)
        if context.selling_card and context.card.ability.set == 'Joker' and context.card ~= card then
            card.ability.extra.last_joker = context.card.config.center_key
            card.ability.extra.last_joker_table = {
                fake_card = true,
                pinkprint = card.ID,
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
                            Card.add_to_deck(card.ability.extra.last_joker_table)        
                            return true
                        end
                    }))
                end,
                message = 'Copied!',
                colour = G.C.PALE_GREEN
            }
        end
        if card.ability.extra.last_joker then
            local ret, trig = Card.calculate_joker(card.ability.extra.last_joker_table, context)
            if ret and ret.card and ret.card == card.ability.extra.last_joker_table then
                ret.card = card
            end
            return ret, trig
        end
    end,
    calc_dollar_bonus = function(self, card)
        if card.ability.extra.last_joker then
            return Card.calculate_dollar_bonus(card.ability.extra.last_joker_table)
        end
	end,
    load = function(self, card, table, other)
        if table.ability.extra.last_joker_table then table.ability.extra.last_joker_table.config.center = G.P_CENTERS[table.ability.extra.last_joker] end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if card.ability.extra.last_joker_table then
            Card.remove_from_deck(card.ability.extra.last_joker_table)
        end
    end
})

local ortalab_destroy_cards = SMODS.destroy_cards
function SMODS.destroy_cards(cards, bypass_eternal, immediate)
    if not cards[1] then cards = {cards} end
    for i=1, #cards do
        if cards[i].pinkprint then
            for _, joker in pairs(G.jokers.cards) do
                if cards[i].pinkprint == joker.ID then
                    cards[i] = joker
                    ortalab_destroy_cards(cards, bypass_eternal, immediate)
                    return
                end
            end
        end
    end
    ortalab_destroy_cards(cards, bypass_eternal, immediate)
end