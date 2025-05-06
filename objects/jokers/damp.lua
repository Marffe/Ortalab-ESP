SMODS.Joker({
	key = "damp",
	atlas = "jokers",
	pos = {x=9,y=8},
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	artist_credits = {'gappie'},
	calculate = function(self, card, context)
		if context.first_hand_drawn then
			local eval = function() return G.GAME.current_round.hands_played == 0 end
			juice_card_until(card, eval, true)
		end
		if context.after and G.GAME.current_round.hands_played == 0 then
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
				update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(G.GAME.last_hand_played, 'poker_hands'),chips = G.GAME.hands[G.GAME.last_hand_played].chips, mult = G.GAME.hands[G.GAME.last_hand_played].mult, level=G.GAME.hands[G.GAME.last_hand_played].level})
                level_up_hand(context.blueprint_card or card, G.GAME.last_hand_played, nil, 1)
                update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
			return nil, true
		end
	end
})