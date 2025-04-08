SMODS.Joker({
	key = "soil",
	atlas = "jokers",
	pos = {x=7,y=9},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {xmult = 1, xmult_gain = 0.5}},
	loc_vars = function(self, info_queue, card)
        if card and not card.fake_card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
		return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_gain}}
	end,
	calculate = function(self, card, context)
        if context.before then
            card.ability.extra.consecutive_ranks = 0
			card.ability.extra.last_triggered = nil
        end
		if context.cardarea == G.play and context.individual and not context.blueprint then
			if card.ability.extra.last_triggered == context.other_card.base.id then
				card.ability.extra.consecutive_ranks = card.ability.extra.consecutive_ranks + 1
				return {
					message = '+X'..card.ability.extra.xmult_gain,
					colour = G.C.RED,
					message_card = card,
				}
			end
			card.ability.extra.last_triggered = context.other_card.base.id
		end
        if context.joker_main then
			local xmult_to_add = card.ability.extra.xmult + (card.ability.extra.xmult_gain * card.ability.extra.consecutive_ranks)
            return {
                xmult = xmult_to_add
            }
        end
    end
})