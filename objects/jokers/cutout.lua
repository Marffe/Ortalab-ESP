SMODS.Joker({
	key = "cutout",
	atlas = "jokers",
	pos = {x=6,y=0},
	rarity = 2,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {xmult = 3}},
	loc_vars = function(self, info_queue, card)
        if card and not card.fake_card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'kosze'} end
		return {vars = {card.ability.extra.xmult}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult
			}
		end
        if context.selling_card and context.card.config.center.set == 'Joker' then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.8,
                func = function()
                    card:start_dissolve()                
                    return true
                end
            }))
            return {
                message = localize('ortalab_cutout')
            }
        end
	end
})