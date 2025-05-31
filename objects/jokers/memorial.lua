SMODS.Joker({
	key = "memorial",
	atlas = "jokers",
	pos = {x=2,y=1},
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {cards = 3, triggered = false}},
    artist_credits = {'flare', 'gappie'},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.cards}}
	end,
	calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.extra.triggered = false
            local eval = function(card) return not card.ability.extra.triggered end
            juice_card_until(card, eval, true)
        end
        if context.pre_discard and not card.ability.extra.triggered then
            local enhanced = {}
            for _, card in pairs(context.full_hand) do
                if card.config.center.set == 'Enhanced' then table.insert(enhanced, card) end
            end
            if #enhanced >= card.ability.extra.cards then
                local card_to_remember = pseudorandom_element(enhanced, pseudoseed('ortalab_memorial'))
                card_to_remember:set_edition(poll_edition('ortalab_memorial_edition', nil, false, true))
                card_to_remember:set_seal(SMODS.poll_seal({key = 'ortalab_memorial_seal', guaranteed = true}))
                SMODS.calculate_effect({message = localize('ortalab_memorial'), colour = G.C.L_BLACK, juice_card = card}, card_to_remember)
                card.ability.extra.triggered = true
            end
        end
    end
})