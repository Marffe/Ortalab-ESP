SMODS.Joker({
	key = "salad",
	atlas = "jokers",
	pos = {x=5,y=6},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,
	config = {extra = {chips = 150, change = 3}},
	loc_vars = function(self, info_queue, card)
        if card and not card.fake_card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
		return {vars = {card.ability.extra.chips, card.ability.extra.change}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
        if context.discard and not context.blueprint and card.ability.extra.chips > 0 then
            card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.change
            if card.ability.extra.chips == 0 then
                return {
                    message = localize('k_eaten_ex'),
                    message_card = card,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            func = function()                
                                card:start_dissolve()
                                return true
                            end
                        }))
                    end
                }
            else
                return {
                    message = '-'..card.ability.extra.change,
                    colour = G.C.BLUE,
                }
            end
            
        end
    end
})