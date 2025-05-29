SMODS.Joker({
	key = "stonehenge",
	atlas = "jokers",
	pos = {x=3,y=1},
	rarity = 2,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	artist_credits = {'eremel'},
    calculate_most_played = function(self)
        local _handname, _played, _order = 'High Card', -1, 100
        for k, v in pairs(G.GAME.hands) do
            if v.played > _played or (v.played == _played and _order > v.order) then 
                _played = v.played
                _handname = k
            end
        end
        return _handname
    end,
	hand_contains_no_rank = function(self, hand)
		for _, card in pairs(hand) do
			if card.config.center.no_rank or SMODS.has_enhancement(card, 'm_stone') then return true end
		end
		return false
	end
})