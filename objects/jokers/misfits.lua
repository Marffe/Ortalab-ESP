SMODS.Joker({
	key = "misfits",
	atlas = "jokers",
	pos = {x=4,y=11},
	rarity = 3,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {xmult = 7, count = 4}},
    artist_credits = {'gappie'},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.xmult, card.ability.extra.count}}
	end,
    calculate = function(self, card, context)
        if context.joker_main and #context.scoring_hand >= card.ability.extra.count then
            local suits = {}
            local ranks = {}
            for _, played_card in ipairs(context.scoring_hand) do
                local suit = played_card.base.suit
                local rank = played_card.base.value
                if not SMODS.has_no_suit(played_card) then suits[suit] = suit end
                if not SMODS.has_no_rank(played_card) then ranks[rank] = rank end
            end
            if table.size(suits) >= card.ability.extra.count and table.size(ranks) >= card.ability.extra.count then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    end
})