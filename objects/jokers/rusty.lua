SMODS.Joker({
	key = "rusty",
	atlas = "jokers",
	pos = {x = 0, y = 9},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
    enhancement_gate = 'm_ortalab_rusty',
	config = {extra = {xmult = 1, gain = 0.1}},
    artist_credits = {'gappie'},
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS['m_ortalab_rusty']
        return {vars = {card.ability.extra.gain}}
    end,
    calculate = function(self, card, context)
        if not context.end_of_round and context.individual and context.cardarea == G.hand and SMODS.has_enhancement(context.other_card, 'm_ortalab_rusty') then
            local count = calculate_rusty_amount() or 0
            return {
                xmult = card.ability.extra.xmult + (card.ability.extra.gain * count)
            }
        end
    end
})

function calculate_rusty_amount()
    local count = 0
    for _, card in ipairs(G.hand.cards) do
        if SMODS.has_enhancement(card, 'm_ortalab_rusty') then
            count = count + 1
        end
    end
    return count
end