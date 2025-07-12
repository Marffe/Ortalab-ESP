SMODS.Joker({
	key = "hypercalculia",
	atlas = "jokers",
	pos = {x = 4, y = 2},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {xmult = 1, xmult_gain = 0.75}},
	artist_credits = {'flare'},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_gain}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
            local faces = {}
            for _, card in ipairs(context.scoring_hand) do
                if card:is_face() then
                    faces[card.base.id] = true
                end
            end

            return {
                xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain * table.size(faces)
            }
        end
    end
})
