SMODS.Joker({
	key = "shinku",
	atlas = "jokers",
	pos = {x = 4, y = 9},
    soul_pos = {x = 3, y = 9},
	rarity = 4,
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {cards_to_create = 5}},
    artist_credits = {'gappie','crimson'},
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.cards_to_create}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and context.beat_boss then
            self.remove_shinku_jokers(card)
            delay(0.7)
            return self.add_shinku_jokers(card) 
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        self.add_shinku_jokers(card).func()
    end,
    remove_from_deck = function(self, card, from_debuff)
        self.remove_shinku_jokers(card)
    end,
    add_shinku_jokers = function(card)
        local new_joker_pool = get_current_pool('Joker')
        local final_pool = {}
        for _, v in ipairs(new_joker_pool) do
            if v ~= 'UNAVAILABLE' and ((G.P_CENTERS[v].mod and G.P_CENTERS[v].mod.id == 'ortalab') or table.contains(Ortalab.ortalab_only_inclusion, v)) and G.P_CENTERS[v].perishable_compat then
                table.insert(final_pool, v)
            end
        end
        return {
            func = function()
                for i=1, card.ability.extra.cards_to_create do
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.4,
                        func = function() 
                        local new_joker = create_card('Joker', G.jokers, nil, nil, nil, nil, pseudorandom_element(final_pool, pseudoseed('shinku_spawn')))
                        new_joker:set_edition(nil, true, true)
                        new_joker:add_to_deck()
                        G.jokers:emplace(new_joker)
                        new_joker:start_materialize()
                        new_joker.ability.shinku = true
                        new_joker.ignore_base_shader = {shinku = true}
                        new_joker.ignore_shadow = {shinku = true}
                        new_joker:set_cost()
                        G.jokers.config.card_limit = G.jokers.config.card_limit + 1
                        return true
                    end}))  
                end 
            end
        }
    end,
    remove_shinku_jokers = function(card)
        local old_shinku_jokers = {}
        for _, joker in pairs(G.jokers.cards) do
            if joker.ability.shinku then
                table.insert(old_shinku_jokers, joker)
            end
        end
        if next(old_shinku_jokers) then 
            G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.cards_to_create
            SMODS.destroy_cards(old_shinku_jokers)
        end
    end
})

SMODS.DrawStep {
    key = 'shinku',
    order = 100,
    func = function(self)
        if self.ability.shinku then
            self.children.center:draw_shader('ortalab_shinku', nil, self.ARGS.send_to_shader)
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}

SMODS.Shader({key = 'shinku', path = 'shinku.fs'})